import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amberAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text('my App'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('my App', style: TextStyle(
              fontSize:  20,
              color: Colors.red,
              fontFamily: 'Times New Roman'
          ),),
        ),
      ),
    );
  }
}