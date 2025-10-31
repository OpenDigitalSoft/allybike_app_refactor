part of 'image_picker_cubit.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}


final class SetImagePickerFailed extends ImagePickerState {}


final class SetImagePicker extends ImagePickerState {
  final File image;
  SetImagePicker({required this.image});
}
