import 'dart:io';
import 'package:flutter/widgets.dart' show Widget, BuildContext;
import 'package:image_picker/image_picker.dart';

typedef BuildImagePreviewCallback<T> = Widget Function(BuildContext, dynamic);
typedef BuildButton = Widget Function(BuildContext, int);
typedef InitializeFileAsImageCallback<T> = T Function(PickedFile);
