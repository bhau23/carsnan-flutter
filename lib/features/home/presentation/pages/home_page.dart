import 'package:carsnan/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_event.dart';
import 'package:carsnan/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const SignOut());
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            ),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            authenticated: (user) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildUserInfoRow('User ID', user.uid),
                          _buildUserInfoRow('Phone Number', user.phoneNumber),
                          if (user.displayName != null)
                            _buildUserInfoRow(
                              'Display Name',
                              user.displayName!,
                            ),
                          if (user.email != null)
                            _buildUserInfoRow('Email', user.email!),
                          if (user.createdAt != null)
                            _buildUserInfoRow(
                              'Account Created',
                              _formatDateTime(user.createdAt!),
                            ),
                          if (user.lastSignInAt != null)
                            _buildUserInfoRow(
                              'Last Sign In',
                              _formatDateTime(user.lastSignInAt!),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const SignOut());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const Center(child: Text('Please authenticate')),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
