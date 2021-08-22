import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50.0,
        height: 50.0,
        child: isLightTheme(context)
            ? SvgPicture.asset('assets/logo-dark.svg')
            : SvgPicture.asset('assets/logo-light.svg'));
  }
}
