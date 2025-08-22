import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
// StorageService is here now
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import 'profile_state.dart';

// Temporary enums and classes for compilation until dependencies are properly installed
enum ImageSource { camera, gallery }

class ImagePicker {
  Future<XFile?> pickImage({
    required ImageSource source,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    return null; // Temporary implementation - will work when image_picker is installed
  }
}

class XFile {
  final String path;
  XFile(this.path);
}

// Temporary StorageService for compilation
class TempStorageService {
  Future<String> uploadProfilePicture(File image, String userId) async {
    throw UnimplementedError(
      'Storage service not yet implemented - install dependencies',
    );
  }

  Future<void> deleteProfilePicture(String userId) async {
    throw UnimplementedError(
      'Storage service not yet implemented - install dependencies',
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final TempStorageService storageService;
  final AuthBloc authBloc;
  final ImagePicker imagePicker;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    TempStorageService? storageService,
    required this.authBloc,
    ImagePicker? imagePicker,
  }) : storageService = storageService ?? TempStorageService(),
       imagePicker = imagePicker ?? ImagePicker(),
       super(const ProfileState());

  Future<void> loadUserProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, error: null));

    try {
      final result = await getUserProfileUseCase.call(userId);
      result.fold(
        (failure) {
          emit(
            state.copyWith(status: ProfileStatus.error, error: failure.message),
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
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
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

  /// Upload profile picture from camera or gallery
  Future<void> uploadProfilePicture({
    ImageSource source = ImageSource.gallery,
  }) async {
    if (state.profile == null) return;

    try {
      emit(state.copyWith(status: ProfileStatus.loading));

      // Pick image from the specified source
      final XFile? imageFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (imageFile == null) {
        // User cancelled the picker
        emit(state.copyWith(status: ProfileStatus.loaded));
        return;
      }

      final File file = File(imageFile.path);

      // Upload image to Firebase Storage
      final String downloadUrl = await storageService.uploadProfilePicture(
        file,
        state.profile!.uid,
      );

      // Update profile with new photo URL
      final updatedProfile = state.profile!.copyWith(photoURL: downloadUrl);

      // Save updated profile
      final savedProfile = await updateUserProfileUseCase.call(updatedProfile);

      emit(state.copyWith(status: ProfileStatus.loaded, profile: savedProfile));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'Failed to upload profile picture: ${e.toString()}',
        ),
      );
    }
  }

  /// Delete current profile picture
  Future<void> deleteProfilePicture() async {
    if (state.profile == null || state.profile!.photoURL == null) return;

    try {
      emit(state.copyWith(status: ProfileStatus.loading));

      // Delete image from Firebase Storage
      await storageService.deleteProfilePicture(state.profile!.uid);

      // Update profile to remove photo URL
      final updatedProfile = state.profile!.copyWith(photoURL: null);

      // Save updated profile
      final savedProfile = await updateUserProfileUseCase.call(updatedProfile);

      emit(state.copyWith(status: ProfileStatus.loaded, profile: savedProfile));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: 'Failed to delete profile picture: ${e.toString()}',
        ),
      );
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
