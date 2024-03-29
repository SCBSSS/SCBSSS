import 'package:flutter/material.dart';

class WellBeing extends StatefulWidget {
  const WellBeing({super.key});

  @override
  State<WellBeing> createState() => _WellBeingState();
}

class _WellBeingState extends State<WellBeing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white24,
          title: Text(
            "Well-being",
            style:
                TextStyle(fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
          )),
    );
  }
}
