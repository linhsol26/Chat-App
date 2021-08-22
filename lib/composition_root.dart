import 'package:chat/services/user/user_service_contract.dart';
import 'package:chat/services/user/user_service_implementation.dart';
import 'package:chat_app/cubit/home/home_cubit.dart';
import 'package:chat_app/cubit/onboarding/onboarding_cubit.dart';
import 'package:chat_app/cubit/profile_image/profile_image_cubit.dart';
import 'package:chat_app/data/services/image_uploader.dart';
import 'package:chat_app/view/pages/home/home.dart';
import 'package:chat_app/view/pages/onboarding/onboarding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:flutter/material.dart';

class CompositionRoot {
  static late Rethinkdb _rethinkdb;
  static late Connection _connection;
  static late IUserService _userService;

  static configure() async {
    _rethinkdb = Rethinkdb();
    _connection =
        // android simulator
        await _rethinkdb.connect(db: "test", host: "10.0.2.2", port: 28015);
    // ios simulator
    //  await _rethinkdb.connect(db: "test", host: "127.0.0.1", port: 28015);
    _userService = UserService(_rethinkdb, _connection);
  }

  static Widget composeOnboardingUI() {
    // replace ipv4 if using android emulator
    // replace locahost if using ios simulator
    ImageUploader _imageUploader =
        ImageUploader('http://192.168.1.31:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, _imageUploader);
    ProfileImageCubit profileImageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => onboardingCubit,
        ),
        BlocProvider(
          create: (_) => profileImageCubit,
        ),
      ],
      child: Onboarding(),
    );
  }

  static Widget composeHomeUI() {
    HomeCubit homeCubit = HomeCubit(_userService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => homeCubit,
        )
      ],
      child: Home(),
    );
  }
}
