import 'package:app/features/chat_bot/presentation/components/account_info.dart';
import 'package:flutter/material.dart';

class ConversationDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> conversations;
  final Function(int) onConversationSelected;
  final VoidCallback onNewConversation;

  const ConversationDrawer({
    super.key,
    required this.conversations,
    required this.onConversationSelected,
    required this.onNewConversation,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Use the new AccountInfoHeader widget
          AccountInfoHeader(
            userName: "John Doe", // Replace with dynamic user name
            userEmail: "johndoe@example.com", // Replace with dynamic email
            profileImageUrl: null, // Optional: Provide a profile image URL
            onEditProfile: () {
              // Handle "Edit Profile" functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit Profile clicked")),
              );
            },
          ),

          // List of Conversations
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ListTile(
                  title: Text(
                    conversation["title"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Last updated: ${conversation['lastUpdated']}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    onConversationSelected(index);
                    Navigator.pop(context); // Close the drawer
                  },
                );
              },
            ),
          ),

          // "Start New Conversation" Option
          ListTile(
            leading: const Icon(Icons.add, color: Colors.blueAccent),
            title: const Text(
              "Start New Conversation",
              style: TextStyle(color: Colors.blueAccent),
            ),
            onTap: () {
              onNewConversation();
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
