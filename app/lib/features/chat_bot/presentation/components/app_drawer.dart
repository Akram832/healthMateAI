import 'package:app/features/auth/presentation/cubits/auth_states.dart';
import 'package:app/features/chat_bot/presentation/components/account_info.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/presentation/pages/auth_page.dart ';

class ConversationDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> conversations;
  final Function(int) onConversationSelected;
  final VoidCallback onNewConversation;
  final Function(int) onDeleteConversation;

  const ConversationDrawer({
    super.key,
    required this.conversations,
    required this.onConversationSelected,
    required this.onNewConversation,
    required this.onDeleteConversation,
  });

  @override
  Widget build(BuildContext context) {
    // Get the authenticated user data directly from the AuthCubits state
    final authCubit = context.read<AuthCubits>();
    final user = (authCubit.state as Authenticated).patient;

    return Drawer(
      child: Column(
        children: [
          // Display user details directly
          AccountInfoHeader(
            userName: "${user.firstName} ${user.lastName}",
            userEmail: user.email,
            profileImageUrl: null, // Optional: Provide a profile image URL
            onLogOut: () {
              authCubit.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthPage()),
                (route) => false,
              );
            },
          ),

          // List of Conversations
          Expanded(
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return Dismissible(
                  key: ValueKey(conversation["title"]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    onDeleteConversation(index);
                  },
                  child: ListTile(
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
                      Navigator.pop(context); // Close the drawer
                      onConversationSelected(index);
                    },
                  ),
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
