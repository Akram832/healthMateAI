import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:app/features/auth/presentation/cubits/auth_states.dart';
import 'package:app/features/chat_bot/presentation/components/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatWidgetMessageBubble extends StatelessWidget {
  final Function()? onTap;
  final String sender;

  const ChatWidgetMessageBubble({
    super.key,
    required this.sender,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isUserMessage = sender == 'user';
    final authCubit = context.read<AuthCubits>();
    final user = (authCubit.state as Authenticated).patient;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          ChatMessageBubble(
              sender: "bot",
              message:
                  "👋 Welcome ${user.firstName} to HealthMateAI! 🌟 This is a prototype 🤖 designed to assist you with medical insights and guidance. 🩺 Describe your symptoms, and I'll do my best to provide useful information or advice. ⚠️ Please note: This is not a substitute for professional medical consultation."),
          GestureDetector(
            onTap: () {
              print("New conversation tapped");
              onTap?.call(); // Ensure this triggers `startNewConversation`
            }, // Correctly invoke the `onTap` function here
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                      "🆕 Click here to Start New Conversation",
                      textStyle: TextStyle(
                        color: const Color.fromARGB(255, 30, 51, 212),
                        fontSize: 20,
                      ),
                      speed: Duration(milliseconds: 50)),
                ],
                isRepeatingAnimation: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
