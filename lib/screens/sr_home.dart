import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
  // img.Image photo;
  Image photo;
  bool onFilter = false;
  bool onGrid = false;
  String urls = '';

  List<dynamic> colorsFilter = [
    {
      "color": Color.fromRGBO(225, 225, 226, 1),
    },
    {
      "color": Color.fromRGBO(198, 199, 201, 1),
    },
    {
      "color": Color.fromRGBO(171, 175, 175, 1),
    },
    {
      "color": Color.fromRGBO(146, 148, 150, 1),
    },
    {
      "color": Color.fromRGBO(123, 124, 127, 1),
    },
    {
      "color": Color.fromRGBO(99, 100, 102, 1),
    },
    {
      "color": Color.fromRGBO(73, 73, 74, 1),
    },
    {
      "color": Color.fromRGBO(73, 73, 74, 1),
    },
    {
      "color": Color.fromRGBO(0, 0, 0, 1),
    },
  ];

  dynamic filterColor = {
      "color": Color.fromRGBO(225, 225, 226, 1),
  };
  double levelFilterColor = 0;

  Future<void> getdata() async {
    var response = await http.get('https://bible-friend-288110.ew.r.appspot.com/api/v1/get-color-app');
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print({res['data']['url_youtube']});
      urls = res['data']['url_youtube'];
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

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
                    ColorFiltered(
                        colorFilter: ColorFilter.matrix(
                          [
                            (0.2126 + 0.7874 * (1- levelFilterColor)), (0.7152 - 0.7152  * (1- levelFilterColor)), (0.0722 - 0.0722 * (1- levelFilterColor)), 0, 0,
                            (0.2126 - 0.2126 * (1- levelFilterColor)), (0.7152 + 0.2848  * (1- levelFilterColor)), (0.0722 - 0.0722 * (1- levelFilterColor)), 0, 0,
                            (0.2126 - 0.2126 * (1- levelFilterColor)), (0.7152 - 0.7152  * (1- levelFilterColor)), (0.0722 + 0.9278 * (1- levelFilterColor)), 0, 0,
                              0,     0,     0,     1,     0,
                          ]
                        ),
                        child: Image.file(
                          File(imagePathPicker),
                          key: imageKey,
                        ),
                      )
                    // Image.file(
                    //     File(imagePathPicker),
                    //     key: imageKey,
                    //   )
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
                  onPressed: () {
                    _launchUrl();
                  }),
            ],
          ),
        ),
      ),
    );
    // get image from gallery
  }

  void _handleFilterColor(dynamic color, level) {
    setState(
      () {
        filterColor = color;
        levelFilterColor = level * 1/colorsFilter.length;
      },
    );
  }

  void _launchUrl() async {
    if (await canLaunch(urls)) {
      await launch(urls);
    } else {
      throw 'Could not open Url';
    }
  }

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      // ByteData imageBytes = await rootBundle.load(pickedFile.path);
      // final photoImage = img.decodeImage(imageBytes.buffer.asUint8List());

      final photoImage = Image.file(File(pickedFile.path));
      
      // final photoImage = Image.file(File(pickedFile.path));
      
      if (pickedFile != null) {
        setState(
          () {
            imagePathPicker = pickedFile.path;
            photo = photoImage;
            levelFilterColor = 0;
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
