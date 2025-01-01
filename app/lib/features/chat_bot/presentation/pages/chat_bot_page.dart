import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _messageController = TextEditingController();
  late String userId;

  List<Map<String, dynamic>> conversations = []; // List of conversations

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubits>();
    userId = authCubit.currentUser!.uId; // Get userId from AuthCubits
    _fetchChats(); // Fetch existing chats
  }

  /// Fetch chats from Firestore
  void _fetchChats() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          conversations = List<Map<String, dynamic>>.from(
              data?['conversations'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching chats: $e");
    }
  }

  /// Save chats to Firestore
  void _saveChats() async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(userId)
          .set({'conversations': conversations});
    } catch (e) {
      print("Error saving chats: $e");
    }
  }

  /// Add message to the current conversation
  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final botResponse = await _getAIResponse(message); // Get AI response
    setState(() {
      if (conversations.isEmpty) {
        conversations.add({'title': 'New Conversation', 'messages': []});
      }
      conversations.last['messages'].add({'sender': 'user', 'message': message});
      conversations.last['messages']
          .add({'sender': 'bot', 'message': botResponse});
    });

    _saveChats(); // Save updated chats to Firestore
    _messageController.clear(); // Clear input field
  }

  /// Get AI response from Gemini
  Future<String> _getAIResponse(String userInput) async {
    // Placeholder for AI model interaction
    return "This is a dynamic response for: $userInput"; // Replace with actual model call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChatBot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conversations.isNotEmpty
                  ? conversations.last['messages'].length
                  : 0,
              itemBuilder: (context, index) {
                final message = conversations.last['messages'][index];
                return ListTile(
                  title: Text(
                    "${message['sender']}: ${message['message']}",
                    style: TextStyle(
                        color: message['sender'] == 'user'
                            ? Colors.blue
                            : Colors.green),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
