import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(const ProfileState());

  Future<void> loadUserProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, error: null));
    
    try {
      final profile = await getUserProfileUseCase(userId);
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        editingValues: {
          'name': profile.name,
          'email': profile.email,
          'mobile': profile.mobile,
          'address': profile.address,
        },
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        error: e.toString(),
      ));
    }
  }

  void startEditing() {
    if (state.profile != null) {
      emit(state.copyWith(
        isEditing: true,
        editingValues: {
          'name': state.profile!.name,
          'email': state.profile!.email,
          'mobile': state.profile!.mobile,
          'address': state.profile!.address,
        },
      ));
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
        name: state.editingValues['name'],
        email: state.editingValues['email'],
        mobile: state.editingValues['mobile'],
        address: state.editingValues['address'],
      );

      final savedProfile = await updateUserProfileUseCase(updatedProfile);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: savedProfile,
        isEditing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        error: e.toString(),
      ));
    }
  }
}
