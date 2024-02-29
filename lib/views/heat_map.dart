import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      datasets: {
        DateTime(2024, 2, 28): 4,
        DateTime(2024, 2, 29): 1,
        DateTime(2024, 3, 1): 3,
        DateTime(2024, 3, 2): 2,
        DateTime(2024, 3, 3): 5,
        DateTime(2024, 3, 4): 2
      },
      startDate: DateTime.now(),//in the future, we can change this to when the user's account was created
      endDate: DateTime.now().add(Duration(days: 60)), //this can also be changed, we should allow users to select this with a bar akin to how we allow mood to be entered in the 'Entries' tab
      size: 40,
      textColor: Colors.black,
      colorMode: ColorMode.opacity,
      showText: false,
      scrollable: true,
      colorsets: {
        1: Color.fromARGB(20, 2, 179, 8), // worst mood possible in entries
        2: Color.fromARGB(40, 2, 179, 8),
        3: Color.fromARGB(60, 2, 179, 8),
        4: Color.fromARGB(80, 2, 179, 8),
        5: Color.fromARGB(100, 2, 179, 8), // best mood possible in entries - the darker the green, the better the mood
      },

    );
  }
}