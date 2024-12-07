import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImagesShow extends StatefulWidget {
  static const String id = 'images_show';

  @override
  State<ImagesShow> createState() => _ImagesShowState();
}

class _ImagesShowState extends State<ImagesShow> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  // Method to select a file
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });

    await uploadFile();
  }

  // Method to upload a file to Firebase Storage
  Future uploadFile() async {
    if (pickedFile == null) return;

    final file = File(pickedFile!.path!);
    final path = 'files/${pickedFile!.name}';
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    // Show a success toast message
    Fluttertoast.showToast(msg: 'Image uploaded successfully!');

    setState(() {
      uploadTask = null;
    });

    // Go back to the previous screen with the image URL
    Navigator.pop(context, downloadUrl);
  }

  // UI to display the upload progress
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Center(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.blue,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images Show'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: selectFile,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.white24,
                  child: Center(
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            if (uploadTask != null) buildUploadStatus(uploadTask!),
          ],
        ),
      ),
    );
  }
}
