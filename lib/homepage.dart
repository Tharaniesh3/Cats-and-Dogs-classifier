import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  dectectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    dectectImage(_image!);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    dectectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Text(
                        'Cats and Dogs Dectector App',
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                      Center(
                        child: Text(
                          'Made by Tharaniesh',
                          style: TextStyle(color: Colors.brown, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: _loading
                      ? Container(
                          width: 350,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(50),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(4, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1,
                                            color: Colors.grey.shade500,
                                          ),
                                          BoxShadow(
                                              offset: Offset(-4, -4),
                                              blurRadius: 15,
                                              spreadRadius: 1,
                                              color: Colors.white),
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset('assets/logo.png'),
                                    )),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 250,
                                child: Image.file(_image!),
                              ),
                              SizedBox(height: 20),
                              _output != null
                                  ? Text(
                                      '${_output?[0]['label']}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4, 4),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                  BoxShadow(
                                      offset: Offset(-4, -4),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      color: Colors.white),
                                ]),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.photo_camera,
                                  size: 30,
                                  color: Colors.brown,
                                ),
                                Text("Camera")
                              ],
                            )),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          pickGalleryImage();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width - 250,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4, 4),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                  BoxShadow(
                                      offset: Offset(-4, -4),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      color: Colors.white),
                                ]),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 30,
                                  color: Colors.brown,
                                ),
                                Text("Gallery")
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
