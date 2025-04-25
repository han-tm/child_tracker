import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> members;
  final ChatType type;
  final LastMessage? lastMessage;
  final DateTime updatedAt;
  final Map<String, int> unreads;
  final String? kid;
  final String? mentor;

  ChatModel({
    required this.id,
    required this.members,
    required this.type,
    required this.lastMessage,
    required this.updatedAt,
    required this.unreads,
    this.kid,
    this.mentor,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: doc.id,
      members: List<String>.from(data['members'] ?? []),
      type: data['type'] != null ? ChatType.values.byName(data['type']) : ChatType.private,
      lastMessage: data['last_message'] != null ? LastMessage.fromMap(data['last_message']) : null,
      updatedAt: (data['last_edit_time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreads: Map<String, int>.from(
        (data['unreads'] ?? {}).map(
          (k, v) => MapEntry(k, (v ?? 0) as int),
        ),
      ),
      kid: data['kid'],
      mentor: data['mentor'],
    );
  }

  DocumentReference get ref => FirebaseFirestore.instance.collection('chats').doc(id);


  int getUnreadCount(String userId) => unreads[userId] ?? 0;
}

class LastMessage {
  final String text;
  final String senderId;
  final DateTime timestamp;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.timestamp,
  });

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      text: map['text'] ?? '',
      senderId: map['sender'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
