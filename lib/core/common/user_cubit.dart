import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_tracker/index.dart';

class UserCubit extends Cubit<UserModel?> {
  final FirebaseFirestore _fs;

  UserCubit({
    required FirebaseFirestore fs,
  })  : _fs = fs,
        super(null);

  void setUser(UserModel? newUser) => emit(newUser);

  void getUser() {
    _fs.app;
  }

  Future<void> getAndSet(User user) async {
    try {
      final doc = await _fs.collection('users').doc(user.uid).get();
      final userModel = UserModel.fromFirestore(doc);
      setUser(userModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setNotification(bool value) async {
    await state?.ref.update({'notification': value});
    emit(state?.copyWith(notification: value));
  }

  Future<void> setDairyNotification(bool value) async {
    await state?.ref.update({'dairy_notification': value});
    emit(state?.copyWith(dairyNotification: value));
  }

  Future<void> addDairyMember(DocumentReference ref) async {
    await state?.ref.update({
      'dairy_members': FieldValue.arrayUnion([ref])
    });
    emit(state?.copyWith(dairyMembers: List.from(state!.dairyMembers)..add(ref)));
  }

  Future<void> deleteDairyMember(DocumentReference ref) async {
    await state?.ref.update({
      'dairy_members': FieldValue.arrayRemove([ref])
    });
    emit(state?.copyWith(dairyMembers: List.from(state!.dairyMembers)..remove(ref)));
  }

  Future<void> onDeleteFcmToken() async {
    await state?.ref.update({'fcm_token': null});
    emit(null);
  }

  Future<UserModel> getUserByRef(DocumentReference ref) async {
    final doc = await ref.get();
    return UserModel.fromFirestore(doc);
  }

  Future<bool> addRequestToConnection(DocumentReference kidRef) async {
    if (state == null) return false;
    try {
      await state?.ref.update({
        'connection_requests': FieldValue.arrayUnion([kidRef])
      });
      await kidRef.update({
        'connection_requests': FieldValue.arrayUnion([state!.ref])
      });
      emit(state!.copyWith(connectionRequests: List.from(state!.connectionRequests)..add(kidRef)));
      return true;
    } catch (e) {
      print('error: {addRequestToConnection}: ${e.toString()}');
      return false;
    }
  }

  Future<bool> acceptConnection(DocumentReference mentorRef) async {
    if (state == null) return false;
    try {
      await state?.ref.update({
        'connections': FieldValue.arrayUnion([mentorRef])
      });
      await mentorRef.update({
        'connections': FieldValue.arrayUnion([state!.ref])
      });
      emit(state!.copyWith(connections: List.from(state!.connections)..add(mentorRef)));
      return true;
    } catch (e) {
      print('error: {acceptConnection}: ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteConnection(DocumentReference userRef) async {
    if (state == null) return false;
    try {
      await state?.ref.update({
        'connections': FieldValue.arrayRemove([userRef]),
        'connection_requests': FieldValue.arrayRemove([userRef])
      });
      await userRef.update({
        'connections': FieldValue.arrayRemove([state!.ref]),
        'connection_requests': FieldValue.arrayRemove([state!.ref])
      });
      emit(state!.copyWith(
        connections: List.from(state!.connections)..remove(userRef),
        connectionRequests: List.from(state!.connectionRequests)..remove(userRef),
      ));
      return true;
    } catch (e) {
      print('error: {acceptConnection}: ${e.toString()}');
      return false;
    }
  }

  Future<void> onChangePoint(int amount) async {
    if (state == null) return;
    try {
      await state?.ref.update({'points': FieldValue.increment(amount)});

      emit(state!.copyWith(
        points: state!.points + amount,
      ));
    } catch (e) {
      print('error: {onChangePoint}: ${e.toString()}');
    }
  }

  Future<void> onGameComplete(
    Map<String, dynamic> newGameDoc,
    int points,
    DocumentReference? level,
  ) async {
    await state?.userGamesCollection.add(newGameDoc);

    final newDoc = {
      'game_points': FieldValue.increment(points),
    };

    if (level != null) {
      newDoc['completed_levels'] = FieldValue.arrayUnion([level]);
    }

    await state?.ref.update(newDoc);

    final completedLevels = state?.completedLevels ?? [];
    if (level != null) {
      completedLevels.add(level);
    }

    emit(state?.copyWith(
      gamePoints: state!.gamePoints + points,
      completedLevels: completedLevels,
    ));
  }

  Future<void> markAsDeleted() async {
    final myConnections = state?.connections ?? [];
    for (final connection in myConnections) {
      await connection.update({
        'connections': FieldValue.arrayRemove([state!.ref]),
        'connection_requests': FieldValue.arrayRemove([state!.ref]),
      });
    }

    await state?.ref.update({
      'deleted': true,
      'banned': null,
      'photo': null,
      'type': null,
      'email': null,
      'phone': null,
      'profile_filled': false,
      'name': null,
      'connections': null,
      'connection_requests': null,
      'game_points': 0,
      'points': 0,
      'age': null,
      'city': null,
      'completed_levels': null,
      'dairy_members': null,
      'dairy_notification': null,
      'notification': null,
      'trial_subscription': null,
      'premium_subscription': null,
      'fcm_token': null,
    });
  }
}
