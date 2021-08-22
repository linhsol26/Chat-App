import 'package:chat_app/cubit/home/home_cubit.dart';
import 'package:chat_app/view/pages/home/active/active_users.dart';
import 'package:chat_app/view/pages/home/chats/chats.dart';
import 'package:chat_app/view/widgets/home/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().activeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  ProfileImage(
                    url:
                        'https://static.toiimg.com/thumb/msid-67586673,width-800,height-600,resizemode-75,imgsize-3918697,pt-32,y_pad-40/67586673.jpg',
                    online: true,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'SMY',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'online',
                          style: Theme.of(context).textTheme.caption!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Messages'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Align(
                      alignment: Alignment.center,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          return state is HomeSuccess
                              ? Text('Active(${state.users.length})')
                              : Text('Active(0)');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Chats(),
              ActiveUsers(),
            ],
          )),
    );
  }
}
