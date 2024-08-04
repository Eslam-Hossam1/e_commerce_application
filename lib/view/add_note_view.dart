import 'package:e_commerce_app/widgets/add_note_form.dart';
import 'package:flutter/material.dart';

class AddNoteView extends StatelessWidget {
  const AddNoteView({super.key, required this.categoryDocId});
  final String categoryDocId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: ListView(
        children: [AddNoteForm(categoryDocId: categoryDocId)],
      ),
    );
  }
}
