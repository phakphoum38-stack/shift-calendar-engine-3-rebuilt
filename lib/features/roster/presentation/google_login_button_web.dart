import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox(
        width: 240,
        height: 44,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(width: 260, height: 44, child: web.renderButton());
  }
}
