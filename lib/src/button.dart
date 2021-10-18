import 'dart:io';

import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart' show showModalBottomSheet, Icons, ListTile;
import 'package:image_picker/image_picker.dart';

import 'controller.dart';
import 'types.dart';

class ImageButton<I> extends StatelessWidget {
  final String takePhotoText;
  final String cameraRollText;
  final int maxCount;

  ImageButton({
    Key key,
    @required this.controller,
    @required this.initializeFileAsImage,
    @required this.buttonBuilder,
    this.takePhotoText,
    this.cameraRollText,
    this.maxCount,
    this.shouldAllowMultiple = false,
  }) : super(key: key);

  final ImageFieldController controller;
  final BuildButton buttonBuilder;
  final InitializeFileAsImageCallback<I> initializeFileAsImage;
  final bool shouldAllowMultiple;

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      final newImage = initializeFileAsImage(File(image.path));

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
                  title: new Text("Take a Picture"),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text("Camera Roll"),
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
      onTap: () => _handlePressed(context),
      child: child,
    );
  }
}
