import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadFile(context, imagePath);
        },
        child: Icon(Icons.upload_file),
      ),
      body: Image.file(File(imagePath)),
    );
  }
}

uploadFile(BuildContext context, var imagePath) async {
  var postUri = Uri.parse("http://157.230.32.117:5001/predict");

  print(imagePath);

  var request = new http.MultipartRequest("POST", postUri);
  request.files.add(
    new http.MultipartFile(
      'file',
      File(imagePath).readAsBytes().asStream(),
      File(imagePath).lengthSync(),
      filename: imagePath,
      contentType: new MediaType('image', 'jpg'),
    ),
  );

  var response = await request.send();
  print(response.statusCode);

  // listen for response
  if (response.statusCode == 200)
    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> result = jsonDecode(value);
      showAlertDialog(context, result["result"]);
      print(value);
    });
  else
    showAlertDialog(context, "Cant get value");
}

showAlertDialog(BuildContext context, String text) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("The text is"),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
