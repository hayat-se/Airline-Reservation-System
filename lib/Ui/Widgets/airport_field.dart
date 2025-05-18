import 'package:flutter/material.dart';

class AirportField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const AirportField({
    super.key,
    required this.label,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Text(value ?? 'Select', style: TextStyle(
            color: value == null ? Colors.grey : Colors.black)),
      ),
    );
  }
}
