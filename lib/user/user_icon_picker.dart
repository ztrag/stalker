import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

const int _kSize = 512;

class UserIconPicker extends ValueNotifier<Uint8List?> {
  UserIconPicker([super.value]);

  void pick() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _kSize * 2,
      maxHeight: _kSize * 2,
    );
    if (image == null) {
      return;
    }

    final picked = await File(image.path).readAsBytes();
    final resized = await _resizeAndConvertImage(picked, _kSize);
    final cropped = await _cropCircle(
        resized, ui.Size(_kSize.toDouble(), _kSize.toDouble()));

    value = cropped;
  }

  Future<ui.Image> _resizeAndConvertImage(
    Uint8List data,
    int size,
  ) async {
    final baseSizeImage = img.decodeImage(data);
    final resizeImage =
        img.copyResizeCropSquare(baseSizeImage!, size: size, antialias: true);
    ui.Codec codec = await ui.instantiateImageCodec(img.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<Uint8List> _cropCircle(ui.Image image, ui.Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);
    final paint = ui.Paint();
    paint.isAntiAlias = true;

    _drawCircleCrop(image, size, canvas);

    final recordedPicture = pictureRecorder.endRecording();
    ui.Image img = await recordedPicture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Canvas _drawCircleCrop(ui.Image image, ui.Size size, ui.Canvas canvas) {
    final paint = Paint();
    paint.isAntiAlias = true;
    canvas.drawCircle(const Offset(0, 0), 0, paint);

    Path path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), paint);
    return canvas;
  }
}
