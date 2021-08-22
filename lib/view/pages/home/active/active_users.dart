import 'package:chat/models/user.dart';
import 'package:chat_app/cubit/home/home_cubit.dart';
import 'package:chat_app/view/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({Key? key}) : super(key: key);

  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        if (state is HomeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeSuccess) {
          return _buildList(state.users);
        } else {
          return Container();
        }
      },
    );
  }

  _listItem(User user) => ListTile(
        leading: ProfileImage(
          url: user.photoUrl,
          online: true,
        ),
        title: Text(
          user.userName,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(right: 16.0, top: 30.0),
      itemBuilder: (_, index) => _listItem(users[index]),
      separatorBuilder: (_, __) => Divider(),
      itemCount: users.length);
}
