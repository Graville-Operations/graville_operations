
import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const CustomCircleButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: FloatingActionButton(
        heroTag: icon.toString(),
        mini: true,
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
