import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getDriverDetails() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final response = await _dbRef.child('drivers/$uid').get();
    if (response.exists) {
      return Map<String, dynamic>.from(response.value as Map);
    }
    return null;
  }
}
