import 'package:first_flutter_test/season_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_flutter_test/common.dart' as common;


class SeasonsPage extends StatefulWidget {
  final displayData;

  SeasonsPage({this.displayData});

  @override
  SeasonsPageState createState() => new SeasonsPageState();
}

class SeasonsPageState extends State<SeasonsPage> {
  void _fetchAndGotoSeasonPage(season) async {
    http.Response response = await http.get(
        Uri.encodeFull("http://ergast.com/api/f1/${season}.json"),
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
      child: ListTile(
        title: Text(
          "${season} season",
          style: common.BIGGER_FONT,
        ),
        onTap: () => _fetchAndGotoSeasonPage(season),
      ),
    );
  }

  Widget _buildDataDisplay() {
    return ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: widget.displayData.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _buildRow(widget.displayData[index]);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Seasons")
        ),
        body: _buildDataDisplay()
    );
  }
}
