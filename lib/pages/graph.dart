import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends StatefulWidget{
  //const Home({Key key}) : super(key : key);

  @override
  State<Graph> createState() => _GraphState();
}

double lin_reg(List xs, List ys, double x) {
  double xx = 0, yy = 0, xy = 0;
  for(int i = 0; i < xs.length; i++) {
    xx += xs[i];
    yy += ys[i];
    xy += xs[i] * ys[i];
  }
  xx /= xs.length;
  yy /= xs.length;
  double Dx = 0, Dy = 0;
  for(int i = 0; i < xs.length; i++) {
    Dx += (xs[i] - xx)*(xs[i] - xx);
    Dy += (xs[i] - xx)*(xs[i] - xx);
  }
  Dx /= xs.length;
  Dy /= xs.length;
  Dx = sqrt(Dx);
  Dy = sqrt(Dy);
  double r = (xy - xs.length * xx * yy) / (xs.length * Dx * Dy);
  return r * Dy * (x - xx) / Dx - yy;
}

int lastDay(int num){
  switch(num){
    case(1):
      return 31;
    case(2):
      return 28;
    case(3):
      return 31;
    case(4):
      return 30;
    case(5):
      return 31;
    case(6):
      return 30;
    case(7):
      return 31;
    case(8):
      return 31;
    case(9):
      return 30;
    case(10):
      return 31;
    case(11):
      return 30;
    case(12):
      return 31;
  }
  return 30;
}

class _GraphState extends State<Graph> {

  void initList(String _col) async {
    // downM = [];
    // upM = [];
    QuerySnapshot query = await FirebaseFirestore.instance.collection(_col).get();
    if(query.docs.length <= 1)
      drw = false;
    else {
      int m = int.parse(query.docs[query.docs.length - 1].get('month'));
      for (int i = query.docs.length - 1; i >= 1; i--) {
        if (int.parse(query.docs[i].get('month')) != m)
          break;
        if(int.parse(query.docs[i].get('change')) >= 0) {
          bool _add = true;
          for (int j = 0; j < upM.length; j++) {
            if (upM[j].time == int.parse(query.docs[i].get('day'))) {
              _add = false;
              upM[j].value += int.parse(query.docs[i].get('change'));
            }
          }
          if(_add)
            upM.add(MoneyPoint(int.parse(query.docs[i].get('change')), int.parse(query.docs[i].get('day'))));
        }
        else {
          bool _add = true;
          for (int j = 0; j < downM.length; j++) {
            if (downM[j].time == int.parse(query.docs[i].get('day'))) {
              _add = false;
              downM[j].value -= int.parse(query.docs[i].get('change'));
            }
          }
          if(_add)
            downM.add(MoneyPoint(int.parse(query.docs[i].get('change')), int.parse(query.docs[i].get('day'))));
        }
      }
      setState(() {
        downM = downM;
        upM = upM;
      });
      drw = true;
    }
  }

  void initState() {
    super.initState();
  }

  bool drw = false;
  bool init = true;
  List<MoneyPoint> upM = [], downM = [];
  String _name = '';

  @override
  Widget build(BuildContext context) {
    if(init) {
      final arguments = ModalRoute
          .of(context)!
          .settings
          .arguments as String;
      _name = arguments;
      initList(_name);
      init = false;
    }

    if(!drw){
      return Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: Text('График с прогнозом'),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: Text(
            'У вас нет расходов для прогноза',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              backgroundColor: Colors.redAccent
            ),
          ),
        ),
      );
    }
    else{
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('График с прогнозом'),
            centerTitle: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          body: SfCartesianChart(series: <ChartSeries>[
            LineSeries<MoneyPoint, int>(dataSource: downM,
              xValueMapper: (MoneyPoint mp, _) => mp.time,
              yValueMapper: (MoneyPoint mp, _) => mp.value),
            LineSeries<MoneyPoint, int>(dataSource: upM,
              xValueMapper: (MoneyPoint mp, _) => mp.time,
              yValueMapper: (MoneyPoint mp, _) => mp.value)
          ],),
          ),
      );
    }
  }
}

class MoneyPoint{
  MoneyPoint(this.value, this.time);
  int value;
  int time;
}