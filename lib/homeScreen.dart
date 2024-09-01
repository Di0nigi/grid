import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var width = 0.0;
var height = 0.0;
var len = 0;
int n = 0;
Widget grid = updateGrid();

List<File> photos = [];

class _HomeScreenState extends State<HomeScreen> {
  var iconPadding = 17.0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    setState(() {
      grid = updateGrid();
    });

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
                    icon: Icon(
                      FluentIcons.delete_16_filled,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        prefs!.clear();
                        grid = updateGrid();
                        n = 0;
                        len = 0;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      FluentIcons.add_square_16_filled,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _pickImage();
                      setState(() {
                        grid = updateGrid();
                      });
                    }),
                IconButton(
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
    saveFiles(photos);
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
  getSavedFiles();
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 2.0,
      mainAxisSpacing: 1.0,
    ),
    itemCount: len,
    itemBuilder: (context, index) {
      List<File> phReverse = photos.reversed.toList();
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 24, 255, 255),
            borderRadius: BorderRadius.circular(0.0),
            image: DecorationImage(
                image: FileImage(phReverse[index]),
                fit: BoxFit.cover,
                alignment: FractionalOffset(0.5, 0.5)),
          ),
        ),
        onDoubleTap: () {
          print(photos.remove(photos[len - 1 - index]));

          saveFiles(photos);
          len--;
        },
      );
    },
  );
}

Future<void> saveFiles(List<File> files) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  List<String> newFilePaths = [];

  for (File file in files) {
    n++;

    String newPath = '$appDocPath/image${n}';

    File savedFile = await file.copy(newPath);

    newFilePaths.add(savedFile.path);
  }

  prefs!.clear();
  photos = [];

  prefs!.setStringList('saved_files', newFilePaths);
}

Future<List<File>> getSavedFiles() async {
  prefs = await SharedPreferences.getInstance();
  photos = [];
  //prefs!.clear();

  List<String>? filePaths = prefs!.getStringList('saved_files');

  if (filePaths != null) {
    photos = filePaths.map((path) => File(path)).toList();
    len = photos.length;

    return [];
  } else {
    return [];
  }
}
