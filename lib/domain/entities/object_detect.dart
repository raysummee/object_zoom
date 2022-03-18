import 'package:flutter/material.dart';
import 'package:object_zoom/states/object_detect_state.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

class ObjectDetect{
   Future<dynamic> detect(String filepath) async{
    String? res = await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet_label.txt",
      isAsset: true 
    );
    debugPrint(res);
    var recognitions = await Tflite.detectObjectOnImage(
      path: filepath,
      numResultsPerClass: 1,
    );
    debugPrint(recognitions.toString());
    Tflite.close();
    return recognitions;
  }

  List<Widget> renderBoxes(Size screen, BuildContext context) {
    ObjectDetectState state = Provider.of<ObjectDetectState>(context);
    
    if (state.recognitions == null) return [];
    if (state.imageHeight == null || state.imageWidth == null) return [];


    double factorX = screen.width;
    double factorY = state.imageHeight! / state.imageWidth! * screen.width;
    Color blue = const Color.fromRGBO(37, 213, 253, 1.0);
    
    return state.recognitions!.where((element) => element['confidenceInClass']>0.60).map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}