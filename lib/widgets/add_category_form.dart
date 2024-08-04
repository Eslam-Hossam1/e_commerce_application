import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String categoryName;
  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("categories");
  Future<void> addCategory(String categoryName) async {
    try {
      DocumentReference response = await categoriesCollection.add({
        'categoryName': categoryName,
        'id': FirebaseAuth.instance.currentUser!.uid
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeView();
      }));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomeTextFormField(
                hintText: "category Name",
                onSaved: (value) {
                  categoryName = value!;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80.0, vertical: 12),
                child: CustomeElevatedButton(
                  text: "Add",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      addCategory(categoryName);
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
