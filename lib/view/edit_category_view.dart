import 'package:e_commerce_app/widgets/edit_category_form.dart';
import 'package:flutter/material.dart';

class EditCategoryView extends StatelessWidget {
  const EditCategoryView(
      {super.key, required this.docId, required this.oldName});
  final String docId;
  final String oldName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Category"),
      ),
      body: ListView(
        children: [EditCategoryForm(docId: docId, oldName: oldName)],
      ),
    );
  }
}
