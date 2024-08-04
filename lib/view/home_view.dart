import 'package:e_commerce_app/helper/add_space.dart';
import 'package:e_commerce_app/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("hello my nigga"),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginView();
                  }),
                  (route) => false,
                );
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 220,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            color: Colors.white,
            child: Container(
              child: Column(
                children: [
                  Image.asset(
                    "assets/my-image2.png",
                    height: 150,
                  ),
                  Text(
                    "category",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
