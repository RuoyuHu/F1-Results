import 'package:flutter/material.dart';
import 'package:first_flutter_test/home_page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp  (
      title: 'Flutter Test',
      home: HomePage()
    );
}
}
