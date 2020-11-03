import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagePath = 'assets/images/default.png';
  String imagePathPicker = '';
  GlobalKey imageKey = GlobalKey();
  final picker = new ImagePicker();
  img.Image photo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: imagePathPicker != ''
                ? Image.file(
                    File(imagePathPicker),
                    key: imageKey,
                  )
                : Text('No image selected.'),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_grid.png',
                    // color: _tabController.index == 0 ? redColor : Colors.grey,
                    height: 30,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_value.png',
                    // color: _tabController.index == 0 ? redColor : Colors.grey,
                    height: 30,
                  ),
                  onPressed: null),
              // IconButton(
              //     icon: Icon(Icons.coronavirus, color: Colors.white),
              //     onPressed: null),
              // IconButton(
              //     icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
              //     onPressed: null),
              IconButton(
                icon: Image.asset(
                  'assets/icons/ic_gallery.png',
                  // color: _tabController.index == 0 ? redColor : Colors.grey,
                  height: 30,
                ),
                onPressed: () {
                  getImage();
                },
              ),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_color_true.png',
                    // color: _tabController.index == 0 ? redColor : Colors.grey,
                    height: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/colorPicker');
                  }),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_youtube.png',
                    // color: _tabController.index == 0 ? redColor : Colors.grey,
                    height: 30,
                  ),
                  onPressed: null),
            ],
          ),
        ),
      ),
    );
    // get image from gallery
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      ByteData imageBytes = await rootBundle.load(pickedFile.path);
      print('picker file ' + pickedFile.path.toString());
      print('byte data ' + imageBytes.toString());
      // setImageBytes(imageBytes);
      final photoImage = await img.decodeImage(imageBytes.buffer.asUint8List());
      if (pickedFile != null) {
        setState(
          () {
            imagePathPicker = pickedFile.path;
            photo = photoImage;
          },
        );
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print(e);
    }
  }
}
