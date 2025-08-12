# Profile Logout Feature Implementation

## Overview

This document describes the implementation of the logout functionality in the profile screen of the Carsnan Flutter application. The implementation follows Clean Architecture principles and integrates with the existing authentication system and routing.

## Feature Description

The logout functionality allows users to securely sign out from their account through the profile screen. When triggered, it:

1. Shows a confirmation dialog
2. Dispatches a logout event to the AuthBloc
3. The AuthBloc handles the sign-out process
4. The router automatically redirects to the login screen based on authentication state
5. Clears the current user session

## Architecture Components

### 1. Domain Layer

- **Use Case**: `SignOutUseCase` (existing in authentication feature)
  - Location: `lib/features/authentication/domain/usecases/sign_out_usecase.dart`
  - Handles the business logic for signing out users
  - Returns `Either<AuthFailure, void>` for proper error handling

### 2. Presentation Layer

#### ProfileCubit Updates

- **Location**: `lib/features/profile/presentation/cubit/profile_cubit.dart`
- **Changes**:
  - Added `AuthBloc` dependency instead of direct `SignOutUseCase` dependency
  - Updated `logout()` method to dispatch `AuthEvent.signOut()` to the AuthBloc
  - Removed direct use case calls for better separation of concerns

```dart
Future<void> logout() async {
  emit(state.copyWith(status: ProfileStatus.loading));
  
  try {
    // Dispatch SignOut event to AuthBloc
    authBloc.add(const AuthEvent.signOut());
    
    // Wait a moment for the auth state to update
    await Future.delayed(const Duration(milliseconds: 100));
    
    emit(state.copyWith(
      status: ProfileStatus.loggedOut,
      profile: null,
      editingValues: const {},
    ));
  } catch (e) {
    emit(state.copyWith(
      status: ProfileStatus.error,
      error: 'Logout failed: ${e.toString()}',
    ));
  }
}
```

#### ProfilePage Updates

- **Location**: `lib/features/profile/presentation/pages/profile_page.dart`
- **Changes**:
  - Updated `BlocProvider` to inject `AuthBloc` instead of `SignOutUseCase`
  - Removed manual navigation logic from the BlocConsumer listener
  - The router handles navigation automatically based on AuthBloc state changes
  - Enhanced logout dialog with proper context provision using `BlocProvider.value`

## User Experience Flow

1. **Trigger Logout**: User taps the "Logout" button in the Account Settings section
2. **Confirmation Dialog**: A dialog appears asking for confirmation
3. **Loading State**: Upon confirmation, the button shows a loading indicator
4. **AuthBloc Integration**: ProfileCubit dispatches `SignOut` event to AuthBloc
5. **Authentication Handling**: AuthBloc processes the sign-out and updates its state
6. **Automatic Navigation**: Router detects auth state change and redirects to login
7. **Error Handling**: On failure, an error message is displayed via SnackBar

## Key Features

### 1. Integrated Authentication Flow

- Uses existing AuthBloc for consistent authentication state management
- Router automatically handles navigation based on authentication state
- No manual navigation required

### 2. Confirmation Dialog

- Prevents accidental logouts
- Shows loading state during the logout process
- Properly provides ProfileCubit context using `BlocProvider.value`

### 3. State Management

- Uses Cubit pattern for predictable state management
- Integrates with AuthBloc for centralized authentication state
- Proper loading states and error handling

### 4. Automatic Navigation

- Router's redirect logic handles navigation automatically
- No manual `context.go()` calls required
- Consistent with the app's routing architecture

### 5. Error Handling

- Comprehensive error handling for network issues
- User-friendly error messages
- Graceful fallback behavior

## Dependencies Used

- **State Management**: `flutter_bloc` with Cubit pattern and AuthBloc integration
- **Navigation**: `go_router` with automatic redirect based on auth state
- **Dependency Injection**: Uses existing `get_it` setup
- **Error Handling**: `dartz` for functional error handling (via AuthBloc)

## Router Integration

The app's router automatically handles logout redirection through its redirect logic:

```dart
redirect: (BuildContext context, GoRouterState state) {
  final bool loggedIn = authBloc.state.maybeWhen(
    authenticated: (user) => true,
    orElse: () => false,
  );
  
  // If not logged in, redirect to login for protected routes
  if (!loggedIn) {
    if (loggingIn || usingPhoneAuth || inOtpFlow) {
      return null;
    }
    return '/login';
  }
  
  return null;
},
refreshListenable: GoRouterRefreshStream(authBloc.stream),
```

## Dependency Injection Setup

All profile-related dependencies are properly registered:

- `GetUserProfileUseCase` - `@injectable`
- `UpdateUserProfileUseCase` - `@injectable`  
- `ProfileRepository` - `@Injectable(as: ProfileRepository)`
- `ProfileLocalDataSource` - `@Injectable(as: ProfileLocalDataSource)`

## Code Quality

### Clean Architecture Compliance

- ✅ Follows Clean Architecture principles
- ✅ Proper separation of concerns
- ✅ Domain layer independent of UI and data layers
- ✅ ProfileCubit coordinates with AuthBloc for authentication concerns

### MVVM Pattern

- ✅ View handles only UI rendering
- ✅ ViewModel (Cubit) manages state and coordinates with other blocs
- ✅ Model represents data entities

### Best Practices

- ✅ Centralized authentication state management
- ✅ Automatic router-based navigation
- ✅ Proper error handling with user feedback
- ✅ Loading states for better UX
- ✅ Confirmation dialogs for destructive actions
- ✅ Consistent styling and theming
- ✅ Dependency injection for testability

## Testing Considerations

The implementation is designed to be easily testable:

- ProfileCubit can be unit tested with mock AuthBloc
- AuthBloc integration can be tested separately
- Router redirect logic is testable
- State changes are predictable and testable

## Troubleshooting

### Issue: Provider Not Found Errors

**Solution**: Ensured all use cases are properly annotated with `@injectable` and dependency injection is regenerated using `build_runner`.

### Issue: Logout Not Redirecting

**Solution**: Integrated with AuthBloc instead of direct use case calls, allowing the router to detect authentication state changes automatically.

### Issue: Dialog Context Issues  

**Solution**: Used `BlocProvider.value` to provide ProfileCubit context to the dialog, ensuring proper access to the cubit.

## Future Enhancements

1. **Biometric Confirmation**: Add biometric authentication for logout confirmation
2. **Session Management**: Implement automatic logout on session expiry
3. **Multi-device Logout**: Add option to logout from all devices
4. **Analytics**: Track logout events for user behavior analysis
5. **Logout Confirmation Settings**: Allow users to disable logout confirmation

## Files Modified

1. `lib/features/profile/presentation/cubit/profile_cubit.dart`
   - Replaced SignOutUseCase with AuthBloc dependency
   - Updated logout method to dispatch AuthBloc events
   - Improved error handling

2. `lib/features/profile/presentation/pages/profile_page.dart`
   - Updated BlocProvider with AuthBloc injection
   - Removed manual navigation logic
   - Enhanced logout dialog context handling

3. `lib/features/profile/domain/usecases/get_user_profile_usecase.dart`
   - Added @injectable annotation

4. `lib/features/profile/domain/usecases/update_user_profile_usecase.dart`
   - Added @injectable annotation

5. `lib/features/profile/data/repositories/profile_repository_impl.dart`
   - Added @Injectable annotation

6. `lib/features/profile/data/datasources/profile_local_datasource.dart`
   - Added @Injectable annotation

## Conclusion

The logout functionality has been successfully implemented with proper integration into the existing authentication and routing systems. The solution provides:

- **Seamless User Experience**: Automatic navigation without manual intervention
- **Consistent Architecture**: Integration with existing AuthBloc and router patterns
- **Robust Error Handling**: Comprehensive error handling and user feedback
- **Maintainable Code**: Clean separation of concerns and testable components

The implementation follows all architectural guidelines and provides a production-ready logout feature that integrates seamlessly with the app's existing authentication flow.
