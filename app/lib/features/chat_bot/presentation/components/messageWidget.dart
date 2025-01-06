import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ChatWidgetMessageBubble extends StatelessWidget {
  final String sender;
  final Function()? onTap;

  const ChatWidgetMessageBubble({
    super.key,
    required this.sender,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isUserMessage = sender == 'user';

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap, // Correctly invoke the `onTap` function here
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "🆕 Start New Conversation",
                textStyle: TextStyle(
                  color: isUserMessage
                      ? Colors.white
                      : const Color.fromARGB(255, 30, 51, 212),
                  fontSize: 20,
                ),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
      ),
    );
  }
}
