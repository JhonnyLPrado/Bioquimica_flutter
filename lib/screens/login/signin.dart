// This is ALWAYS pushed, it's safe to pop.
import 'package:flutter/material.dart';
import 'package:movil/main.dart';
import 'package:provider/provider.dart';
import 'package:movil/providers/auth_provider.dart';

/*
final pb = PocketBase(
  'http://127.0.0.1:8090',
); // I wonder if I should refactor so there is only one of these passed as an argument.
Guess what. Idiot.
*/

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              obscureText: true,
              controller: _passwordConfirmationController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final authService = Provider.of<PocketBaseAuthNotifier>(
                    context,
                    listen: false,
                  );
                  await authService.signUp(
                    _emailController.text,
                    _passwordController.text,
                    _passwordConfirmationController.text,
                  );
                  if (mounted) {
                    // Good idea to send the new user directly to homepage here.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Sign In failed: $e')));
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
