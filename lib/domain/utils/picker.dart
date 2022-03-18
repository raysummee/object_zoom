import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../states/object_detect_state.dart';
import '../entities/object_detect.dart';

class Picker{
  Future<void> imageAdd(BuildContext context, ImageSource imageSource) async{
    ObjectDetectState state = Provider.of<ObjectDetectState>(context, listen: false);
    

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    // Capture a photo
    final XFile? photo = await _picker.pickImage(source: imageSource);
    if (photo != null) {
      state.busy = true;
      File file = File(photo.path);
  
      FileImage(file)
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
          state.imageHeight = info.image.height.toDouble();
          state.imageWidth = info.image.width.toDouble();
      }));

      ObjectDetect od = ObjectDetect();
      var r = await od.detect(file.path);
      state.recognitions = r;
      state.image = file;
      state.busy = false;
    } else {
      // User canceled the picker
    }
  }

}