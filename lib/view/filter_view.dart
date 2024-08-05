import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('users')
      .orderBy('money', descending: true)
      .snapshots();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  //List<QueryDocumentSnapshot> usersDocsList = [];
  // Future<void> getData() async {
  //   QuerySnapshot querySnapshot =
  //       await collectionReference.orderBy('money', descending: true).get();
  //   usersDocsList.clear();
  //   usersDocsList.addAll(querySnapshot.docs);
  // }

  Future<void> batchAddGroubUsers() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference doc1 = collectionReference.doc('1');
    DocumentReference doc2 = collectionReference.doc('2');
    batch.set(doc1, {
      'name': 'tamer',
      'age': 24,
      'money': 300,
    });
    batch.set(doc2, {
      'name': 'sara',
      'age': 21,
      'money': 100,
    });

    batch.commit().then((e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return FilterView();
      }));
    });
  }

  Future<void> updateMoney(DocumentReference documentReference) async {
    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          var snapShotData = snapshot.data();
          if (snapShotData is Map<String, dynamic>) {
            int newMoney = snapShotData['money'] + 100;
            transaction.update(documentReference, {'money': newMoney});
          }
        }
      },
    );
  }

  late String name;
  late String money;
  @override
  void initState() {
    super.initState();
    // getData().then((onValue) {
    //   setState(() {});
    // });
  }

  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (
                    context,
                  ) {
                    return Dialog(
                      child: Container(
                        color: Colors.grey.shade700,
                        height: 300,
                        width: 200,
                        child: Form(
                            key: formKey,
                            autovalidateMode: autovalidateMode,
                            child: ListView(
                              children: [
                                CustomeTextFormField(
                                  hintText: 'name',
                                  onSaved: (value) {
                                    name = value!;
                                  },
                                ),
                                CustomeTextFormField(
                                  hintText: 'money',
                                  onSaved: (value) {
                                    money = value!;
                                  },
                                ),
                                CustomeElevatedButton(
                                  text: 'add',
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      try {
                                        await collectionReference.add({
                                          "name": name,
                                          "money": num.parse(money),
                                          'age': 21
                                        });
                                        //  await getData();

                                        setState(() {});
                                        Navigator.pop(context);
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    } else {
                                      setState(() {
                                        autovalidateMode =
                                            AutovalidateMode.always;
                                      });
                                    }
                                  },
                                )
                              ],
                            )),
                      ),
                    );
                  });
            }),
        appBar: AppBar(
          title: Text('filter view'),
        ),
        body: StreamBuilder(
          stream: usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error Occured'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          DocumentReference documentReference =
                              collectionReference
                                  .doc(snapshot.data!.docs[index].id);
                          updateMoney(documentReference);
                          //  batchAddGroubUsers();
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data!.docs[index]['name']),
                            subtitle: Text(
                                snapshot.data!.docs[index]['age'].toString()),
                            trailing: Text(
                              snapshot.data!.docs[index]['money'].toString() +
                                  "\$",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
