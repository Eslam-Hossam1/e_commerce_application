import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/helper/add_space.dart';
import 'package:e_commerce_app/view/home_view.dart';
import 'package:e_commerce_app/view/notes_view.dart';
import 'package:e_commerce_app/widgets/custome_elevated_button.dart';
import 'package:e_commerce_app/widgets/custome_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
  File? file;
  String? url;
  Color? color;
  Future<void> uploadimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? cameraImage =
        await picker.pickImage(source: ImageSource.camera);
    if (cameraImage != null) {
      var imageName = basename(cameraImage.path);
      file = File(cameraImage.path);
      var storageRef = FirebaseStorage.instance.ref("images/$imageName");
      await storageRef.putFile(file!);
      url = await storageRef.getDownloadURL();
      color = Colors.green;
    }
    setState(() {});
  }

  Future<void> addNote(String noteText, context) async {
    try {
      setState(() {
        isLoading = true;
      });
      CollectionReference notesCollection = FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryDocId)
          .collection('notes');
      DocumentReference response = await notesCollection
          .add({'noteText': noteText, 'url': url ?? 'null'});

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
                    : Column(
                        children: [
                          CustomeElevatedButton(
                            color: color,
                            text: 'Upload photo',
                            onPressed: () async {
                              await uploadimage();
                            },
                          ),
                          addHieghtSpace(24),
                          CustomeElevatedButton(
                            text: "Add",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                addNote(noteText, context);
                              } else {
                                setState(() {
                                  autovalidateMode = AutovalidateMode.always;
                                });
                              }
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ));
  }
}
