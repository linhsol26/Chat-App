import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:chat_app/view/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.only(right: 16.0, top: 30.0),
        itemBuilder: (_, index) => _chatItem(),
        separatorBuilder: (_, __) => Divider(),
        itemCount: 3);
  }

  _chatItem() => ListTile(
        contentPadding: EdgeInsets.only(left: 16.0),
        leading: ProfileImage(
          url:
              'https://static.toiimg.com/thumb/msid-67586673,width-800,height-600,resizemode-75,imgsize-3918697,pt-32,y_pad-40/67586673.jpg',
          online: true,
        ),
        title: Text(
          'ZYX',
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: Text(
          'Ai ni o~',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
              ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '12 P.M.',
              style: Theme.of(context).textTheme.overline!.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                height: 15.0,
                width: 15.0,
                color: kPrimary,
                alignment: Alignment.center,
                child: Text(
                  '2',
                  style: Theme.of(context).textTheme.overline!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
}
