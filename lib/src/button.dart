import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart'
    show showModalBottomSheet, Icons, ListTile;
import 'package:image_picker/image_picker.dart';

import 'bottom_sheet.dart';
import 'controller.dart';
import 'types.dart';

class ImageButton<I> extends StatelessWidget {
  final String takePhotoText;
  final String cameraRollText;
  final int maxCount;

  ImageButton(
      {Key key,
      @required this.controller,
      @required this.initializeFileAsImage,
      @required this.buttonBuilder,
      this.takePhotoText,
      this.cameraRollText,
      this.maxCount,
      this.shouldAllowMultiple})
      : super(key: key);

  final ImageFieldController controller;
  final BuildButton buttonBuilder;
  final InitializeFileAsImageCallback<I> initializeFileAsImage;
  final bool shouldAllowMultiple;

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().getImage(source: source);

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
    BottomActionSheet.show(ctx, [
      this.takePhotoText ?? '相机',
      this.cameraRollText ?? "相册",
    ], callBack: (i) {
      if (i == 0) {
        getImage(ImageSource.camera);
      } else {
        getImage(ImageSource.gallery);
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = buttonBuilder(context, controller.value.length);

    return new GestureDetector(
        onTap: () => controller.value.length < this.maxCount
            ? _handlePressed(context)
            : null,
        child: child);
  }
}
