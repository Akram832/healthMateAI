import 'package:app/features/chat_bot/presentation/components/message.dart';
import 'package:app/features/chat_bot/presentation/components/message_input.dart';
import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 105, 149),
              Color.fromARGB(255, 25, 40, 56), // Ending color (green)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(
                child: Text(
              "Chat Bot",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
          ),
          body: Center(
              child: Column(
            children: [
              ChatMessageBubble(sender: 'user', message: 'hello'),
              ChatMessageBubble(sender: 'users', message: 'pipa'),
              Row(
                children: [
                  TextInput(controller: controller, hintText: "hintText"),
                  Icon(Icons.send_sharp)
                ],
              )
            ],
          )),
        ));
  }
}
