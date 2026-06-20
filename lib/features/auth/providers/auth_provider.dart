import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

class SafeCityUser {
  final String uid;
  final String email;
  final String role;
  final String? sector;
  final String name;

  const SafeCityUser({
    required this.uid,
    required this.email,
    required this.role,
    this.sector,
    required this.name,
  });
}

@riverpod
Stream<SafeCityUser?> authState(AuthStateRef ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return SafeCityUser(
      uid: user.uid,
      email: user.email ?? '',
      role: data['role'] ?? 'citizen',
      sector: data['sector'],
      name: data['name'] ?? '',
    );
  });
}
