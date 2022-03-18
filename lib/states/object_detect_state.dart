import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ObjectDetectState extends ChangeNotifier{
  File? _image;
  List? _recognitions;
  double? _imageHeight;
  double? _imageWidth;
  bool _busy = false;

  File? get image => _image;
  List? get recognitions => _recognitions;
  double? get imageHeight => _imageHeight;
  double? get imageWidth => _imageWidth;
  bool get busy => _busy;

  set image(image){
    _image = image;
    notifyListeners();
  }

  set recognitions(recognitions){
    _recognitions = recognitions;
    notifyListeners();
  }

  set imageHeight(imageHeight){
    _imageHeight = imageHeight;
    notifyListeners();
  }

  set imageWidth(imageWidth){
    _imageWidth = imageWidth;
    notifyListeners();
  }

  set busy(busy){
    _busy = busy;
    notifyListeners();
  }
}