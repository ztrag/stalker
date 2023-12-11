import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

const int _kSize = 512;

class UserIconPickerResult {
  Uint8List pngBytes;
  ui.Image image;

  UserIconPickerResult(this.pngBytes, this.image);
}

class UserIconPicker extends ValueNotifier<UserIconPickerResult?> {
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

    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
    value = UserIconPickerResult(byteData!.buffer.asUint8List(), cropped);
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

  Future<ui.Image> _cropCircle(ui.Image image, ui.Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);
    final paint = ui.Paint();
    paint.isAntiAlias = true;

    _drawCircleCrop(image, size, canvas);

    final recordedPicture = pictureRecorder.endRecording();
    return recordedPicture.toImage(image.width, image.height);
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
