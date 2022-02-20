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

MoneyPoint lin_reg_m(List<MoneyPoint> p, int m) {
  double xx = 0, yy = 0, xy = 0;
  for(int i = 0; i < p.length; i++) {
    xx += p[i].time;
    yy += p[i].value;
    xy += p[i].value * p[i].time;
  }
  xx /= p.length;
  yy /= p.length;
  double Dx = 0, Dy = 0;
  for(int i = 0; i < p.length; i++) {
    Dx += (p[i].time - xx)*(p[i].time - xx);
    Dy += (p[i].value - xx)*(p[i].value - xx);
  }
  Dx /= p.length;
  Dy /= p.length;
  Dx = sqrt(Dx);
  Dy = sqrt(Dy);
  double r = (xy - p.length * xx * yy) / (p.length * Dx * Dy);
  return MoneyPoint((r * Dy * (lastDay(m) - xx) / Dx - yy).round(), lastDay(m));
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
    QuerySnapshot query = await FirebaseFirestore.instance.collection(_col).orderBy('time').limit(100).get();
    if(query.docs.length <= 1)
      drw = false;
    else {
      int m = query.docs[query.docs.length - 1].get('month') as int;
      for (int i = query.docs.length - 1; i >= 1; i--) {
        if (query.docs[i].get('month') as int != m)
          break;
        if(query.docs[i].get('change') as int >= 0) {
          bool _add = true;
          for (int j = 0; j < upM.length; j++) {
            if (upM[j].time == query.docs[i].get('day') as int) {
              _add = false;
              upM[j].value += query.docs[i].get('change') as int;
            }
          }
          if(_add)
            upM.add(MoneyPoint(query.docs[i].get('change') as int, query.docs[i].get('day') as int));
        }
        else {
          bool _add = true;
          for (int j = 0; j < downM.length; j++) {
            if (downM[j].time == query.docs[i].get('day') as int) {
              _add = false;
              downM[j].value -= query.docs[i].get('change') as int;
            }
          }
          if(_add)
            downM.add(MoneyPoint(query.docs[i].get('change') as int, query.docs[i].get('day') as int));
        }
      }
      if(downM.length < lastDay(m) && downM.length > 0)
        downM.insert(0, lin_reg_m(downM, m));
      else if(downM.length == 1)
        downM.insert(0, MoneyPoint(downM[0].value, lastDay(m)));
      if(upM.length < lastDay(m) && upM.length > 0)
        upM.insert(0, lin_reg_m(upM, m));
      else if(upM.length == 1)
        upM.insert(0, MoneyPoint(upM[0].value, lastDay(m)));
      setState(() {
        downM = downM.reversed.toList();
        upM = upM.reversed.toList();
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
              yValueMapper: (MoneyPoint mp, _) => mp.value,
              color: Colors.redAccent,
              name: 'Расходы'
            ),
            LineSeries<MoneyPoint, int>(dataSource: upM,
              xValueMapper: (MoneyPoint mp, _) => mp.time,
              yValueMapper: (MoneyPoint mp, _) => mp.value,
              color: Colors.blueAccent,
              name: 'Доходы'
            )
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