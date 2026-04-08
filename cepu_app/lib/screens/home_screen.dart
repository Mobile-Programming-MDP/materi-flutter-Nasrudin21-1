import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cepu_app/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _signOut(BuildContext context) async {
    // Implement sign out logic here
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  String generateAvatarUrl(String? fullName) {
    final formattedName = fullName!.trim().replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$formattedName&background=random';
  }

  
  String? _idToken;
  String? _uid;
  String? _email;
  Future<void> getFirebaseAuthUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      _email = user.email;
      await user
      .getIdToken(true)
      .then(
        (v) => {
          setState(() {
        _idToken = v;
      }),
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen"),
      backgroundColor: Colors.green,
      actions: [
        IconButton(
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout),
          tooltip: 'Sign Out',
        ),
      ]
      ),
      body: Column(
        children: [
        Image.network(
          generateAvatarUrl(
            FirebaseAuth.instance.currentUser?.displayName.toString(),
            ),
            width:100,
            height:100,
            ),
            SizedBox(height: 8.0),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Your have been signed in with ID Token: $_idToken"),
            Text("current User: $_uid"),
            Text("Current Email: $_email"),
          ],
        ),
    );
  }
}