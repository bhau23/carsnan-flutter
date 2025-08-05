import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PhoneAuthenticationPage extends StatefulWidget {
  const PhoneAuthenticationPage({super.key});

  @override
  State<PhoneAuthenticationPage> createState() =>
      _PhoneAuthenticationPageState();
}

class _PhoneAuthenticationPageState extends State<PhoneAuthenticationPage> {
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            otpSent: () => context.go('/otp'),
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
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '+1234567890',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.maybeWhen(
                        loading: () => null,
                        orElse: () => () {
                          if (_formKey.currentState?.validate() == true) {
                            context.read<AuthBloc>().add(
                              SendOtp(phoneNumber: _phoneNumberController.text),
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
                        orElse: () => const Text('Send OTP'),
                      ),
                    ),
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
    _phoneNumberController.dispose();
    super.dispose();
  }
}
