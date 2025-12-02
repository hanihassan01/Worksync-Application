import 'package:flutter/material.dart';

class AddItemButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPhone;

  const AddItemButton({
    super.key,
    required this.onPressed,
    required this.isPhone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: onPressed,

        icon: const Icon(Icons.add, color: Colors.green),
        label: Text(
          'Add Row',
          style: TextStyle(color: Colors.green, fontSize: isPhone ? 14 : 16),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green, width: 2),
          padding: EdgeInsets.symmetric(vertical: isPhone ? 10 : 14),
        ),
      ),
    );
  }
}
