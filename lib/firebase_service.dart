import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Create User in Auth and Save Profile in Firestore
  Future<User?> signUp(String email, String password, String username) async {
  try {
    // 1. Create the account in Firebase Auth
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    // 2. Create the user document in Firestore with starting stats
    await _db.collection('users').doc(res.user!.uid).set({
      'username': username,
      'totalExp': 0,      // Starting EXP for the leaderboard
      'rank': 'Rookie',    // Starting rank
      'level': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return res.user;
  } catch (e) {
    print("Sign up error: $e");
    rethrow; 
  }
}

  // 2. Login User
  Future<User?> login(String email, String password) async {
    UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return res.user;
  }

  // 3. Fetch Real-Time Leaderboard
  Stream<QuerySnapshot> getLeaderboard() {
    return _db.collection('users')
        .orderBy('totalExp', descending: true)
        .limit(10)
        .snapshots();
  }

  // inside your FirebaseService class
Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
  return _db.collection('users')
      .orderBy('totalExp', descending: true) // Rank by highest EXP
      .limit(20) // Show top 20 players
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
}
 Future<void> updateUserExp(int newExp) async {
  String uid = _auth.currentUser!.uid; // Get current user's ID
  await _db.collection('users').doc(uid).update({
    'totalExp': newExp,
    // Automatically level up every 100 EXP
    'level': (newExp / 100).floor() + 1, 
    'rank': newExp > 500 ? 'Professional' : 'Rookie',
  });
}
}

