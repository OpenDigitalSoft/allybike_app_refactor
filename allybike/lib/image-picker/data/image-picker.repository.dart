import 'package:allybike/class/result.class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@Injectable(as: IImagePickerRepository)
class ImagePickerRepository implements IImagePickerRepository {
  final ImagePicker imagePicker;
  ImagePickerRepository({required this.imagePicker});

  @override
  Future<Result<XFile?>> getImageFromGallery() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return Result(data: image);
  }

  @override
  Future<XFile?> getImageFromCamera() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
    return image;
  }

  @override
  Future<bool> requestPermission() async {
    final isDenied = await _checkPermissionIsDenied();
    if (!isDenied) {
      return true;
    }
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  _checkPermissionIsDenied() async {
    final status = await Permission.photos.status;
    return status.isDenied || status.isPermanentlyDenied;
  }
}

abstract class IImagePickerRepository {
  Future<XFile?> getImageFromCamera();
  Future<Result<XFile?>> getImageFromGallery();
  Future<bool> requestPermission();
}
