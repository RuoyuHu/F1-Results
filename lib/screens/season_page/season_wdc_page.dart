import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeasonWDCPage extends StatefulWidget {
  final season;
  SeasonWDCPage({this.season});

  @override
  SeasonWDCPageState createState() => SeasonWDCPageState();
}

class SeasonWDCPageState extends State<SeasonWDCPage> {
  Widget wdcData;

  @override
  void initState() {
    fetchWDCResult();
    super.initState();
  }

  Widget constructWDCTable(standingData) {
    List<TableRow> standingsTable = [
      TableRow(
        children: <Widget>[
          Text('Pos'),
          Text('Driver'),
          Text('Nat.'),
          Text('Const.'),
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
          children: <Widget>[
            Text('\n${entry['positionText']}'),
            Text(((entry['Driver']['code'] != null)?entry['Driver']['code']:'')
              +'\n${entry['Driver']['givenName']}\n${entry['Driver']['familyName']}'),
            Text('\n${entry['Driver']['nationality']}'),
            Text('\n${(entry['Constructors'].last)['name']}'),
            Text('\n${entry['points']}'),
            Text('\n${entry['wins']}')
          ]
        )
      );
    }
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(2.0),
        3: FlexColumnWidth(2.5),
        4: FlexColumnWidth(1.0),
        5: FlexColumnWidth(1.0),
      },
      children: standingsTable,
    );
  }

  void fetchWDCResult() async {
    http.Response response = await
      http.get("http://ergast.com/api/f1/${widget.season}/driverStandings.json");
    final responseData = jsonDecode(response.body);

    setState(() {
      wdcData = constructWDCTable(
          responseData
            ['MRData']
            ['StandingsTable']
            ['StandingsLists'][0]
            ['DriverStandings']
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return (wdcData != null)
        ? Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: wdcData
          )
        )
        : Center(
          child: CircularProgressIndicator()
        );
  }
}