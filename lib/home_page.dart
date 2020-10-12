import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter_test/seasons_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  void _fetchAndGotoDataPage() async {
    http.Response response = await http.get(
      // Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        Uri.encodeFull("http://ergast.com/api/f1/seasons.json?limit=100"),
        headers: {
          "Accept": "application/json",
          //   "key": ""
        }
    );

    var responseData = jsonDecode(response.body);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeasonsPage(
              displayData: responseData['MRData']['SeasonTable']['Seasons'].reversed.toList(),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('API Data Display')
        ),
        body: Center(
            child: RaisedButton(
              child: Text('Get Data'),
              onPressed: _fetchAndGotoDataPage,
            )
        )
    );
  }
}
