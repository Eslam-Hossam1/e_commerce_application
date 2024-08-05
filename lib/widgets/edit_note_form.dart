import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/notes_view.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditNoteForm extends StatefulWidget {
  const EditNoteForm(
      {super.key,
      required this.categoryDocId,
      required this.oldNoteText,
      required this.noteDocId});
  final String categoryDocId;
  final String noteDocId;
  final String oldNoteText;
  @override
  State<EditNoteForm> createState() => _EditNoteFormState();
}

class _EditNoteFormState extends State<EditNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController oldNameController = TextEditingController();
  late String noteText;
  bool isLoading = false;

  Future<void> updeatCategory(String categoryName) async {
    try {
      setState(() {
        isLoading = true;
      });
      // await categoriesCollection
      //     .doc(widget.docId)
      //     .set({"categoryName": categoryName},SetOptions(merge: true));
      CollectionReference categoriesCollection = FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryDocId)
          .collection('notes');
      await categoriesCollection
          .doc(widget.noteDocId)
          .update({'noteText': noteText});

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return NotesView(
          categroyDocId: widget.categoryDocId,
        );
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
    oldNameController.text = widget.oldNoteText;
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
                hintText: "note text",
                onSaved: (value) {
                  noteText = value!;
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
                            updeatCategory(noteText);
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
