import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/helper/add_space.dart';
import 'package:e_commerce_app/view/add_category_view.dart';
import 'package:e_commerce_app/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<QueryDocumentSnapshot> categoriesDocsList = [];
  late bool isLoading;
  Future<void> getData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("categories").get();
    categoriesDocsList.addAll(querySnapshot.docs);
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getData().then((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddCategoryView();
          }));
        },
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: categoriesDocsList.length,
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
                          "${categoriesDocsList[index]["categoryName"]}",
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
