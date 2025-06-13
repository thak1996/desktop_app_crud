import 'package:flutter/material.dart';

import '../../core/colors.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: AppColors.whiteColor)),
      ),
    );
  }
}
