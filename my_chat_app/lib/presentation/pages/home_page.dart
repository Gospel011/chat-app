import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/business_logic/auth/auth_cubit.dart';
import 'package:my_chat_app/business_logic/chat/chat_cubit.dart';
import 'package:my_chat_app/data_layer/models/chat_model.dart';
import 'package:my_chat_app/data_layer/models/user_model.dart';
import 'package:my_chat_app/presentation/helpers/stream_helper.dart';
import 'package:my_chat_app/presentation/widgets/my_text_form_field.dart';
import 'package:my_chat_app/utils/constants.dart';
import 'package:my_chat_app/presentation/pages/login_page.dart';
import 'package:my_chat_app/presentation/widgets/chat_bubble.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  late StreamHelper typingStream;

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
    typingStream = StreamHelper();
  }

  @override
  void dispose() {
    socket.disconnect();
    typingStream.close();
    print("Called dispose");
    super.dispose();
  }

  void establishConnection() {
    socket = IO.io(
        NetWorkConstants.baseUrl,
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

    socket.on('typing', (data) {
      print("typing state: $data");
      typingStream.add(data);
    });

    socket.on('new message', (data) {
      print("New message recieved");
      Chat chat = Chat.fromMap(jsonDecode(data));

      context.read<ChatCubit>().addChat(chat);
    });
  }

  Timer? timer;

  void sendMessage() {
    timer?.cancel();
    socket.emit("typing", "");
    Chat chat =
        Chat(user: user, message: controller.text, dateTime: DateTime.now());

    socket.emit('new chat', chat);

    controller.text = "";

    FocusManager.instance.primaryFocus?.unfocus();

    context.read<ChatCubit>().addChat(chat);
  }

  

  void onChanged(String value) {
    if (timer?.isActive == true) {
      timer?.cancel();
      socket.emit('typing',
          '${context.read<AuthCubit>().state.user!.name.split(' ')[0]} is typing');
      print(
          '${context.read<AuthCubit>().state.user!.name.split(' ')[0]} is typing');
      timer = Timer(const Duration(seconds: 3), () {
        socket.emit('typing', "");
        print("Not typing");
      });
    } else {
      timer = Timer(const Duration(seconds: 2), () {
        print("Empty timer");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: StreamBuilder(
            stream: typingStream.stream,
            initialData: "",
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print("Current snapshot: ${snapshot.data}");
              return ListTile(
                  title: const Text("Chat"),
                  subtitle: snapshot.hasData && snapshot.data != ""
                      ? Text(snapshot.data)
                      : null);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
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
                                  onChanged: onChanged,
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
                                  }ilesCot
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
