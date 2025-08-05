import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailAuthenticationPage extends StatefulWidget {
  const EmailAuthenticationPage({super.key});

  @override
  State<EmailAuthenticationPage> createState() =>
      _EmailAuthenticationPageState();
}

class _EmailAuthenticationPageState extends State<EmailAuthenticationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (user) => context.go('/'),
            mfaRequired: () => context.go('/mfa'),
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            ),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (_isSignUp && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => () {
                          if (_formKey.currentState?.validate() == true) {
                            if (_isSignUp) {
                              context.read<AuthBloc>().add(
                                SignUpWithEmail(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            } else {
                              context.read<AuthBloc>().add(
                                SignInWithEmail(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      child: state.maybeWhen(
                        loading: () => const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        orElse: () => Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign In'
                          : 'Don\'t have an account? Sign Up',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/phone-auth'),
                    icon: const Icon(Icons.phone),
                    label: const Text('Use Phone Authentication'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
