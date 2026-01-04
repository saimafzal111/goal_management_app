import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _localImagePath = '';
  String _localImageBase64 = '';

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: user.userName);
    _emailController = TextEditingController(text: user.userEmail);
    _localImagePath = user.userImagePath;
    _localImageBase64 = user.userImageBase64;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Provider.of<UserProvider>(context, listen: false).setUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        imagePath: _localImagePath.isNotEmpty ? _localImagePath : null,
        imageBase64: _localImageBase64.isNotEmpty ? _localImageBase64 : null,
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked == null) return;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      _localImageBase64 = base64Encode(bytes);
      _localImagePath = '';
    } else {
      _localImagePath = picked.path;
      _localImageBase64 = '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _localImageBase64.isNotEmpty
                      ? MemoryImage(base64Decode(_localImageBase64)) as ImageProvider
                      : (_localImagePath.isNotEmpty
                          ? FileImage(File(_localImagePath))
                          : null),
                  child: (_localImageBase64.isEmpty && _localImagePath.isEmpty)
                      ? const Icon(Icons.camera_alt_outlined, size: 28, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // email optional
                  final email = v.trim();
                  final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                  return emailRegex.hasMatch(email) ? null : 'Enter a valid email';
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
