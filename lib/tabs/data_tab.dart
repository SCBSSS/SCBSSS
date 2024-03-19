import 'package:flutter/material.dart';
import 'package:scbsss/views/heat_map.dart';
import 'package:flutter/cupertino.dart';

class DataTab extends StatefulWidget {
  const DataTab({super.key});

  @override
  State<DataTab> createState() => _DataTabState();
}

class _DataTabState extends State<DataTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildMetricsAppBar(),
        backgroundColor: Colors.grey,
        body: Center(child: MyHeatMap()),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              SizedBox(
                height: 175,
                child: DrawerHeader(
                  margin: EdgeInsets.only(bottom:40),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent
                  ),
                  child:
                    Text('Other Metrics',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    ),
                ),
              ),
              ListTile(
                title: Text('Heat Map'),
              ),
              ListTile(
                title: Text('Word Frequency')
              )
            ]
          ),
            ),
        ),
      );
  }

  AppBar _buildMetricsAppBar() {
    return AppBar(
        title: const Text('Your Metrics',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child:
              Icon(CupertinoIcons.line_horizontal_3, size: 30,)
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){

            },
            child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 37,
                decoration: BoxDecoration(
                    color: Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(16)),
                child: Icon(CupertinoIcons.info_circle, size: 30,)
            ),
          ),
        ],
      );
  }
}