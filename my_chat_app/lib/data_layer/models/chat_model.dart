// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_chat_app/data_layer/models/user_model.dart';

class Chat {
  final User user;
  final String message;
  final DateTime dateTime;
  Chat({
    required this.user,
    required this.message,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'message': message,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      message: map['message'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Chat(user: $user, message: $message, dateTime: $dateTime)';

  Chat copyWith({
    User? user,
    String? message,
    DateTime? dateTime,
  }) {
    return Chat(
      user: user ?? this.user,
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
