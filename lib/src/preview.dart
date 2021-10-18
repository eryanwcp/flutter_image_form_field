import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:photo_view/photo_view.dart';

import 'controller.dart';
import 'types.dart';

class _ImagePreview<T> extends StatelessWidget {
  const _ImagePreview({
    Key? key,
    required this.image,
    required this.previewImageBuilder,
    this.onRemove,
  }) : super(key: key);

  final T image;
  final VoidCallback? onRemove;
  final BuildImagePreviewCallback<T> previewImageBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          previewImageBuilder(context, image),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Color(0xFFFFFFFF),
            ),
          )
        ],
      ),
    );
  }
}

class ImagesPreview<T> extends StatefulWidget {
  const ImagesPreview({
    required this.controller,
    required this.previewImageBuilder,
  });

  final ImageFieldController<T> controller;
  final BuildImagePreviewCallback<T> previewImageBuilder;

  @override
  _ImagesPreviewState<T> createState() => _ImagesPreviewState<T>();
}

class _ImagesPreviewState<T> extends State<ImagesPreview> {
  List<T>? images;

  Widget buildImage(T image) {
    if (image == null) return Container();

    return _ImagePreview<T>(
      image: image,
      previewImageBuilder: widget.previewImageBuilder,
      onRemove: () => widget.controller.remove(image),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images?.isEmpty ?? true) return Container();

    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 10,
          spacing: 10,
          children: List.generate(images!.length, (i) {
            return buildImage(images![i]);
          }),
        )
    );
  }

  void _setImages() {
    setState(() {
      images = widget.controller.value as List<T>;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_setImages);
    _setImages();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_setImages);
    super.dispose();
  }
}

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper({
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        loadingBuilder: loadingBuilder,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
