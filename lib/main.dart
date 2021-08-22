import 'package:chat_app/composition_root.dart';
import 'package:chat_app/view/pages/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

import 'utils/theme.dart';
import 'view/pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: CompositionRoot.composeHomeUI(),
      // CompositionRoot.composeOnboardingUI(),
    );
  }
}
