import '../../domain/entities/user_profile.dart';

enum ProfileStatus { initial, loading, loaded, editing, error }

class ProfileState {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? error;
  final bool isEditing;
  final Map<String, String> editingValues;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.error,
    this.isEditing = false,
    this.editingValues = const {},
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? error,
    bool? isEditing,
    Map<String, String>? editingValues,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
      editingValues: editingValues ?? this.editingValues,
    );
  }

  bool get isLoading => status == ProfileStatus.loading;
  bool get isLoaded => status == ProfileStatus.loaded;
  bool get hasError => status == ProfileStatus.error;
}
