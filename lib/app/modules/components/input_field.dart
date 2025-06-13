import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
  });
  final String hint;
  final IconData icon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(icon: Icon(icon), hintText: hint),
        style: TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );
  }
}
