import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/data_layer/models/chat_model.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial(chats: []));

  void addChat(Chat chat) {
    List<Chat> chats = [...state.chats];

    chats.add(chat);

    emit(NewChats(chats: chats));
  }
}
