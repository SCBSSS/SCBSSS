import 'package:flutter/material.dart';
import 'package:scbsss/views/heat_map.dart';

class DataTab extends StatelessWidget {
  const DataTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: MyHeatMap()),
      )
    );
  }
}