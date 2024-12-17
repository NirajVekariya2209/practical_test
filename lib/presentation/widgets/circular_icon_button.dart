import 'package:flutter/material.dart';

import '../../core/app_color.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon; // Icon to display
  final VoidCallback onTap; // Tap action callback

  const CircularIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: onTap, // Handle taps
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: AppColor.primaryColor,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
