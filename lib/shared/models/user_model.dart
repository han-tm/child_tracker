import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fio;
  final String? photo;
  final UserType? userType;
  final bool profileFilled;
  final bool banned;
  final DateTime? createdAt;
  final String? phone;
  final String? fcmToken;

  UserModel({
    required this.fio,
    required this.id,
    this.photo,
    this.userType,
    this.profileFilled = false,
    this.banned = false,
    this.createdAt,
    this.phone,
    this.fcmToken,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fio: data['name'] ?? '',
      photo: data['photo'],
      userType: data['type'] != null ? UserType.values.byName(data['type']) : null,
      profileFilled: data['profile_filled'] ?? false,
      banned: data['banned'] ?? false,
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      phone: data['phone'],
      fcmToken: data['fcm_token'],
    );
  }

  bool get isKid => userType == UserType.kid;

  UserModel copyWith({
    String? id,
    String? fio,
    String? photo,
    UserType? userType,
    bool? profileFilled,
    String? phone,
    bool? banned,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fio: fio ?? this.fio,
      photo: photo ?? this.photo,
      userType: userType ?? this.userType,
      profileFilled: profileFilled ?? this.profileFilled,
      banned: banned ?? this.banned,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
    );
  }
}
