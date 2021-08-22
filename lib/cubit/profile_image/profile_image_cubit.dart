import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<File> {
  final _imagePicker = ImagePicker();

  ProfileImageCubit() : super(File(''));

  Future<void> getImage() async {
    PickedFile file = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    emit(File(file.path));
  }
}
