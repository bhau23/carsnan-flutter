import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth {
    // FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
    return FirebaseAuth.instance;
  }
}
