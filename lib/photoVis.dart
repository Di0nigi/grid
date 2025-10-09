import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main.dart';

class PhotoVis extends StatefulWidget {
  final File dispPhoto;

  PhotoVis({super.key, required this.dispPhoto});

  

  @override
  State<PhotoVis> createState() => _PhotoVisState(photo: this.dispPhoto);
}

var width = 0.0;
var height = 0.0;

class _PhotoVisState extends State<PhotoVis> {
  final File photo;

  _PhotoVisState({required this.photo});


  @override
  Widget build(BuildContext context) {
    

  
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    setState(() {});

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
        children: [Padding(padding: EdgeInsets.all(18)),
         Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(padding: EdgeInsets.all(5)),
        Container(
          
          height: height/20,
          color: const Color.fromARGB(0, 0, 187, 212),
          child:Text(
                        "Grid",
                        style: TextStyle(
                            color: Color.fromARGB(160, 255, 255, 255),
                            fontSize: 20,
                            fontFamily: "ubuntu"),
                      ) )]),                     
                      Container(
                        height: height-100,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 24, 255, 255),
          borderRadius: BorderRadius.circular(0.0),
          image: DecorationImage(
              image: FileImage(photo),
              fit: BoxFit.contain,
              alignment: FractionalOffset(0.5, 0.5)),
        ),
      )],)
       
    );
  }
}
