import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final AuthBloc authBloc;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.authBloc,
  }) : super(const ProfileState());

  Future<void> loadUserProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, error: null));

    try {
      final result = await getUserProfileUseCase.call(userId);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: ProfileStatus.error,
              error: failure.message,
            ),
          );
        },
        (profile) {
          emit(
            state.copyWith(
              status: ProfileStatus.loaded,
              profile: profile,
              editingValues: {
                'name': profile.displayName,
                'email': profile.email ?? '',
                'mobile': profile.phoneNumber ?? '',
                'address': profile.address ?? '',
              },
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void startEditing() {
    if (state.profile != null) {
      emit(
        state.copyWith(
          isEditing: true,
          editingValues: {
            'name': state.profile!.displayName,
            'email': state.profile!.email ?? '',
            'mobile': state.profile!.phoneNumber ?? '',
            'address': state.profile!.address ?? '',
          },
        ),
      );
    }
  }

  void cancelEditing() {
    emit(state.copyWith(isEditing: false));
  }

  void updateEditingValue(String field, String value) {
    final newEditingValues = Map<String, String>.from(state.editingValues);
    newEditingValues[field] = value;
    emit(state.copyWith(editingValues: newEditingValues));
  }

  void updateDateOfBirth(DateTime? dateOfBirth) {
    if (state.profile != null) {
      final updatedProfile = state.profile!.copyWith(dateOfBirth: dateOfBirth);
      emit(state.copyWith(profile: updatedProfile));
    }
  }

  void updateGender(String? gender) {
    if (state.profile != null) {
      final updatedProfile = state.profile!.copyWith(gender: gender);
      emit(state.copyWith(profile: updatedProfile));
    }
  }

  Future<void> saveProfile() async {
    if (state.profile == null || !state.isEditing) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final updatedProfile = state.profile!.copyWith(
        displayName: state.editingValues['name'],
        email: state.editingValues['email'],
        phoneNumber: state.editingValues['mobile'],
        address: state.editingValues['address'],
      );

      final savedProfile = await updateUserProfileUseCase.call(updatedProfile);

      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          profile: savedProfile,
          isEditing: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // Dispatch SignOut event to AuthBloc
      authBloc.add(const AuthEvent.signOut());

      // Wait a moment for the auth state to update
      await Future.delayed(const Duration(milliseconds: 100));

      emit(
        state.copyWith(
          status: ProfileStatus.loggedOut,
          profile: null,
          editingValues: const {},
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'Logout failed: ${e.toString()}',
        ),
      );
    }
  }
}
