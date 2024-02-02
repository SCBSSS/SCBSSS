import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabWidget extends StatefulWidget {
  const MainTabWidget({super.key});

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState();
}

class _MainTabWidgetState extends State<MainTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Tabs go here lol"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: "Add Entry",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: "Entries",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: "Data",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
