import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cepu_app/screens/sign_in_screen.dart';
import 'package:cepu_app/screens/add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  String generateAvatarUrl(String? fullName) {
    final formattedName = fullName?.trim().replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$formattedName&background=random&size=128';
  }

  // String? _idToken ="";
  // String? _uid ="";
  // String? _email ="";

  @override
  void initState() {
    super.initState();
    //getFirebaseAuthUser();
  }
  
  // Future<void> getFirebaseAuthUser() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     _uid = user.uid;
  //     _email = user.email;
  //     await user.getIdToken(true).then(
  //       (v) => {
  //         setState(() {
  //           _idToken = v;
  //         })
  //       }
  //     );
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              _signOut();
            },
            icon: Icon(Icons.logout),
            tooltip: "Sign Out",
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            generateAvatarUrl(
              FirebaseAuth.instance.currentUser?.displayName.toString(),
            ),
            width: 100,
            height: 100,
          ),
          SizedBox(height: 8.0),
          Text(
            FirebaseAuth.instance.currentUser!.displayName!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          const Center(child: Text("You Have Been Signed In!")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}