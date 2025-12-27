import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worksync/pages/profile/address_details_page.dart';
import 'package:worksync/pages/profile/app_settings_page.dart';
import 'package:worksync/pages/profile/change_password_page.dart';
import 'package:worksync/pages/profile/help_support_page.dart';
import 'package:worksync/pages/profile/notification_settings_page.dart';
import 'package:worksync/pages/profile/privacy_security_page.dart';
import 'package:worksync/pages/profile/widgets/profile_card.dart';
import 'package:worksync/pages/profile/widgets/section_title.dart';
import 'package:worksync/pages/profile/widgets/menu_list_item.dart';
import 'package:worksync/pages/profile/widgets/toggle_switch.dart';
import 'package:worksync/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _enableBiometrics = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(
              name: 'Alex Johnson',
              email: 'alex.j@worksync.com',
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDYJvKEZ3UFWlvpmnXnUrr0hwejlUmmmQXqpcNZFenKFT2JAE9QLkgxORD0IhvNi8-ihmN95HOiDqDT5a5z2MCLfVfaSLlydkx349kEi91utmAD2Qs3bauLETyG2soNQq8PTua2_PBfQE5BWk2CVjS1PKV_61VeTsXub9WJKaOmzS8b3NyYUHs-3tTiI99SSxVVDkSBzCvjLMXydseXrJhEJj06WO7N53BMtpXDhmFGDCT5CfhN2tT3BGhwoV6Vbv4jV_cxeTHPwBg',
            ),
            const SectionTitle(title: 'Address & Security'),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  MenuListItem(
                    icon: Icons.location_on_outlined,
                    label: 'Saved Address',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressDetailsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    trailing: ToggleSwitch(
                      value: themeProvider.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.fingerprint,
                    label: 'Enable Biometrics',
                    trailing: ToggleSwitch(
                      value: _enableBiometrics,
                      onChanged: (value) {
                        setState(() {
                          _enableBiometrics = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SectionTitle(title: 'Settings'),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  MenuListItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notification',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.security_outlined,
                    label: 'Privacy & Security',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacySecurityPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  MenuListItem(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppSettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showSignOutDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.orange.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}
