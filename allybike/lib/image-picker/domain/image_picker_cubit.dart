import 'dart:io';

import 'package:allybike/image-picker/data/image-picker.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'image_picker_state.dart';

@injectable
class ImagePickerCubit extends Cubit<ImagePickerState> {

  final ImagePickerRepository imagePickerRepository;
  ImagePickerCubit({
    required this.imagePickerRepository,
  }) : super(ImagePickerInitial());

  
  
  getPhoto() async {
    final hasPermission = await imagePickerRepository.requestPermission();
    if (!hasPermission) {
      emit(SetImagePickerFailed());
      addError("No tiene permisos para acceder a la camara");
      return;
    }
    final result = await imagePickerRepository.getImageFromCamera();
    if (result == null) {
      emit(SetImagePickerFailed());
      addError("No se selecciono ninguna imagen");
      return;
    }
    emit(SetImagePicker(image: File(result.path)));
  }

  getPhotoFromGallery() async {
    final hasPermission = await imagePickerRepository.requestPermission();
    if (!hasPermission) {
      emit(SetImagePickerFailed());
      addError("No tiene permisos para acceder a la galeria");
      return;
    }
    final result = await imagePickerRepository.getImageFromGallery();
    if (result.data == null) {
      emit(SetImagePickerFailed());
      addError("No se selecciono ninguna imagen");
      return;
    }
    emit(SetImagePicker(image: File(result.data!.path)));
  }
}
