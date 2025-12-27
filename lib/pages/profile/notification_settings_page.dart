import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _enableAll = true;
  bool _sound = true;
  bool _vibration = true;
  bool _attendanceReminders = true;
  bool _salesUpdates = true;
  bool _deliveryStatus = false;
  bool _inventoryLow = true;
  bool _leaveRequest = true;
  bool _holidayReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('General Notifications'),
            _buildNotificationCard([
              _buildNotificationToggle(
                label: 'Enable All Notifications',
                value: _enableAll,
                onChanged: (value) => setState(() => _enableAll = value),
              ),
              _buildNotificationToggle(
                label: 'Sound',
                value: _sound,
                onChanged: (value) => setState(() => _sound = value),
              ),
              _buildNotificationToggle(
                label: 'Vibration',
                value: _vibration,
                onChanged: (value) => setState(() => _vibration = value),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Activity Alerts'),
            _buildNotificationCard([
              _buildNotificationToggle(
                label: 'Attendance Reminders',
                value: _attendanceReminders,
                onChanged: (value) =>
                    setState(() => _attendanceReminders = value),
              ),
              _buildNotificationToggle(
                label: 'Sales Updates',
                value: _salesUpdates,
                onChanged: (value) => setState(() => _salesUpdates = value),
              ),
              _buildNotificationToggle(
                label: 'Delivery Status Changes',
                value: _deliveryStatus,
                onChanged: (value) => setState(() => _deliveryStatus = value),
              ),
              _buildNotificationToggle(
                label: 'Inventory Low Stock',
                value: _inventoryLow,
                onChanged: (value) => setState(() => _inventoryLow = value),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('HR & Leave'),
            _buildNotificationCard([
              _buildNotificationToggle(
                label: 'Leave Request Status',
                value: _leaveRequest,
                onChanged: (value) => setState(() => _leaveRequest = value),
              ),
              _buildNotificationToggle(
                label: 'Holiday Reminders',
                value: _holidayReminders,
                onChanged: (value) => setState(() => _holidayReminders = value),
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

  Widget _buildNotificationCard(List<Widget> children) {
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

  Widget _buildNotificationToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
}
