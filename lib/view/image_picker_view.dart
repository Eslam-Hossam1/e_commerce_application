import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImagePickerView extends StatefulWidget {
  const ImagePickerView({super.key});

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File? file;
  String? url;

  Future<void> uploadimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? cameraImage =
        await picker.pickImage(source: ImageSource.camera);
    if (cameraImage != null) {
      var imageName = basename(cameraImage.path);
      file = File(cameraImage.path);
      var storageRef = FirebaseStorage.instance.ref(imageName);
      await storageRef.putFile(file!);
      url = await storageRef.getDownloadURL();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await uploadimage();
              },
              child: Text("get Image")),
          if (url != null)
            Image.network(
              url!,
              height: 100,
              width: 200,
              fit: BoxFit.fill,
            )
        ],
      ),
    );
  }
}
