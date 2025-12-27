import 'package:flutter/material.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Display'),
            _buildSettingsCard(context, [
              _buildSettingsMenuItem(
                label: 'Text Size',
                onTap: () {},
              ),
              _buildSettingsMenuItem(
                label: 'Theme',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Data & Sync'),
            _buildSettingsCard(context, [
              _buildSyncToggle(
                label: 'Auto-Sync Data',
                description: 'Automatically sync data in background',
                value: _autoSync,
                onChanged: (value) => setState(() => _autoSync = value),
              ),
              _buildSettingsMenuItem(
                label: 'Clear Cache',
                subtitle: 'Free up storage',
                onTap: () {},
              ),
              _buildSettingsMenuItem(
                label: 'Download Data Offline',
                subtitle: 'Download all data for offline use',
                trailing: const Icon(Icons.file_download),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('About App'),
            _buildSettingsCard(context, [
              _buildInfoMenuItem(
                context,
                label: 'App Version',
                value: 'v1.2.5',
              ),
              _buildSettingsMenuItem(
                label: 'Check for Updates',
                onTap: () {},
              ),
              _buildSettingsMenuItem(
                label: 'Licenses & Open Source',
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

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
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

  Widget _buildSettingsMenuItem({
    required String label,
    String? subtitle,
    Widget? trailing,
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
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSyncToggle({
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
          Expanded(
            child: Column(
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
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoMenuItem(BuildContext context, {required String label, required String value}) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
