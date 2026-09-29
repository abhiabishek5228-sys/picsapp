import 'package:flutter/material.dart';
class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff111726),
          side: const BorderSide(
            color: Color(0xff30364A),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}