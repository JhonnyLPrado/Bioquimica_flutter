// This is ALWAYS pushed, it's safe to pop.
import 'package:flutter/material.dart';
import 'package:movil/main.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../utils/auth_util.dart';

final pb = PocketBase(
  'http://127.0.0.1:8090',
); // I wonder if I should refactor so there is only one of these passed as an argument.

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
                  final body = <String, dynamic>{
                    "email": _emailController.text,
                    "password": _passwordController.text,
                    "passwordConfirm": _passwordConfirmationController.text,
                  };

                  final record = await pb
                      .collection('users')
                      .create(body: body);

                  // Log in the user immediately after successful registration
                  await pb
                      .collection('users')
                      .authWithPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
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
