import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var width = 0.0;
var height = 0.0;
var len = 0;
Widget grid = updateGrid();

List<File> photos = [];

class _HomeScreenState extends State<HomeScreen> {
  var iconPadding = 17.0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            width: width,
            color: Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(12)),
                Container(
                  color: const Color.fromARGB(0, 255, 193, 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        "Grid",
                        style: TextStyle(
                            color: Color.fromARGB(160, 255, 255, 255),
                            fontSize: 20,
                            fontFamily: "ubuntu"),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: width - 10,
                    height: height - (height / 20) - 65,
                    padding: EdgeInsets.all(0),
                    child: grid),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                border: Border.all(
                    width: 0.1, color: Color.fromARGB(103, 122, 122, 122))),
            width: width,
            height: height / 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    // Use the FluentIcons + name of the icon you want
                    icon: Icon(
                      FluentIcons.add_square_16_filled,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _pickImage();
                      setState(() {
                        grid = updateGrid();
                      });

                      print("Button pressed");
                    }),
                IconButton(
                    // Use the FluentIcons + name of the icon you want
                    icon: Icon(
                      FluentIcons.arrow_sync_circle_16_regular,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        grid = updateGrid();
                      });
                    }),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  File? _image;

  if (pickedFile != null) {
    _image = File((await _cropImage(pickedFile.path))!.path);

    photos.add(_image);
    len++;
  } else {
    print('No image selected.');
  }
}

Future<CroppedFile?> _cropImage(String imageFile) async {
  return ImageCropper().cropImage(
    sourcePath: imageFile,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ],
  );
}

Widget updateGrid() {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Number of columns in the grid
      crossAxisSpacing: 2.0, // Space between columns
      mainAxisSpacing: 1.0, // Space between rows
    ),
    itemCount: len, // Number of items in the grid
    itemBuilder: (context, index) {
      List<File> phReverse = photos.reversed.toList();
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 24, 255, 255),
            borderRadius: BorderRadius.circular(0.0),
            image: DecorationImage(
                image: FileImage(phReverse[index]), // Load image from File
                fit: BoxFit.cover,
                alignment: FractionalOffset(0.5, 0.5)),
          ),
        ),
        onDoubleTap: () {
          photos.remove(phReverse[index]);
          len--;
          print(index);
          print("doubleTap");
        },
      );
    },
  );
}
