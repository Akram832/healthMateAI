import 'package:app/features/chat_bot/presentation/components/app_drawer.dart';
import 'package:app/features/chat_bot/presentation/components/message.dart';
import 'package:app/features/chat_bot/presentation/components/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http; // Add this for API calls
import 'dart:convert';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();

  // Conversations and flow management
  List<Map<String, dynamic>> conversations = [];
  int currentConversationIndex = 0;
  String userSymptoms = ""; // Stores user-provided symptoms

  // Conversation states
  bool isAskingSymptoms = true; // True when bot is asking for symptoms

  @override
  void initState() {
    super.initState();

    // Initialize with the first conversation
    conversations.add({
      "title": "Conversation 1",
      "messages": [],
      "lastUpdated": DateTime.now(),
    });

    // Start the bot flow
    askForSymptoms();
  }

  // Function to start the symptoms collection
  void askForSymptoms() {
    setState(() {
      conversations[currentConversationIndex]["messages"].add({
        "sender": "bot",
        "message": "Please describe all the symptoms you're experiencing.",
      });
    });
  }

  // Function to handle user response
  void handleUserResponse() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        // Add user's message to chat
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

    // Simulate processing and make an API call to the AI model
    final aiResponse = await callAIModel(input);

    // Generate a Gemini prompt from the AI response
    final geminiPrompt = await generateGeminiPrompt(aiResponse);

    // Display the response from Gemini
    setState(() {
      conversations[currentConversationIndex]["messages"].add({
        "sender": "bot",
        "message":
            "Based on your symptoms: '$input', here's what I found: $geminiPrompt",
      });

      // Update the lastUpdated timestamp
      conversations[currentConversationIndex]["lastUpdated"] = DateTime.now();
    });
  }

  // Function to call the AI model API
  Future<String> callAIModel(String symptoms) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://your-ai-model-api-endpoint.com/process"), // Replace with your API endpoint
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"symptoms": symptoms}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["result"]; // Assuming the API response has a "result" field
      } else {
        return "Error: Unable to process your symptoms.";
      }
    } catch (e) {
      return "Error: Something went wrong while processing your symptoms.";
    }
  }

  // Function to generate a Gemini prompt
  Future<String> generateGeminiPrompt(String aiResponse) async {
    // Create the prompt based on the AI response
    String prompt = """
      The patient has been diagnosed or identified with the following condition: $aiResponse.

      Please provide the following information:
      1. A brief explanation of the condition, including what it is and its impact on health.
      2. Potential causes or risk factors for this condition.
      3. Recommended treatments, management strategies, or lifestyle changes that can help address the condition.
      4. Advice on when to seek further medical attention or consult a specialist.

      Ensure the response is detailed, yet clear and actionable for the user.
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
          });
        },
        onNewConversation: () {
          setState(() {
            conversations.add({
              "title": "Conversation ${conversations.length + 1}",
              "messages": [],
              "lastUpdated": DateTime.now(),
            });
            currentConversationIndex = conversations.length - 1;
            userSymptoms = "";
            isAskingSymptoms = true;
            askForSymptoms();
          });
        },
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
                    return ChatMessageBubble(
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
} // Add this for JSON encoding/decoding


