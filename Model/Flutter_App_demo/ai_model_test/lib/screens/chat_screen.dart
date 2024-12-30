import 'package:flutter/material.dart';
import '../services/medical_classifier_service.dart';
import '../services/ai_chat_service.dart';
import '../models/chat_message.dart';
import '../widgets/message_input.dart';
import '../utils/error_handler.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MedicalClassifierService _classifierService =
      MedicalClassifierService();
  final AIChatService _aiService = AIChatService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    try {
      final diagnosis = await _classifierService.getDiagnosis(text);
      setState(() {
        _messages.add(ChatMessage(
          text: 'Based on your symptoms, you might have: $diagnosis',
          isUser: false,
        ));
      });

      final explanation = await _aiService.getDetailedExplanation(diagnosis);
      setState(() {
        _messages.add(ChatMessage(text: explanation, isUser: false));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandler.getErrorMessage(e))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Assistant'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          MessageInput(
            controller: _messageController,
            isLoading: _isLoading,
            onSubmit: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
