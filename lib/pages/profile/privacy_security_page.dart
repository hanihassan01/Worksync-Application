import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _shareUsageData = true;
  bool _personalizedContent = false;
  bool _twoFactorAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Data & Activity'),
            _buildPrivacyCard([
              _buildPrivacyToggle(
                label: 'Share Usage Data',
                description: 'Helps us improve app performance',
                value: _shareUsageData,
                onChanged: (value) => setState(() => _shareUsageData = value),
              ),
              _buildPrivacyToggle(
                label: 'Personalized Content',
                description: 'Show tailored suggestions',
                value: _personalizedContent,
                onChanged: (value) =>
                    setState(() => _personalizedContent = value),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Account Security'),
            _buildPrivacyCard([
              _buildPrivacyToggle(
                label: 'Two-Factor Authentication',
                description: 'Adds an extra layer of security',
                value: _twoFactorAuth,
                onChanged: (value) => setState(() => _twoFactorAuth = value),
              ),
              _buildPrivacyMenuItem(
                label: 'Login Activity',
                onTap: () {},
              ),
              _buildPrivacyMenuItem(
                label: 'Connected Devices',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Legal & Policies'),
            _buildPrivacyCard([
              _buildPrivacyMenuItem(
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _buildPrivacyMenuItem(
                label: 'Terms of Service',
                onTap: () {},
              ),
            ]),
          ],
        ),
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

  Widget _buildPrivacyCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPrivacyToggle({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyMenuItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
