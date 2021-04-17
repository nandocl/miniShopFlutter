import 'dart:typed_data';
import 'package:multi_image_picker/multi_image_picker.dart';

////vars
//resizeImageFile

Future<ByteData> resizeImageFile(Asset image) async {
  int stdWidth = 600;
  int originalHeight = image.originalHeight;
  int originalWidth = image.originalWidth;
  double howM;
  if (originalWidth > stdWidth) {
    howM = stdWidth / originalWidth;
    originalHeight = (originalHeight * howM).toInt();
    originalWidth = stdWidth;
  }
  ByteData byteData =
      await image.getThumbByteData(originalWidth, originalHeight, quality: 60);

  return byteData;
}
