import 'package:app/features/chat_bot/presentation/components/messageWidget.dart';
import 'package:app/features/chat_bot/presentation/components/message_input.dart';
import 'package:app/features/chat_bot/presentation/pages/medical_classifier_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/features/chat_bot/presentation/components/app_drawer.dart'; // Ensure this is the correct path
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:app/features/chat_bot/presentation/components/message.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();
  final MedicalClassifierService _classifierService =
      MedicalClassifierService();

  // Conversations and flow management
  List<Map<String, dynamic>> conversations = [];
  int currentConversationIndex = 0;
  String userSymptoms = ""; // Stores user-provided symptoms

  // Conversation states
  bool isAskingSymptoms = true; // True when bot is asking for symptoms
  bool _isLoading = true; // For Firestore loading state
  late String userId;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubits>();
    userId = authCubit.currentUser?.uId ?? ''; // Ensure userId is valid

    if (userId.isNotEmpty) {
      _fetchChats();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Firestore: Fetch existing chats
  Future<void> _fetchChats() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          conversations =
              List<Map<String, dynamic>>.from(data?['conversations'] ?? []);
          _isLoading = false;
        });
      } else {
        // Initialize with an empty conversation if no data exists
        await FirebaseFirestore.instance.collection('chats').doc(userId).set({
          'conversations': [],
        });
        setState(() {
          conversations = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching chats: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Firestore: Save updated chats
  Future<void> _saveChats() async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(userId).set({
        'conversations': conversations,
      });
    } catch (e) {
      print("Error saving chats: $e");
    }
  }

  // Function to start the symptoms collection
// Function to start the symptoms collection
  void askForSymptoms() {
    setState(() {
      // Add a bot message to the current conversation
      conversations[currentConversationIndex]["messages"].add({
        "sender": "bot",
        "message": "Please describe all the symptoms you're experiencing.",
      });
      conversations[currentConversationIndex]["lastUpdated"] = DateTime.now();
    });

    // Save the updated chats to Firestore
    _saveChats();
  }

  // Function to handle user response
  void handleUserResponse() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        // Add user's message to the current conversation
        conversations[currentConversationIndex]["messages"].add({
          "sender": "user",
          "message": controller.text.trim(),
        });

        if (isAskingSymptoms) {
          // Store the symptoms provided by the user
          userSymptoms = controller.text.trim();

          // Process the user input
          processUserInput(userSymptoms);

          isAskingSymptoms = false; // End the symptom collection phase
        }

        controller.clear(); // Clear the input field
      });
      _saveChats(); // Save updated conversations
    }
  }

  void startNewConversation() {
    setState(() {
      conversations.add({
        "title": "Conversation ${conversations.length + 1}",
        "messages": [], // Start with an empty message array
        "lastUpdated": DateTime.now(),
      });

      // Set the new conversation as active
      currentConversationIndex = conversations.length - 1;

      // Reset state variables for the new conversation
      userSymptoms = "";
      isAskingSymptoms = true;

      // Add the bot's initial message for symptoms
      askForSymptoms();
    });
  }

  void _deleteConversation(int index) async {
    setState(() {
      conversations.removeAt(index);
    });
    await _saveChats(); // Save updated conversations to Firestore
  }

  Future<String> generateGeminiPrompt(String aiResponse) async {
    // Create the prompt based on the AI response
    String prompt = """
      The patient has been diagnosed with $aiResponse.

Write a brief and clear explanation of the condition and its impact on health.
Keep the response short and concise, as it will be displayed on a phone screen.
Format the response with headings and bullet points for easy readability, avoiding unnecessary symbols or markdown-like syntax.
Include practical advice, such as recommended treatments, lifestyle changes, or management strategies.
Provide user-specific guidance, such as: "Please consult a doctor if symptoms worsen, persist, or do not improve."
Ensure the response is actionable, easy to read, and tailored for a mobile user experience.
      """;

    try {
      // Execute the prompt in Gemini
      final value = await Gemini.instance.prompt(parts: [
        Part.text(prompt),
      ]);

      // Check if value or output is null and handle it gracefully
      if (value == null || value.output == null) {
        return "Error: No response was returned from Gemini.";
      }

      return value.output!; // Output is guaranteed to be non-null here
    } catch (e) {
      // Handle exceptions
      return "Error: Failed to process the prompt. ${e.toString()}";
    }
  }

  // Function to process user input
  void processUserInput(String input) async {
    // Add a bot acknowledgment message
    setState(() {
      conversations[currentConversationIndex]["messages"].add({
        "sender": "bot",
        "message":
            "Thank you! I have noted your symptoms. Let me process the information.",
      });
    });

    // Save interim chats to Firestore
    _saveChats();

    // Simulate processing and make an API call to the AI model
    final aiResponse = await _classifierService.getDiagnosis(input);
    final geminiPrompt = await generateGeminiPrompt(aiResponse);

    // Display the response from the AI model
    setState(() {
      conversations[currentConversationIndex]["title"] = aiResponse;
      conversations[currentConversationIndex]["messages"].add({
        "sender": "bot",
        "message":
            "Based on your symptoms: '$input', here's what I found: $geminiPrompt",
      });

      // Update the lastUpdated timestamp
      conversations[currentConversationIndex]["lastUpdated"] = DateTime.now();
    });

    // Save final response to Firestore
    _saveChats();
  }

  // Function to call the AI model API
  @override
  Widget build(BuildContext context) {
    final currentConversation = conversations.isNotEmpty
        ? conversations[currentConversationIndex]
        : {
            "messages": [
              {
                "sender": "bot",
                "message":
                    "👋 Welcome to HealthMateAI! 🌟 This is a prototype 🤖 designed to assist you with medical insights and guidance. 🩺 Describe your symptoms, and I'll do my best to provide useful information or advice. ⚠️ Please note: This is not a substitute for professional medical consultation.",
              },
              {"sender": "bot", "messageWidget": true}
            ],
            "title": "Start a new conversation"
          };

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: ConversationDrawer(
        conversations: conversations,
        onConversationSelected: (index) {
          setState(() {
            currentConversationIndex = index;
            controller.clear();
          });
        },
        onNewConversation: () {
          startNewConversation(); // Initialize the conversation with the bot's first message
        },
        onDeleteConversation: (index) => _deleteConversation(index),
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
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  currentConversation["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentConversation["messages"].length,
                  itemBuilder: (context, index) {
                    final message = currentConversation["messages"][index];
                    return message.containsKey("messageWidget")
                        ? ChatWidgetMessageBubble(
                            sender: message["sender"],
                            onTap: () {
                              startNewConversation(); // Create a new conversation when tapped
                            },
                          )
                        : ChatMessageBubble(
                            sender: message["sender"],
                            message: message["message"],
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextInput(
                        controller: controller,
                        hintText: "Type your Symptoms...",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: handleUserResponse,
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
