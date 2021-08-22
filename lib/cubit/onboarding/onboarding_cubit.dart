import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/user/user_service_contract.dart';
import 'package:chat_app/data/services/image_uploader.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ImageUploader _imageUploader;

  OnboardingCubit(this._userService, this._imageUploader)
      : super(OnboardingInitial());

  Future<void> connect(String name, File file) async {
    emit(OnboardingLoading());
    final url = await _imageUploader.upload(file);
    final user = User(
        userName: name, photoUrl: url, active: true, lastSeen: DateTime.now());
    final createdUser = await _userService.connect(user);
    emit(OnboardingSuccess(createdUser));
  }
}
