import 'package:flutter/material.dart';

class AccountInfoHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;
  final VoidCallback onEditProfile;

  const AccountInfoHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 2, 105, 149),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 32,
                        color: Color.fromARGB(255, 2, 105, 149),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Account Name and Email (constrained)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1, // Avoid overflow by limiting to 1 line
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1, // Avoid overflow by limiting to 1 line
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),

          // Edit Profile Button
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: onEditProfile,
              child: Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  const Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
