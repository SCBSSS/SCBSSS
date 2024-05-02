import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scbsss/notification_service.dart';
import 'package:scbsss/scbsss_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await initializeNotifications(); // Initialize notifications
  runApp(const SCBSSSApp());
}
