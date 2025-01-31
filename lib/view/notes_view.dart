import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/helper/add_space.dart';
import 'package:e_commerce_app/view/add_category_view.dart';
import 'package:e_commerce_app/view/add_note_view.dart';
import 'package:e_commerce_app/view/edit_category_view.dart';
import 'package:e_commerce_app/view/edit_note.view.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key, required this.categroyDocId});
  final String categroyDocId;
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<QueryDocumentSnapshot> notesDocsList = [];
  late bool isLoading;
  Future<void> getData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("categories")
        .doc(widget.categroyDocId)
        .collection("notes")
        .get();
    notesDocsList.addAll(querySnapshot.docs);
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeView();
          }),
          (route) => false,
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return AddNoteView(
                categoryDocId: widget.categroyDocId,
              );
            }));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Notes view '),
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
                itemCount: notesDocsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditNoteView(
                            categoryDocId: widget.categroyDocId,
                            oldNoteText: notesDocsList[index]['noteText'],
                            noteDocId: notesDocsList[index].id);
                      }));
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Container(
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade900,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              if (notesDocsList[index]['url'] !=
                                                  'null') {
                                                FirebaseStorage.instance
                                                    .refFromURL(
                                                        notesDocsList[index]
                                                            ['url'])
                                                    .delete();
                                              }
                                              FirebaseFirestore.instance
                                                  .collection("categories")
                                                  .doc(widget.categroyDocId)
                                                  .collection('notes')
                                                  .doc(notesDocsList[index].id)
                                                  .delete()
                                                  .then((e) {
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return NotesView(
                                                    categroyDocId:
                                                        widget.categroyDocId,
                                                  );
                                                }));
                                              });
                                            },
                                            child: Text("delete")),
                                        addWidthSpace(32),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("cancel")),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      child: Container(
                        child: Column(
                          children: [
                            if (notesDocsList[index]["url"] != 'null')
                              Image.network(
                                notesDocsList[index]["url"],
                                height: 150,
                              ),
                            Text(
                              "${notesDocsList[index]["noteText"]}",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
