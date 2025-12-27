import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  final TextEditingController _newPasswordController = TextEditingController();
  double _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {
        _passwordStrength = _getPasswordStrength(_newPasswordController.text);
      });
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildPasswordTextField(
                label: 'Current Password',
                obscureText: !_currentPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _currentPasswordVisible = !_currentPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordTextField(
                label: 'New Password',
                obscureText: !_newPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _newPasswordVisible = !_newPasswordVisible;
                  });
                },
                controller: _newPasswordController,
              ),
              const SizedBox(height: 8),
              PasswordStrengthIndicator(strength: _passwordStrength),
              const SizedBox(height: 16),
              _buildPasswordTextField(
                label: 'Confirm New Password',
                obscureText: !_confirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  double _getPasswordStrength(String password) {
    if (password.isEmpty) {
      return 0;
    }

    double strength = 0;
    if (password.length >= 8) {
      strength += 0.25;
    }
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      strength += 0.25;
    }
    if (RegExp(r'[a-z]').hasMatch(password)) {
      strength += 0.25;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) {
      strength += 0.25;
    }

    return strength;
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    String strengthText;
    Color strengthColor;

    if (strength < 0.5) {
      strengthText = 'Weak';
      strengthColor = Colors.red;
    } else if (strength < 0.75) {
      strengthText = 'Medium';
      strengthColor = Colors.orange;
    } else {
      strengthText = 'Strong';
      strengthColor = Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strengthText,
          style: TextStyle(
            color: strengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strength,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
        ),
      ],
    );
  }
}
