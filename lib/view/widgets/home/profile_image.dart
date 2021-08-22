import 'package:flutter/material.dart';

import 'online_indicator.dart';

class ProfileImage extends StatelessWidget {
  final String url;
  final bool? online;

  const ProfileImage({
    Key? key,
    required this.url,
    this.online = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126.0),
            child: Image.network(
              url,
              width: 126.0,
              height: 126.0,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online! ? OnlineIndicator() : Container(),
          ),
        ],
      ),
    );
  }
}
