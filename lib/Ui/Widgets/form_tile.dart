import 'package:flutter/material.dart';
import '../../app_colors.dart';

class FormTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const FormTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.lightGrey,
          child: Icon(icon, color: AppColors.orange),
        ),
        title: Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        subtitle: Text(
          value.isEmpty ? 'Select' : value,
          style: TextStyle(
            fontSize: 16,
            color: value.isEmpty ? Colors.grey : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down_rounded,
            color: Colors.grey),
      ),
    );
  }
}
