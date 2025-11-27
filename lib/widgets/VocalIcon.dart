import 'package:flutter/material.dart';

class VocalIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const VocalIcon({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF491B6D),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          isActive ? Icons.volume_up : Icons.volume_off,
          color: Colors.white,
          size: 24,
        ),
        onPressed: onPressed,
      ),
    );
  }
}