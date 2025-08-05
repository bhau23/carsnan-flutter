import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MfaVerificationPage extends StatefulWidget {
  const MfaVerificationPage({super.key});

  @override
  State<MfaVerificationPage> createState() => _MfaVerificationPageState();
}

class _MfaVerificationPageState extends State<MfaVerificationPage> {
  final _smsCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Factor Authentication'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (user) => context.go('/'),
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
                    Icons.security,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Two-Factor Authentication',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We\'ve sent a verification code to your registered phone number. Please enter it below to complete sign in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _smsCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Verification Code',
                      hintText: 'Enter 6-digit code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.sms_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the verification code';
                      }
                      if (value.length != 6) {
                        return 'Verification code must be 6 digits';
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
                            context.read<AuthBloc>().add(
                              VerifyMfa(smsCode: _smsCodeController.text),
                            );
                          }
                        },
                      ),
                      child: state.maybeWhen(
                        loading: () => const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        orElse: () => const Text('Verify Code'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const SignOut());
                      context.go('/email-auth');
                    },
                    child: const Text('Cancel and Sign Out'),
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
    _smsCodeController.dispose();
    super.dispose();
  }
}
