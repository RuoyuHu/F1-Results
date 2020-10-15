import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class SeasonWCCPage extends StatefulWidget {
  final season;
  SeasonWCCPage({this.season});

  @override
  SeasonWCCPageState createState() => SeasonWCCPageState();
}

class SeasonWCCPageState extends State<SeasonWCCPage> {
  Widget wccData;

  @override
  void initState() {
    fetchWCCResult();
    super.initState();
  }

  Widget constructWCCTable(standingData) {
    List<TableRow> standingsTable = [
      TableRow(
          children: <Widget>[
            Text('Pos'),
            Text('Constructor'),
            Text('Nat.'),
            Text('Pts'),
            Text('Wins')
          ]
      ),
      TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 1.0,
                  color: Colors.grey),
            ),
          ),
          children: [
            Text(''),
            Text(''),
            Text(''),
            Text(''),
            Text(''),
          ]
      ),
    ];
    for (var entry in standingData) {
      standingsTable.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 1.0,
                  color: Colors.grey),
            ),
          ),
          children: [
            Text('\n${entry['position']}\n'),
            Text('\n${entry['Constructor']['name']}'),
            Text('\n${entry['Constructor']['nationality']}'),
            Text('\n${entry['points']}'),
            Text('\n${entry['wins']}')
          ]
        )
      );
    }
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(3.0),
        2: FlexColumnWidth(3.0),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: standingsTable,
    );
  }

  void fetchWCCResult() async {
    http.Response response = await
    http.get("http://ergast.com/api/f1/${widget.season}/constructorStandings.json");
    final responseData = jsonDecode(response.body)['MRData']['StandingsTable'];
    setState(() {
      wccData = constructWCCTable(responseData['StandingsLists'][0]
                                              ['ConstructorStandings']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (wccData != null)
        ? Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: wccData
        )
    )
        : Center(
        child: CircularProgressIndicator()
    );
  }
}