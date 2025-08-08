import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/editable_profile_field.dart';
import '../widgets/date_of_birth_field.dart';
import '../widgets/gender_field.dart';
import '../widgets/profile_actions_section.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        getUserProfileUseCase: context.read(),
        updateUserProfileUseCase: context.read(),
      )..loadUserProfile(userId),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.hasError && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Profile not found',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Get userId from context or navigation
                      context.read<ProfileCubit>().loadUserProfile('current_user');
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Column(
              children: [
                ProfileHeader(
                  profile: state.profile!,
                  isEditing: state.isEditing,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Profile Information',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!state.isEditing) ...[
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<ProfileCubit>().startEditing();
                                },
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  foregroundColor: const Color(0xFF2C2C2C),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<ProfileCubit>().cancelEditing();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.colorScheme.outline,
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: state.isLoading
                                        ? null
                                        : () {
                                            context.read<ProfileCubit>().saveProfile();
                                          },
                                    icon: state.isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF2C2C2C),
                                            ),
                                          )
                                        : const Icon(Icons.save, size: 18),
                                    label: const Text('Save Changes'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4AF37),
                                      foregroundColor: const Color(0xFF2C2C2C),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Contact Information Section
                        _buildSectionHeader(context, 'Contact Information'),
                        const SizedBox(height: 12),
                        EditableProfileField(
                          label: 'Full Name',
                          value: state.isEditing
                              ? state.editingValues['name'] ?? state.profile!.name
                              : state.profile!.name,
                          isEditing: state.isEditing,
                          icon: Icons.person_outlined,
                          onChanged: (value) {
                            context.read<ProfileCubit>().updateEditingValue('name', value);
                          },
                        ),
                        EditableProfileField(
                          label: 'Email Address',
                          value: state.isEditing
                              ? state.editingValues['email'] ?? state.profile!.email
                              : state.profile!.email,
                          isEditing: state.isEditing,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            context.read<ProfileCubit>().updateEditingValue('email', value);
                          },
                        ),
                        EditableProfileField(
                          label: 'Mobile Number',
                          value: state.isEditing
                              ? state.editingValues['mobile'] ?? state.profile!.mobile
                              : state.profile!.mobile,
                          isEditing: state.isEditing,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            context.read<ProfileCubit>().updateEditingValue('mobile', value);
                          },
                        ),
                        EditableProfileField(
                          label: 'Full Address',
                          value: state.isEditing
                              ? state.editingValues['address'] ?? state.profile!.address
                              : state.profile!.address,
                          isEditing: state.isEditing,
                          icon: Icons.location_on_outlined,
                          maxLines: 3,
                          onChanged: (value) {
                            context.read<ProfileCubit>().updateEditingValue('address', value);
                          },
                        ),

                        const SizedBox(height: 24),
                        
                        // Personal Information Section
                        _buildSectionHeader(context, 'Personal Information'),
                        const SizedBox(height: 12),
                        DateOfBirthField(
                          dateOfBirth: state.profile!.dateOfBirth,
                          isEditing: state.isEditing,
                          onChanged: (dateOfBirth) {
                            context.read<ProfileCubit>().updateDateOfBirth(dateOfBirth);
                          },
                        ),
                        GenderField(
                          gender: state.profile!.gender,
                          isEditing: state.isEditing,
                          onChanged: (gender) {
                            context.read<ProfileCubit>().updateGender(gender);
                          },
                        ),

                        const SizedBox(height: 24),
                        
                        // Account Actions Section
                        _buildSectionHeader(context, 'Account Settings'),
                        const SizedBox(height: 12),
                        ProfileActionsSection(
                          onLogout: () => _showLogoutDialog(context),
                          onDeleteAccount: () => _showDeleteAccountDialog(context),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement logout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout functionality coming soon!'),
                    backgroundColor: Color(0xFFD4AF37),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF2C2C2C),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete account functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion coming soon!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD4AF37),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
