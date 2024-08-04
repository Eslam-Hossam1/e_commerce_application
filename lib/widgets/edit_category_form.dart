import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditCategoryForm extends StatefulWidget {
  const EditCategoryForm(
      {super.key, required this.docId, required this.oldName});
  final String docId;
  final String oldName;
  @override
  State<EditCategoryForm> createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController oldNameController = TextEditingController();
  late String categoryName;
  bool isLoading = false;
  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection("categories");
  Future<void> updeatCategory(String categoryName) async {
    try {
      setState(() {
        isLoading = true;
      });
      // await categoriesCollection
      //     .doc(widget.docId)
      //     .set({"categoryName": categoryName},SetOptions(merge: true));
      await categoriesCollection
          .doc(widget.docId)
          .update({'categoryName': categoryName});

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeView();
      }));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    oldNameController.text = widget.oldName;
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
                controller: oldNameController,
                hintText: "category Name",
                onSaved: (value) {
                  categoryName = value!;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80.0, vertical: 12),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomeElevatedButton(
                        text: "Update",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            updeatCategory(categoryName);
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
