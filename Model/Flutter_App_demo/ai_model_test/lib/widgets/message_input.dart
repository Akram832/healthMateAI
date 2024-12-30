import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Function(String) onSubmit;

  const MessageInput({
    Key? key,
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Describe your symptoms...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: isLoading ? null : (text) => onSubmit(text),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: isLoading ? null : () => onSubmit(controller.text),
          ),
        ],
      ),
    );
  }
}
