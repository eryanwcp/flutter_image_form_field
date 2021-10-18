import 'dart:io';

import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart' show showModalBottomSheet, Icons, ListTile;
import 'package:image_picker/image_picker.dart';

import 'controller.dart';
import 'types.dart';

class ImageButton<I> extends StatelessWidget {
  final String? takePhotoText;
  final String? cameraRollText;
  final int? maxCount;

  ImageButton({
    Key? key,
    required this.controller,
    required this.initializeFileAsImage,
    required this.buttonBuilder,
    this.takePhotoText,
    this.cameraRollText,
    this.maxCount = 1,
    this.shouldAllowMultiple = false,
  }) : super(key: key);

  final ImageFieldController controller;
  final BuildButton buttonBuilder;
  final InitializeFileAsImageCallback<I> initializeFileAsImage;
  final bool shouldAllowMultiple;

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      final newImage = initializeFileAsImage(image);

      if (shouldAllowMultiple) {
        controller.add(newImage);
      } else {
        controller.addDestructively(newImage);
      }
    }
  }

  _handlePressed(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              new ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text(this.takePhotoText ?? '相机'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(this.cameraRollText ?? "相册"),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final child = buttonBuilder(context, controller.value.length);

    return new GestureDetector(
        onTap: () => controller.value.length < this.maxCount!
            ? _handlePressed(context)
            : null,
        child: child);
  }
}
