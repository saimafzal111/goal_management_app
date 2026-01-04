import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final authUser = authProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
                }
              },
              child: Builder(builder: (context) {
                ImageProvider? avatarImage;
                if (userProvider.userImageBase64.isNotEmpty) {
                  try {
                    avatarImage = MemoryImage(base64Decode(userProvider.userImageBase64));
                  } catch (_) {
                    avatarImage = null;
                  }
                } else if (userProvider.userImagePath.isNotEmpty && !kIsWeb) {
                  avatarImage = FileImage(File(userProvider.userImagePath));
                } else {
                  avatarImage = null; // show initials when no image
                }

                final nameSource = authUser?.name ?? userProvider.userName;
                final initials = nameSource
                    .split(' ')
                    .where((s) => s.isNotEmpty)
                    .map((s) => s[0])
                    .take(2)
                    .join()
                    .toUpperCase();

                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: avatarImage,
                  child: avatarImage == null
                      ? Text(
                          initials.isNotEmpty ? initials : 'U',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : null,
                );
              }),
            ),
            const SizedBox(height: 24),
            Text(
              authUser?.name ?? userProvider.userName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Builder(builder: (context) {
              final dynamic auEmail = authUser?.email;
              String displayEmail = '';
              if (auEmail is String && auEmail.isNotEmpty) {
                displayEmail = auEmail;
              } else if (userProvider.userEmail.isNotEmpty) {
                displayEmail = userProvider.userEmail;
              }

              return Text(
                displayEmail.isNotEmpty ? displayEmail : 'user@example.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
              );
            }),
            const SizedBox(height: 40),
            _buildProfileItem(context, Icons.person_outline, 'Edit Profile'),
            _buildProfileItem(context, Icons.notifications_outlined, 'Notifications'),
            _buildProfileItem(context, Icons.security_outlined, 'Security'),
            _buildProfileItem(context, Icons.help_outline, 'Help & Support'),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Logout',
              isOutlined: true,
              onPressed: () {
                // Logout from Appwrite and clear user data
                Provider.of<UserProvider>(context, listen: false).logout();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () async {
        if (title == 'Help & Support') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
          );
          return;
        }

        if (title == 'Edit Profile') {
          final result = await Navigator.push<bool?>(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
          }
        }
      },
    );
  }
}
