import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await authService.signInWithGoogle();
          },
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
