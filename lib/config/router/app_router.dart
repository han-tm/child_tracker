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
    SnackBarSerive.showErrorSnackBar(defaultErrorText);
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
    final storageService = sl<StorageService>();
    bool showed = storageService.isOnboardShowed();
    FlutterNativeSplash.remove();
    if (!showed) {
      initialRoute.value = '/onboarding';
    } else {
      initialRoute.value = null;
    }
  }

  isCheckingAuth.value = false;
  isFirstRedirect.value = false;
}

String? getRouteForStatus(UserInitialStatus status) {
  switch (status) {
    case UserInitialStatus.noFound:
      return '/auth';
    case UserInitialStatus.fillProfileKid:
      return '/auth/role';
    case UserInitialStatus.fillProfileMentor:
      return '/auth/role';
    case UserInitialStatus.successKid:
      return '/kid_bonus';
    case UserInitialStatus.successMentor:
      return '/mentor_bonus';
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
          path: 'verify',
          builder: (context, state) => LoginOtpScreen(phone: state.extra as String),
        ),
        GoRoute(
          path: 'role',
          builder: (context, state) => const RoleSelectionScreen(),
        ),
        GoRoute(
          path: 'fill_data',
          builder: (context, state) => const FillDataScreen(),
        ),
        GoRoute(
          path: 'city_search',
          builder: (context, state) => CitySearchScreen(onSelected: state.extra as Function(String)),
        ),
        GoRoute(
          path: 'take_subscription_plan',
          builder: (context, state) => const TakeSubscriptionPlanScreen(),
        ),
        GoRoute(
          path: 'kid_signup_success',
          builder: (context, state) => const KidSignupSuccessScreen(),
        ),
      ],
    ),

    // Маршруты ребенка
    ShellRoute(
      builder: (context, state, child) => KidMainScreen(state: state, child: child),
      routes: [
        GoRoute(
          path: '/kid_bonus',
          builder: (context, state) => const BonusTabScreen(),
        ),
        GoRoute(
          path: '/kid_task',
          builder: (context, state) => const TaskTabScreen(),
        ),
        GoRoute(
          path: '/kid_games',
          builder: (context, state) => const GamesTabScreen(),
        ),
        GoRoute(
          path: '/kid_chat',
          builder: (context, state) => const ChatTabScreen(),
        ),
        GoRoute(
          path: '/kid_profile',
          builder: (context, state) => const ProfileTabScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => MentorMainScreen(state: state, child: child),
      routes: [
        GoRoute(
          path: '/mentor_bonus',
          builder: (context, state) => const BonusTabScreen(),
        ),
        GoRoute(
          path: '/mentor_task',
          builder: (context, state) => const TaskTabScreen(),
        ),
        GoRoute(
          path: '/mentor_chat',
          builder: (context, state) => const ChatTabScreen(),
        ),
        GoRoute(
          path: '/mentor_profile',
          builder: (context, state) => const ProfileTabScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/connections',
      builder: (context, state) => const MyConnectionsScreen(),
    ),
    GoRoute(
      path: '/add_connection',
      builder: (context, state) => const AddConnectionScreen(),
    ),
    GoRoute(
      path: '/scan_qr',
      builder: (context, state) => const ScanQRScreen(),
    ),
    GoRoute(
      path: '/city_search',
      builder: (context, state) => CitySearchScreen(onSelected: state.extra as Function(String)),
    ),
    GoRoute(
      path: '/logout_result',
      builder: (context, state) => LogoutResultScreen(message: state.extra as String),
    ),
    GoRoute(
      path: '/add_chat',
      builder: (context, state) => const AddChatScreen(),
    ),
     GoRoute(
      path: '/new_chat_success',
      builder: (context, state) => NewChatSuccessCreateScreen(ref: state.extra as DocumentReference),
    ),
    GoRoute(
      path: '/chat_room',
      builder: (context, state) => ChatRoomScreen(chatRef: state.extra as DocumentReference),
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
);
