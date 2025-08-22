import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

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
}
