import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum UserInitialStatus {
  noFound,
  fillProfileKid,
  fillProfileMentor,
  successKid,
  successMentor,
  banned,
}

Future<UserInitialStatus> getUserStatus(BuildContext context) async {
  try {
    UserModel? userModel = context.read<UserCubit>().state;
    late DocumentSnapshot userSnap;

    if (userModel == null) {
      final User user = FirebaseAuth.instance.currentUser!;
      userSnap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!userSnap.exists) {
        await FirebaseAuth.instance.signOut();
        return UserInitialStatus.noFound;
      }

      userModel = UserModel.fromFirestore(userSnap);
      if (context.mounted) context.read<UserCubit>().setUser(userModel);
    }

    if (userModel.banned) return UserInitialStatus.banned;
    if (userModel.profileFilled) {
      userModel = UserModel.fromFirestore(userSnap);
      if (context.mounted) context.read<UserCubit>().setUser(userModel);
      return userModel.isKid ? UserInitialStatus.successKid : UserInitialStatus.successMentor;
    } else {
      return userModel.isKid ? UserInitialStatus.fillProfileKid : UserInitialStatus.fillProfileMentor;
    }
  } catch (e) {
    print('Произошла ошибка {getUserStatus}: $e');
    return UserInitialStatus.noFound;
  }
}

final ValueNotifier<bool> isRedirectLoading = ValueNotifier(false);

Future<void> redirectFunc(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  final isAuth = user != null;

  if (isAuth) {
    final userStatus = await getUserStatus(context);
    FlutterNativeSplash.remove();
    initialRoute.value = getRouteForStatus(userStatus);
  } else {
    FlutterNativeSplash.remove();
    initialRoute.value = null;
  }

  isCheckingAuth.value = false;
  isFirstRedirect.value = false;
}

String? getRouteForStatus(UserInitialStatus status) {
  switch (status) {
    case UserInitialStatus.noFound:
      return '/auth';
    case UserInitialStatus.fillProfileKid:
      return '/auth/kid/info';
    case UserInitialStatus.fillProfileMentor:
      return '/auth/mentor/info';
    case UserInitialStatus.successKid:
      return '/kid/search';
    case UserInitialStatus.successMentor:
      return '/mentor/search';
    case UserInitialStatus.banned:
      return '/banned';
    default:
      return null;
  }
}

final ValueNotifier<bool> isCheckingAuth = ValueNotifier(true);
final ValueNotifier<bool> isFirstRedirect = ValueNotifier(true);
final ValueNotifier<String?> initialRoute = ValueNotifier(null);

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/auth',
  debugLogDiagnostics: false,
  refreshListenable: isCheckingAuth,
  redirect: (context, state) async {
    if (isCheckingAuth.value) return '/splash';
    return isFirstRedirect.value ? initialRoute.value : null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: '/banned',
      builder: (context, state) => const BannedScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Маршруты авторизации
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: 'role',
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        // GoRoute(
        //   path: 'login_phone',
        //   builder: (context, state) => const LoginPhoneAuthScreen(),
        // ),
        // GoRoute(
        //   path: 'signup_phone',
        //   builder: (context, state) => const SignupPhoneAuthScreen(),
        // ),
        // GoRoute(
        //   path: 'verify',
        //   builder: (context, state) => const PhoneVerificationScreen(),
        // ),
        // GoRoute(
        //   path: 'performer/info',
        //   builder: (context, state) => const PerformerInfoScreen(),
        // ),
        // GoRoute(
        //   path: 'performer/competency',
        //   builder: (context, state) => const SelectCompetencyScreen(),
        // ),
        // GoRoute(
        //   path: 'performer/add_worker',
        //   builder: (context, state) => const AddWorkerScreen(),
        // ),

        // GoRoute(
        //   path: 'performer/finish',
        //   builder: (context, state) => const PerformerFinishScreen(),
        // ),
        // GoRoute(
        //   path: 'customer/inn',
        //   builder: (context, state) => const CustomerInnScreen(),
        // ),
        // GoRoute(
        //   path: 'customer/about',
        //   builder: (context, state) => const CustomerCompanyAboutScreen(),
        // ),
      ],
    ),

    // Маршруты заказчика
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => KidMainScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/kid/bonus',
              builder: (context, state) => const KidBonusScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/kid/chat',
              builder: (context, state) => const ChatTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/kid/profile',
              builder: (context, state) => const ProfileTabScreen(),
            ),
          ],
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MentorMainScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mentor/bonus',
              builder: (context, state) => const MentorBonusScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mentor/chat',
              builder: (context, state) => const ChatTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mentor/profile',
              builder: (context, state) => const ProfileTabScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
);
