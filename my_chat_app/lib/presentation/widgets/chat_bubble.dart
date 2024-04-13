import 'package:flutter/material.dart';
import 'package:my_chat_app/data_layer/models/chat_model.dart';
import 'package:my_chat_app/utils/date_time_formatter.dart';
import 'package:my_chat_app/utils/constants.dart';
import 'package:my_chat_app/presentation/widgets/avatar.dart';

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
                    style: const TextStyle(fontWeight: FontWeight.w500),
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
