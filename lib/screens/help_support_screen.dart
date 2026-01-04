import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Find answers to common questions or contact our support team.',
            ),
            const SizedBox(height: 20),
            const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text('How do I add a new goal?'),
              children: const [Padding(padding: EdgeInsets.all(12), child: Text('Tap the + button at the bottom right to create a new goal.'))],
            ),
            ExpansionTile(
              title: const Text('How do I edit a goal?'),
              children: const [Padding(padding: EdgeInsets.all(12), child: Text('Open the goal details and tap the edit icon to update it.'))],
            ),
            ExpansionTile(
              title: const Text('How are progress percentages calculated?'),
              children: const [Padding(padding: EdgeInsets.all(12), child: Text('Progress is calculated from completed milestones divided by total milestones.'))],
            ),
            const SizedBox(height: 20),
            const Text('Contact Support', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('support@goalmate.app'),
              subtitle: const Text('We typically reply within 24 hours.'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Contact Support'),
                    content: const Text('Send an email to support@goalmate.app with a description of your issue.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Report a Problem'),
                    content: const Text('Please describe the issue and include screenshots if possible.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Open Email')),
                    ],
                  ),
                );
              },
              child: const Text('Report a Problem'),
            ),
          ],
        ),
      ),
    );
  }
}
