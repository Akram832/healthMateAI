import 'package:app/features/chat_bot/presentation/components/message.dart';
import 'package:flutter/material.dart';
// Assurez-vous que ce chemin est correct

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages =
      []; // Liste des messages (user/bot)

  void sendMessage() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        // Ajouter le message de l'utilisateur à la liste
        messages.add({'sender': 'user', 'message': controller.text.trim()});
      });
      controller.clear(); // Réinitialiser le champ de texte

      // Simuler une réponse automatique du bot
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          messages.add({'sender': 'bot', 'message': 'This is a bot response!'});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 2, 105, 149),
                    Color.fromARGB(255, 25, 40, 56),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'Chat Bot Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Action pour "Home"
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                // Action pour "About"
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('About'),
                      content: const Text('This is a chat bot application.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Action pour "Settings"
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 105, 149), // Couleur de début
              Color.fromARGB(255, 25, 40, 56), // Couleur de fin
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
                  color: Colors
                      .white, // Remplacez cette couleur par celle souhaitée
                ),
                title: const Text(
                  "Chat Bot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Liste des messages
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatMessageBubble(
                      sender: message['sender']!,
                      message: message['message']!,
                    );
                  },
                ),
              ),
              // Champ d'entrée et bouton d'envoi
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: sendMessage, // Appeler la fonction d'envoi
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
