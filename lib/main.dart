import 'package:flutter/material.dart';
import 'package:first_flutter_test/home_page.dart';
import 'package:first_flutter_test/seasons_page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      initialPage: 0
    );

    return MaterialApp  (
      title: 'F1 Results',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        accentColor: Colors.black54,

        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white60),
          bodyText1: TextStyle(color: Colors.white60),
          bodyText2: TextStyle(color: Colors.white60),
        )
      ),
      home: PageView(
        controller: controller,
        children: [
          HomePage(),
          SeasonsPage()
        ]
      )
    );
  }
}
