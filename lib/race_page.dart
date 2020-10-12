import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class RacePage extends StatefulWidget {
  final displayData;

  RacePage({this.displayData});

  @override
  State<StatefulWidget> createState() => new RacePageState();
}

class RacePageState extends State<RacePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<List<dynamic>> raceResult;

  @override
  void initState() {
    super.initState();
    raceResult = fetchRaceResult();
    _tabController = TabController(vsync: this, length: 2);
  }

  Future<List<dynamic>> fetchRaceResult() async {
    var data = widget.displayData;
    http.Response response = await http.get("http://ergast.com/api/f1/${data['season']}/${data['round']}/results.json");
    var responseData = jsonDecode(response.body);
    print(responseData['MRData']['RaceTable']['Races'][0]['Results']);
    return responseData['MRData']['RaceTable']['Races'][0]['Results'];
  }

  Widget _buildResultList(dataSet) {
    print(dataSet[0]);
    print(dataSet[0].keys);
    List<TableRow> rows = [
      TableRow(
        children: <Widget>[
          Text("Pos"),
          Text("Driver"),
          Text("No."),
          Text("Constructor"),
          Text("Pts"),
          Text("Fastest Lap")
        ]
      )
    ];
    for (int i = 0; i < dataSet.length; i++) {
      var result = dataSet[i];
      var status = result['positionText'];
      if (status == "R") {
        status = "DNF";
      } else if (status == "W") {
        status = "DNS";
      }
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey)
                )
          ),
          children: <Widget>[
            Text("\n${status}"),
            Text(((result['Driver']['code']!= null)?"${result['Driver']['code']}":"")
                +"\n${result['Driver']['givenName']}\n${result['Driver']['familyName']}"),
            Text("\n${result['number']}"),
            Text("\n${result['Constructor']['name']}"),
            Text("\n${result['points']}"),
            Text("\n" + ((result['FastestLap'] != null)?"${result['FastestLap']['Time']['time']}":"N/A"))
          ]
        )
      );
    }
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1.0),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2.5),
        4: FlexColumnWidth(1.0),
        5: FlexColumnWidth(2.0),
      },
      children: rows,
    );
  }

  Widget _raceResultBuilder(isPast, date, hasTime) {
    if (!isPast) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text("Race will start on ${DateFormat("dd MMMM yyyy").format(date)}"
                + ((hasTime) ? " at ${widget.displayData['time']}" : ""))
            ],
          )
      );
    }
    return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20
          ),
          child:
          SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              FutureBuilder<List<dynamic>>(
                future: raceResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildResultList(snapshot.data);
                  }
                  return CircularProgressIndicator();
                }
            )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.displayData;
    DateTime date;
    var hasTime = data['time'] != null;
    if (hasTime) {
      date = DateTime.parse("${data['date']} ${data['time']}");
    } else {
      date = DateTime.parse("${data['date']}").toLocal();
    }
    var isPast = date.isBefore(DateTime.now());
    var location = data['Circuit']['Location'];
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text("${data['season']} ${data['raceName']}"),
              pinned: true,
              expandedHeight: 200,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Description'),
                  Tab(text: 'Results')
                ],
                controller: _tabController,
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Round ${data['round']} of the ${data['season']} formula 1 season"
                              "\n\n" + ((isPast) ? "Took" : "Takes") +
                              " place on ${DateFormat("dd MMMM yyyy").format(date)}"
                                + (hasTime ? " at ${data['time']} local time": "") +
                              "\n\nCircuit: ${data['Circuit']['circuitName']}"
                              "\nLocation: ${location['locality']}, ${location['country']}"
                              "\nlat: ${location['lat']} long: ${location['long']}"
                          )
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            child: Text("\nWikipedia:\n${data['url']}"),
                            onTap: () => launch(data['url']),
                          ),
                        ),
                        Center(
                          child: Image(
                              image: AssetImage("images/${data['Circuit']['circuitId']}.png")
                          )
                        )
                      ],
                    )
                  ),
                  _raceResultBuilder(isPast, date, hasTime)
                ]
              )
            )
          ],
        )
      )
    );
  }

}