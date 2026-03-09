import 'dart:io';
import 'package:image/image.dart';

void main() {
  final file = File('lib/core/theme/logo.png');
  if (!file.existsSync()) {
    print('Logo not found.');
    return;
  }
  final imgBytes = file.readAsBytesSync();
  final img = decodeImage(imgBytes);
  if (img == null) {
    print('Could not decode image.');
    return;
  }

  // Create a canvas twice the size of the longest side properly padded
  final size = (img.width > img.height ? img.width : img.height) * 2;

  final padded = Image(width: size, height: size);
  fill(padded, color: ColorRgba8(0, 0, 0, 0)); // Transparent

  final dstX = (size - img.width) ~/ 2;
  final dstY = (size - img.height) ~/ 2;

  // Fast copy pixels
  compositeImage(padded, img, dstX: dstX, dstY: dstY);

  final outFile = File('lib/core/theme/launcher_icon.png');
  outFile.writeAsBytesSync(encodePng(padded));
  print('Padded icon created successfully.');
}
