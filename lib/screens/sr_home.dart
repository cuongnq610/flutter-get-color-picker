import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
// import widget render filter color
import '../utils/renderFilterColors.dart';
// import widget render grid
import '../utils//renderGrid.dart';

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
  bool onFilter = false;
  bool onGrid = false;

  List<Color> colorsFilter = [
    Color.fromRGBO(225, 225, 226, 1),
    Color.fromRGBO(198, 199, 201, 1),
    Color.fromRGBO(171, 175, 175, 1),
    Color.fromRGBO(146, 148, 150, 1),
    Color.fromRGBO(0, 0, 0, 1),
    // Colors.white24,
    // Colors.black38,
    // Colors.black45,
    // Colors.black54,
    // Colors.black87,
    // Colors.black,
  ];

  Color filterColor = Color.fromRGBO(0, 0, 0, 1);

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
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: imagePathPicker != ''
                    ?
                    // ColorFiltered(
                    //     colorFilter:
                    //         ColorFilter.mode(filterColor, BlendMode.color),
                    //     // colorFilter: null,
                    //     child: Image.file(
                    //       File(imagePathPicker),
                    //       key: imageKey,
                    //       color: filterColor,
                    //     ),
                    //   )
                    Image.file(
                        File(imagePathPicker),
                        key: imageKey,
                        // color: filterColor,
                        // colorBlendMode: BlendMode.hardLight,
                      )
                    : null,
              ),
              onFilter == true
                  ? Positioned(
                      left: 0,
                      top: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          renderFilterColors(
                              colorsFilter,
                              _handleFilterColor,
                              MediaQuery.of(context).size.width /
                                  colorsFilter.length)
                        ],
                      ),
                    )
                  : Container(),
              onGrid == true 
                ? renderPositions(MediaQuery.of(context).size.height / 5)
                : Container()
            ],
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
                  onPressed: () => {
                        setState(
                          () {
                            onFilter = false;
                            onGrid = !onGrid;
                          },
                        )
                      }),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_value.png',
                    // color: _tabController.index == 0 ? redColor : Colors.grey,
                    height: 30,
                  ),
                  onPressed: () => {
                        setState(
                          () {
                            onFilter = !onFilter;
                            onGrid = false;
                          },
                        )
                      }),
              IconButton(
                icon: Image.asset(
                  'assets/icons/ic_gallery.png',
                  height: 30,
                ),
                onPressed: () {
                  getImage();
                },
              ),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_color_true.png',
                    height: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/colorPicker',
                        arguments: {"imagePath": imagePathPicker});
                  }),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/ic_youtube.png',
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

  void _handleFilterColor(Color color) {
    print({color});
    setState(
      () {
        filterColor = color;
      },
    );
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      ByteData imageBytes = await rootBundle.load(pickedFile.path);
      print('picker file ' + pickedFile.path.toString());
      print('byte data ' + imageBytes.toString());
      // setImageBytes(imageBytes);
      final photoImage = img.decodeImage(imageBytes.buffer.asUint8List());
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
