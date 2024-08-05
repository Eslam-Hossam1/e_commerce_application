import 'package:e_commerce_app/widgets/edit_category_form.dart';
import 'package:e_commerce_app/widgets/edit_note_form.dart';
import 'package:flutter/material.dart';

class EditNoteView extends StatelessWidget {
  const EditNoteView(
      {super.key,
      required this.categoryDocId,
      required this.oldNoteText,
      required this.noteDocId});
  final String categoryDocId;
  final String noteDocId;
  final String oldNoteText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update note"),
      ),
      body: ListView(
        children: [
          EditNoteForm(
              categoryDocId: categoryDocId,
              oldNoteText: oldNoteText,
              noteDocId: noteDocId)
        ],
      ),
    );
  }
}
