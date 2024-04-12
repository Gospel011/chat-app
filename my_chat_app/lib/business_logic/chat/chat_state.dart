// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_cubit.dart';

class ChatState {
  final List<Chat> chats;
  ChatState({
    required this.chats,
  });
  

  ChatState copyWith({
    List<Chat>? chats,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
    );
  }

  @override
  String toString() => 'ChatState(chats: $chats)';
}


class ChatInitial extends ChatState {
  ChatInitial({required super.chats});
}

class NewChats extends ChatState {
  NewChats({required super.chats});
}

