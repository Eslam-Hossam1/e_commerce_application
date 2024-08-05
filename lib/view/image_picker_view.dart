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
// Pick an image.
// final XFile? galleryImage = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.

    final XFile? cameraImage =
        await picker.pickImage(source: ImageSource.camera);
    log('1');
    if (cameraImage != null) {
      var imageName = basename(cameraImage.path);
      file = File(cameraImage.path);
      log('2');
      var storageRef = FirebaseStorage.instance.ref(imageName);
      log('3');
      await storageRef.putFile(file!);
      log('4');
      url = await storageRef.getDownloadURL();
      log(url ?? '5');
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
