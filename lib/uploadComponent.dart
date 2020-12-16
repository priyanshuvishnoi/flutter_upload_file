import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class UploadComponent extends StatefulWidget {
  @override
  _UploadComponentState createState() => _UploadComponentState();
}

class _UploadComponentState extends State<UploadComponent> {
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  Future _fileUploadHandler() async {
    try {
      file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['pdf']);
      fileName = p.basename(file.path);
      setState(() {
        fileName = p.basename(file.path);
      });
      print(fileName);
      _uploadFile(file, fileName);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Resume"),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () => _fileUploadHandler(),
            child: new Row(
              children: [Icon(Icons.upload_rounded),Text("Upload file")],
            ),
          )
        ],
      ),
    );
  }
}
