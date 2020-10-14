import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:first_flutter_test/race_page.dart';

class SeasonPage extends StatefulWidget {
  final displayData;

  SeasonPage({this.displayData});

  @override
  SeasonPageState createState() => new SeasonPageState();
}

class SeasonPageState extends State<SeasonPage> {

  void _gotoRacePage(raceData) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RacePage(displayData: raceData)
        ));
  }

  Widget _buildRow(item) {
    DateTime date;
    if (item['time'] != null) {
      date = DateTime.parse("${item['date']} ${item['time']}").toLocal();
    } else {
      date = DateTime.parse("${item['date']}").toLocal();
    }
    return Card(
      color: Colors.black54,
      child: ListTile(
        onTap: () => _gotoRacePage(item),
        leading: Text(
          item['round'],
          style: TextStyle(fontSize: 25),
        ),
        title: Text(item['raceName']),
        subtitle: Text(
            "${item['Circuit']['circuitName']}\n${DateFormat("dd MMMM").format(date)}"),
        trailing:
            (() {
          if (date.isBefore(DateTime.now())) {
            return Icon(
                Icons.emoji_events,
                color: Colors.amberAccent
            );
          } else {
            return Icon(Icons.more_vert);
        }})(),
      ),
    );
  }

  Widget _buildRaceDisplay(displayData) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("images/homebg3.jpg")
            )
        ),
        child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: displayData.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _buildRow(displayData[index]);
        }
      )
    );
  }

  Widget build(BuildContext context) {
   final displayData = widget.displayData;
    return Scaffold(
      appBar: AppBar(
        title: Text("${displayData['season']} Formula 1 season"),
      ),
      body: _buildRaceDisplay(displayData['Races']),
    );
  }
}
