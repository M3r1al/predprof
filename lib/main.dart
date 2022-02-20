import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:predprof/pages/chart.dart';
import 'package:predprof/pages/graph.dart';
import 'package:predprof/pages/home.dart';
import 'package:predprof/pages/money.dart';
import 'package:predprof/pages/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDdxrL4eZ4CcyJzH1ayPGFdXMY3LYCRq84",
      appId: "1:1035250211649:android:01298023ad703a6c3f1fc0",
      messagingSenderId: "1035250211649",
      projectId: "predprof-68d0e",
    ),
  );
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.deepOrangeAccent,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/money': (context) => Money(),
      '/graph': (context) => Graph(),
      '/chart': (context) => Chart(),
      '/auth': (context) => Auth(),
    },
  ));
}