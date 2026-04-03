import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CupertinoActivityIndicator());
            
            final userData = snapshot.data?.data() as Map<String, dynamic>?;
            final name = userData?['name'] ?? 'Premium User';

            return ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                const Text('Profile', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)),
                const SizedBox(height: 24),
                
                // Profile Big Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]),
                  child: Column(
                    children: [
                      Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: const CircleAvatar(radius: 40, backgroundColor: Colors.black, child: Icon(CupertinoIcons.person_solid, size: 40, color: Colors.white))),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user.email ?? '', style: const TextStyle(color: Colors.white60, fontSize: 15)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Logout Button
                SizedBox(
                  width: double.infinity, height: 56,
                  child: CupertinoButton(
                    color: CupertinoColors.destructiveRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20),
                    child: const Text('Logout', style: TextStyle(color: CupertinoColors.destructiveRed, fontWeight: FontWeight.bold, fontSize: 18)),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
