import 'package:chat_app/cubit/onboarding/onboarding_cubit.dart';
import 'package:chat_app/cubit/profile_image/profile_image_cubit.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/view/widgets/onboarding/logo.dart';
import 'package:chat_app/view/widgets/onboarding/profile_upload.dart';
import 'package:chat_app/view/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(),
              Spacer(),
              ProfileUpload(),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  hint: 'What is your name?',
                  inputAction: TextInputAction.done,
                  onChanged: (String val) {
                    _userName = val;
                  },
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_userName.isEmpty) {
                      final snackBar = SnackBar(
                          content: Text('Enter your name.',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              )));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      "Let's chat!",
                      style: Theme.of(context).textTheme.button!.copyWith(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0))),
                ),
              ),
              Spacer(),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) => state is OnboardingLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container()),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Logo(),
        SizedBox(width: 8.0),
        Text(
          'Chat',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_userName, profileImage);
  }
}
