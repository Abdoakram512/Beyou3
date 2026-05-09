import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker;

  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  static const int _maxDimension = 1024;
  static const int _quality = 80;

  Future<File?> pickFromCamera() => _pick(ImageSource.camera);

  Future<File?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<File?> _pick(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: _maxDimension.toDouble(),
      maxHeight: _maxDimension.toDouble(),
      imageQuality: _quality,
    );
    return xFile == null ? null : File(xFile.path);
  }
}
