import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class DisplayPictureScreenWithCrop extends StatelessWidget {
  final File image;

  const DisplayPictureScreenWithCrop({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadFile(context, image);
        },
        child: Icon(Icons.upload_file),
      ),
      body: Image.file(image),
    );
  }
}

uploadFile(BuildContext context, File image) async {
  var postUri = Uri.parse("http://157.230.32.117:5001/predict");

  print(image.path);

  var request = new http.MultipartRequest("POST", postUri);
  request.files.add(
    new http.MultipartFile(
      'file',
      File(image.path).readAsBytes().asStream(),
      File(image.path).lengthSync(),
      filename: image.path,
      contentType: new MediaType('image', image.runtimeType.toString()),
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
