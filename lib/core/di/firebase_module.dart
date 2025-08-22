import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth {
    // FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
    return FirebaseAuth.instance;
  }

  @lazySingleton
  FirebaseFirestore get firebaseFirestore {
    // FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
    return FirebaseFirestore.instance;
  }

  @lazySingleton
  FirebaseStorage get firebaseStorage {
    // FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
    return FirebaseStorage.instance;
  }
}

/// Storage service for handling Firebase Storage operations
@injectable
class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  /// Uploads a profile picture to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadProfilePicture(File image, String userId) async {
    try {
      // Create reference to the storage location
      final ref = _storage
          .ref()
          .child('profile_pictures')
          .child(userId)
          .child('profile.jpg');

      // Upload the file
      final uploadTask = ref.putFile(image);

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Deletes a profile picture from Firebase Storage
  Future<void> deleteProfilePicture(String userId) async {
    try {
      final ref = _storage
          .ref()
          .child('profile_pictures')
          .child(userId)
          .child('profile.jpg');
      await ref.delete();
    } catch (e) {
      // If file doesn't exist, that's fine
      if (e is FirebaseException && e.code == 'object-not-found') {
        return;
      }
      throw Exception('Failed to delete profile picture: $e');
    }
  }
}
