import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: Text('Formula 1 Results Display')
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("images/homebg2.jpg")
            )
        ),
        child: Center(
          child: MaterialButton(
            color: Colors.transparent,
            textColor: Colors.white,
            child: Row(
              children: [
                Icon(Icons.keyboard_arrow_left_rounded),
                Icon(Icons.keyboard_arrow_left_rounded),
                Icon(Icons.keyboard_arrow_left_rounded),
                Text('Swipe left to start')
              ]
            ),
            padding: EdgeInsets.all(30),
            onPressed: (){},
          ),
        )
      )
    );
  }
}
