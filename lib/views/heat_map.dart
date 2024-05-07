import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'dart:ui' as ui;

import 'package:scbsss/services/database_service.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DatabaseService.instance.getAverageMoodByDay(), builder: (BuildContext context, AsyncSnapshot<Map<DateTime, int>> data) {
      return Scaffold(
        backgroundColor: Colors.blue[500],
        body: Center(child: _buildHeatMap(data))
      );
    });
  }

  HeatMap _buildHeatMap(AsyncSnapshot<Map<DateTime, int>> data) {
    return HeatMap(
      datasets: data.data,
      startDate: DateTime.now().subtract(Duration(days: 30)), //in the future, we can change this to when the user's account was created
      endDate: DateTime.now(), //this can also be changed, we should allow users to select this with a bar akin to how we allow mood to be entered in the 'Entries' tab
      size: 40,
      textColor: Colors.black,
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: const {
        1: Color.fromARGB(20, 2, 179, 8), // worst mood possible in entries
        2: Color.fromARGB(40, 2, 179, 8),
        3: Color.fromARGB(60, 2, 179, 8),
        4: Color.fromARGB(80, 2, 179, 8),
        5: Color.fromARGB(100, 2, 179,8), // best mood possible in entries - the darker the green, the better the mood
      },
    );
  }
}
