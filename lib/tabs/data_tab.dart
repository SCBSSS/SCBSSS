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
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('What is the "Data" Tab?'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'This page is where SCBSSS shows your mood over time through a heat-map. \n\nP.S. There are more visuals to come.'
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 37,
                decoration: BoxDecoration(
                    color: Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(CupertinoIcons.info_circle, size: 30,)
            ),
          ),
        ],
      );
  }
}
