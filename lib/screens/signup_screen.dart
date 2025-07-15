import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/signup/signup_bloc.dart';
import '../bloc/signup/signup_event.dart';
import '../bloc/signup/signup_state.dart';

class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text("Create Account")),
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Account created successfully")),
              );
            } else if (state is SignupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Signup failed: ${state.error}")),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SignupBloc>().add(
                        SignupSubmitted(
                          emailController.text.trim(),
                          passwordController.text,
                        ),
                      );
                    },
                    child: (state is SignupLoading)
                        ? CircularProgressIndicator()
                        : Text('Sign Up'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
