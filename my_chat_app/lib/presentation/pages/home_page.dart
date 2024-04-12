import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/business_logic/auth/auth_cubit.dart';
import 'package:my_chat_app/business_logic/chat/chat_cubit.dart';
import 'package:my_chat_app/data_layer/models/chat_model.dart';
import 'package:my_chat_app/data_layer/models/user_model.dart';
import 'package:my_chat_app/presentation/widgets/my_text_form_field.dart';
import 'package:my_chat_app/utils/constants.dart';
import 'package:my_chat_app/presentation/pages/login_page.dart';
import 'package:my_chat_app/utils/date_time_formatter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;

  final TextEditingController controller = TextEditingController();
  late final User user;
  final ScrollController scrollController = ScrollController();

  // Chat get chat => Chat(
  //     user: User(name: "Gospel", phone: "09010233544"),
  //     message:
  //         "Hi Godfrey. I saw the business offer you sent me and I'm interested. I'd fly you over so we'd talk more and that's if you're open to it of course",
  //     dateTime: DateTime.now());

  String? validator(String? value) {
    return null;
  }

  void scrollToBottom() {
    print('Scrolling to bottom');
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    establishConnection();
    user = context.read<AuthCubit>().state.user!;
  }

  @override
  void dispose() {
    socket.disconnect();
    print("Called dispose");
    super.dispose();
  }

  void establishConnection() {
    socket = IO.io(
        '${NetWorkConstants.baseUrl}/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()
            .build());

    socket.connect();

    handleSocketEvents();
  }

  void handleSocketEvents() {
    socket.onConnect((data) => print("Connected: $data"));
    socket.onConnectError((data) => print("Connection error: $data"));
    socket.onDisconnect((data) => print("Connection disconnected: $data"));

    print("connect?");

    socket.on('clients-total', (data) {
      print("Total clients: $data");
    });

    socket.on('new message', (data) {
      print("New message recieved");
      Chat chat = Chat.fromMap(jsonDecode(data));

      context.read<ChatCubit>().addChat(chat);
    });
  }

  void sendMessage() {
    Chat chat =
        Chat(user: user, message: controller.text, dateTime: DateTime.now());

    socket.emit('new chat', chat);

    controller.text = "";

    context.read<ChatCubit>().addChat(chat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), actions: [
        IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout))
      ]),
      body: SizedBox(
        width: double.maxFinite,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            //* LIST OF C H A T S
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child:
                  BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  scrollToBottom();
                });
                return ListView.builder(
                  itemCount: state.chats.length,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    Chat chat = state.chats[index];

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ChatBubble(
                        chat: chat,
                        isMine: chat.user.phone == user.phone,
                      ),
                    );
                  },
                );
              }),
            ),

            //* M E S S A G E   T E X T F E I L D
            BlocBuilder<ChatCubit, ChatState>(builder: (context, _) {
              return Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              // height: 48,
                              child: MyTextFormField(
                                  controller: controller,
                                  validator: validator,
                                  maxLines: 5,
                                  minLines: 1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  if (controller.text != '') {
                                    print("Sending message");

                                    sendMessage();
                                  }
                                },
                                icon: Icon(Icons.send)),
                          )
                        ],
                      ),
                    ),
                  ));
            })
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.chat, required this.isMine});

  final Chat chat;
  final bool isMine;

  DateTimeFormatted get _dateTime => formatDateTime(chat.dateTime);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine == true ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // sender image
          isMine == false ? const Avatar() : const SizedBox(),

          // message box
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 3 / 4),
            decoration: BoxDecoration(
                color: isMine == true
                    ? AppColors.deepPurple
                    : AppColors.lightPurple,
                borderRadius: isMine == true
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8))
                    : const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8))),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  Text(
                    chat.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // text
                  Text(
                    chat.message,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  // date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dateTime.time,
                        style: const TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                ]),
          ),

          isMine == true ? const Avatar() : const SizedBox(),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey.shade400,
      ),
    );
  }
}
