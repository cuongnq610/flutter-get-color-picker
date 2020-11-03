//////////////////////////////
//
// 2019, roipeker.com
// screencast - demo simple image:
// https://youtu.be/EJyRH4_pY8I
//
// screencast - demo snapshot:
// https://youtu.be/-LxPcL7T61E
//
//////////////////////////////
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:simple_color_picker/simple_color_picker.dart';
// import util render
import '../utils//renderPositions.dart';
import '../utils/renderBoxPositions.dart';
// improt model
import '../models/pickedColor.dart';

class ColorPickerCustom extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPickerCustom> {
  String imagePath = 'assets/images/test.jpg';
  String imagePathPicker = '';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  bool showModal = false;
  final picker = new ImagePicker();
  List<PickedColor> listPositions = [];
  img.Image photo;

  // CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

  GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final String title = useSnapshot ? "snapshot" : "basic";
    return Scaffold(
        // appBar: AppBar(title: Text("Color picker $title")),
        body: StreamBuilder(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = snapshot.data ?? Colors.green;
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        RepaintBoundary(
                          key: paintKey,
                          child: GestureDetector(
                            onTapUp: (details) {
                              searchPixel(details.globalPosition);
                            },
                            child: Center(
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                child: imagePathPicker != ''
                                    ? Image.file(
                                        File(imagePathPicker),
                                        key: imageKey,
                                      )
                                    : Image.asset(
                                        imagePath,
                                        key: imageKey,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SimpleColorPicker(
                          color: HSVColor.fromColor(selectedColor),
                          onChanged: null,
                        ),
                      ],
                    ),
                  ),
                  renderPositions(listPositions),
                  Positioned(
                    left: 20,
                    top: MediaQuery.of(context).size.height * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        renderBoxPositions(
                            listPositions, _handleClickPickedColor),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(16),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.grid_on,
                    color: Colors.white,
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(Icons.tonality, color: Colors.white),
                  onPressed: null),
              IconButton(
                  icon: Icon(Icons.coronavirus, color: Colors.white),
                  onPressed: null),
              IconButton(
                  icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                  onPressed: null),
              IconButton(
                  icon: Icon(Icons.photo, color: Colors.white),
                  onPressed: () {
                    getImage();
                  }),
              IconButton(
                  icon: Icon(Icons.lightbulb_outline, color: Colors.white),
                  onPressed: null),
              IconButton(
                  icon: Icon(Icons.ondemand_video_sharp, color: Colors.white),
                  onPressed: null),
            ],
          ),
        ));
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  // get image from gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    ByteData imageBytes = await rootBundle.load(pickedFile.path);
    print('picker file ' + pickedFile.path.toString());
    print('byte data ' + imageBytes.toString());
    // setImageBytes(imageBytes);
    final photoImage = img.decodeImage(imageBytes.buffer.asUint8List());

    setState(() {
      if (pickedFile != null) {
        listPositions = [];
        imagePathPicker = pickedFile.path;
        photo = photoImage;
      } else {
        print('No image selected.');
      }
    });
  }

  // based on useSnapshot=true ? paintKey : imageKey ;
  // this key is used in this example to keep the code shorter.

  Future<void> _handleClickPickedColor(int hex) async {
    final colorClick = '#' + hex.toRadixString(16).substring(2);
    _stateController.add(Color(hex));
    print({colorClick});
    Map<String, dynamic> jsonHex =
        await parseJsonFromAssets('assets/json/hex.json');
    Map<String, dynamic> jsonHexRal =
        await parseJsonFromAssets('assets/json/hexRal.json');
    final hexValue = jsonHex[colorClick];
    final hexRalValue = jsonHexRal[colorClick];
    print({hexValue, hexRalValue});
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("terra rosa"),
          content: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
            child: Column(
              children: [
                Text('Complimentary color: $hexValue'),
                Text('tri complimentary: $hexRalValue'),
                Text('Mix: $hexRalValue $hexValue'),
                Text('Something like that'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = imageKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);
    double px = localPosition.dx;
    double py = localPosition.dy;

    if (useSnapshot) {
      double widgetScaleWidth = box.size.width / photo?.width;
      double widgetScaleHeight = box.size.height / photo?.height;
      px = (px / widgetScaleWidth);
      py = (py / widgetScaleHeight);
    }

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());

    int hex = abgrToArgb(pixel32);
    print({Color(hex)});
    if (listPositions.length < 8) {
      listPositions.add(new PickedColor(
          globalX: globalPosition.dx,
          globalY: globalPosition.dy,
          localX: px,
          localY: py,
          color: hex));
    }

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePathPicker);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
    setState(() {
      photo = img.decodeImage(values);
    });
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
