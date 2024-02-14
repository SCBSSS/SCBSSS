import 'package:flutter/material.dart';
import 'package:scbsss/main_tab_widget.dart';
import 'package:scbsss/setup_wizard.dart';
import 'package:scbsss/services/database_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSetupDone = false;
  bool isLoading = true;

  void completeSetup(){
    setState(() {
      isSetupDone = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await DatabaseService.getDatabase(); // initializing scbsss_db
    setState(() {
      isLoading = false; // update loading state
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // show loading indicator
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: isSetupDone ? MainTabWidget() : SetupWizard(completeSetup),
    );
  }
}
