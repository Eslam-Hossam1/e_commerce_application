import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/notes_view.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key, required this.categoryDocId});
  final String categoryDocId;
  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String noteText;
  bool isLoading = false;

  Future<void> addNote(String noteText) async {
    try {
      setState(() {
        isLoading = true;
      });
      CollectionReference notesCollection = FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryDocId)
          .collection('notes');
      DocumentReference response = await notesCollection.add({
        'noteText': noteText,
      });

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
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomeTextFormField(
                hintText: "write note",
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
                        text: "Add",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            addNote(noteText);
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
