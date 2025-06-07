import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String? photo;
  final UserType? userType;
  final bool profileFilled;
  final bool banned;
  final DateTime? createdAt;
  final String? phone;
  final String? fcmToken;
  final String? city;
  final int? age;
  final bool notification;
  final List<DocumentReference> connections;
  final List<DocumentReference> connectionRequests;

  UserModel({
    required this.name,
    required this.id,
    this.photo,
    this.userType,
    this.profileFilled = false,
    this.banned = false,
    this.createdAt,
    this.phone,
    this.fcmToken,
    this.city,
    this.age,
    this.notification = true,
    this.connections = const [],
    this.connectionRequests = const [],
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      photo: data['photo'],
      userType: data['type'] != null ? UserType.values.byName(data['type']) : null,
      profileFilled: data['profile_filled'] ?? false,
      banned: data['banned'] ?? false,
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      phone: data['phone'],
      fcmToken: data['fcm_token'],
      city: data['city'],
      age: data['age'],
      notification: data['notification'] ?? true,
      connections: (data['connections'] as List<dynamic>? ?? []).map((e) => e as DocumentReference).toList(),
      connectionRequests: (data['connection_requests'] as List<dynamic>? ?? []).map((e) => e as DocumentReference).toList(),
    );
  }

  bool get isKid => userType == UserType.kid;

  DocumentReference get ref => FirebaseFirestore.instance.collection('users').doc(id);

  bool hasInConnections(DocumentReference ref) => connections.contains(ref);

  UserModel copyWith({
    String? id,
    String? name,
    String? photo,
    UserType? userType,
    bool? profileFilled,
    String? phone,
    bool? banned,
    DateTime? createdAt,
    String? fcmToken,
    String? city,
    int? age,
    bool? notification,
    List<DocumentReference>? connections,
    List<DocumentReference>? connectionRequests,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      userType: userType ?? this.userType,
      profileFilled: profileFilled ?? this.profileFilled,
      banned: banned ?? this.banned,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      city: city ?? this.city,
      age: age ?? this.age,
      notification: notification ?? this.notification,
      connections: connections ?? this.connections,
      connectionRequests: connectionRequests ?? this.connectionRequests,
    );
  }
}
