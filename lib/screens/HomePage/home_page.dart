import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_zoom/domain/entities/object_detect.dart';
import 'package:object_zoom/domain/utils/picker.dart';
import 'package:object_zoom/screens/HomePage/components/image_painter.dart';
import 'package:object_zoom/states/object_detect_state.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

Future<ui.Image>? getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    var img = FileImage(File(path));
    img
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }
  @override
  Widget build(BuildContext context) {
    ObjectDetectState state = Provider.of<ObjectDetectState>(context);
    
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    double factorX = size.width;
    double factorY = state.imageHeight==null?0:state.imageHeight! / state.imageWidth! * size.width;


    stackChildren.add(state.image== null ? const Text('No image selected.') : Container(
      color: Colors.black,
      child: FutureBuilder<ui.Image>(
        future: getImage(state.image!.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            var re = state.recognitions!.firstWhere((element) => element['confidenceInClass']>0.60);
            Rect rect = Rect.fromLTWH(re["rect"]["x"] * snapshot.data!.width, re["rect"]["y"] * snapshot.data!.height.toDouble(), re["rect"]["w"]* snapshot.data!.width.toDouble(), re["rect"]["h"] * snapshot.data!.height.toDouble());
            return Container(
              color: Colors.black,
              child: CustomPaint(
                painter: ImagePainter(snapshot.data!, rect),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: factorY,
                ),
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
         
        }
      ),
    ));

    // stackChildren.addAll(ObjectDetect().renderBoxes(size, context));

    if (state.busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: stackChildren,
              ),
            ),
            ElevatedButton(
              onPressed: ()=> Picker().imageAdd(context, ImageSource.gallery), 
              child: const Text("add image")
            ),
            ElevatedButton(
              onPressed: ()=> Picker().imageAdd(context, ImageSource.camera), 
              child: const Text("capture image")
            )
          ],
        ),
      ),
    );
  }
}