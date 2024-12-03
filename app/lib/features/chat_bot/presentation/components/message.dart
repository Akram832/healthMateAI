import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final String sender;
  final String message;

  // Add a named `key` parameter
  const ChatMessageBubble(
      {Key? key, required this.sender, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the message is sent by the current user or someone else
    bool isUserMessage = sender == 'user';

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
