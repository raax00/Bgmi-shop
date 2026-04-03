import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => isLoading = true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        if (_nameController.text.isEmpty) throw Exception("Please enter your name");
        UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': cred.user!.email,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error'), backgroundColor: CupertinoColors.destructiveRed));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: CupertinoColors.destructiveRed));
      }
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(28)),
                  child: const Icon(CupertinoIcons.game_controller_solid, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 32),
                Text(isLogin ? 'Welcome Back' : 'Create Account', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('Premium Store Experience', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                const SizedBox(height: 40),
                
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)]),
                  child: Column(
                    children: [
                      if (!isLogin) ...[
                        CupertinoTextField(
                          controller: _nameController, placeholder: 'Full Name', padding: const EdgeInsets.all(18),
                          prefix: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(CupertinoIcons.person_solid, color: Colors.grey)),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
                        ),
                      ],
                      CupertinoTextField(
                        controller: _emailController, placeholder: 'Email Address', padding: const EdgeInsets.all(18), keyboardType: TextInputType.emailAddress,
                        prefix: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(CupertinoIcons.mail_solid, color: Colors.grey)),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
                      ),
                      CupertinoTextField(
                        controller: _passwordController, placeholder: 'Password', obscureText: true, padding: const EdgeInsets.all(18),
                        prefix: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(CupertinoIcons.lock_fill, color: Colors.grey)),
                        decoration: const BoxDecoration(border: Border.none),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: CupertinoButton(
                    color: Colors.black, borderRadius: BorderRadius.circular(18),
                    onPressed: isLoading ? null : submit,
                    child: isLoading ? const CupertinoActivityIndicator(color: Colors.white) : Text(isLogin ? 'Sign In' : 'Sign Up', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In", style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
