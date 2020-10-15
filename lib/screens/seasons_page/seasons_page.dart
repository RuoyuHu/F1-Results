import 'package:first_flutter_test/screens/season_page/season_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter_test/common.dart' as common;


class SeasonsPage extends StatefulWidget {
  @override
  SeasonsPageState createState() => new SeasonsPageState();
}

class SeasonsPageState extends State<SeasonsPage> {
  List<dynamic> displayData;

  @override
  void initState() {
    _fetchSeasonsData();
    super.initState();
  }

  void _fetchSeasonsData() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://ergast.com/api/f1/seasons.json?limit=100"),
        headers: {
          "Accept": "application/json",
          //   "key": ""
        }
    );

    var responseData = jsonDecode(response.body);
    setState(() {
      displayData =
          responseData['MRData']['SeasonTable']['Seasons'].reversed.toList();
    });
  }

  void _fetchAndGotoSeasonPage(season) async {
    http.Response response = await http.get(
        Uri.encodeFull("http://ergast.com/api/f1/$season.json"),
        headers: {
          "Accept": "application/json",
        }
    );

    var responseData = jsonDecode(response.body)['MRData'];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeasonPage(
                displayData: responseData['RaceTable']
            )
        )
    );
  }

  Widget _buildRow(item) {
    var season = item['season'];
    return Card(
      color: Colors.black54,
      child: ListTile(
        title: Text(
          "$season season",
        ),
        onTap: () => _fetchAndGotoSeasonPage(season),
      ),
    );
  }

  Widget _buildDataDisplay() {
    return Scrollbar(child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: displayData.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(color: Colors.white,);
          final index = i ~/ 2;
          return _buildRow(displayData[index]);
        }
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Seasons")
        ),
        body: (displayData != null)
            ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("images/homebg1.jpg")
                )
            ),
            child: _buildDataDisplay()
        )
            : Center(child: CircularProgressIndicator())
    );
  }
}
