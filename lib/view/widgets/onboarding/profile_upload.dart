import 'dart:io';

import 'package:chat_app/cubit/profile_image/profile_image_cubit.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.0,
      width: 126.0,
      child: Material(
        color: isLightTheme(context) ? Color(0xFFF2F2F2) : Color(0xFF211E1E),
        borderRadius: BorderRadius.circular(126.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(126.0),
          onTap: () async {
            await context.read<ProfileImageCubit>().getImage();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: BlocBuilder<ProfileImageCubit, File>(
                    builder: (context, state) {
                  return state.path == ''
                      ? Icon(
                          Icons.person,
                          size: 126.0,
                          color: !isLightTheme(context)
                              ? kIconLight
                              : Colors.black,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(126.0),
                          child: Image.file(state,
                              width: 126.0, height: 126.0, fit: BoxFit.fill));
                }),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  color: kPrimary,
                  size: 38.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
