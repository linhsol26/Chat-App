import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        color: kIndicatorBubble,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 3.0,
          color: isLightTheme(context) ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
