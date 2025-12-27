import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Popular Topics'),
            _buildHelpCard(context, [
              _buildHelpMenuItem('How to Clock In/Out?'),
              _buildHelpMenuItem('Manage Sales Orders'),
              _buildHelpMenuItem('Troubleshooting Sync Issues'),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Support'),
            _buildHelpCard(context, [
              _buildHelpMenuItem(
                'Chat with Support',
                leading: const Icon(Icons.chat, color: Colors.green),
              ),
              _buildHelpMenuItem(
                'Email Us',
                leading: const Icon(Icons.email, color: Colors.blue),
              ),
              _buildHelpMenuItem(
                'Call Support',
                leading: const Icon(Icons.phone, color: Colors.orange),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Guides & Tutorials'),
            _buildHelpCard(context, [
              _buildHelpMenuItem(
                'User Manual',
                leading: const Icon(Icons.menu_book),
              ),
              _buildHelpMenuItem(
                'Video Tutorials',
                leading: const Icon(Icons.play_circle),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search FAQs or Articles...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildHelpMenuItem(String label, {Widget? leading}) {
    return ListTile(
      leading: leading,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
