import 'package:app/features/chat_bot/presentation/components/app_drawer.dart';
import 'package:app/features/chat_bot/presentation/components/message_input.dart';
import 'package:flutter/material.dart';
import 'package:app/features/chat_bot/presentation/components/message.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();

  // List of conversations
  List<Map<String, dynamic>> conversations = [];
  int currentConversationIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize with the first conversation
    conversations.add({
      "title": "Conversation 1",
      "messages": [],
      "lastUpdated": DateTime.now(),
    });
  }

  // Function to send a message
  void sendMessage() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        // Add user's message to the current conversation
        conversations[currentConversationIndex]["messages"].add({
          "sender": "user",
          "message": controller.text.trim(),
        });

        // Update lastUpdated timestamp
        conversations[currentConversationIndex]["lastUpdated"] = DateTime.now();
      });

      controller.clear();

      // Simulate a bot response
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          conversations[currentConversationIndex]["messages"].add({
            "sender": "bot",
            "message": "This is a bot response!",
          });

          // Update lastUpdated timestamp again
          conversations[currentConversationIndex]["lastUpdated"] =
              DateTime.now();
        });
      });
    }
  }

  // Function to start a new conversation
  void startNewConversation() {
    setState(() {
      conversations.add({
        "title": "Conversation ${conversations.length + 1}",
        "messages": [],
        "lastUpdated": DateTime.now(),
      });

      // Switch to the new conversation
      currentConversationIndex = conversations.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentConversation = conversations[currentConversationIndex];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: ConversationDrawer(
        conversations: conversations,
        onConversationSelected: (index) {
          setState(() {
            currentConversationIndex = index;
            controller.clear();
            // Update to the selected conversation
          });
        },
        onNewConversation: startNewConversation,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 105, 149), // Start color
              Color.fromARGB(255, 25, 40, 56), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                title: Text(
                  currentConversation["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // List of messages
              Expanded(
                child: FutureBuilder(
                  future: Future.delayed(
                      const Duration(milliseconds: 100)), // Simulate delay
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator during the "reload"
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // Show the messages for the current conversation
                      final currentConversation =
                          conversations[currentConversationIndex];
                      return ListView.builder(
                        itemCount: currentConversation["messages"].length,
                        itemBuilder: (context, index) {
                          final message =
                              currentConversation["messages"][index];
                          return ChatMessageBubble(
                            sender: message["sender"],
                            message: message["message"],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // Input field and send button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: TextInput(
                            controller: controller,
                            hintText: "Type your message...",
                          )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
