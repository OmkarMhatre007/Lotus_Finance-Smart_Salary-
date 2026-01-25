import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart'; // This links it to the logic file you created
import 'main.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  void _handleAuth() async {
  try {
    if (isLogin) {
      // 1. Log in existing user
      User? user = await FirebaseService().login(
        _emailController.text, 
        _passwordController.text
      );
      
      if (user != null) {
  // 1. Create a placeholder profile to satisfy the "required profile" argument
  UserProfile dummyProfile = UserProfile(); 

  // 2. Pass the required arguments into the container
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MainNavigationContainer(
        profile: dummyProfile,      // Fixes error 1
        initialGoals: "Welcome back!", // Fixes error 2
      ),
    ),
  );
}
    } else {
      // 2. Sign up new user
      // Tip: You can later add a Name field, but for now we'll use a placeholder
      User? user = await FirebaseService().signUp(
        _emailController.text, 
        _passwordController.text,
        "New Player" 
      );

      if (user != null) {
        // New users go to the Survey first to set up their profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SurveyScreen()),
        );
      }
    }
  } catch (e) {
    // Shows errors like "User not found" or "Wrong password"
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lotus Finance", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 30),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleAuth,
              child: Text(isLogin ? "Login" : "Join the Game"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "New here? Create Account" : "Already a member? Login"),
            )
          ],
        ),
      ),
    );
  }
}