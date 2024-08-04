import 'package:e_commerce_app/widgets/add_category_form.dart';
import 'package:flutter/material.dart';

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: ListView(
        children: [AddCategoryForm()],
      ),
    );
  }
}
