import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget{
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  void initList(String _col) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection(_col).where('type', isEqualTo: type).limit(100).get();
    if(query.docs.length <= 1)
      drw = false;
    else {
      for(int i = 0; i < query.docs.length; i++){
        if(query.docs[i].get('change') as int >= 0)
          money[0].value += query.docs[i].get('change') as int;
        else
          money[1].value -= query.docs[i].get('change') as int;

      }
      setState(() {
        money = money;
      });
      drw = true;
    }
  }

  void initState() {
    super.initState();
  }

  String type = 'cat';
  bool init = true, drw = false;
  String _name = '';
  List<MoneyCircle> money = [MoneyCircle('Доход', 0), MoneyCircle('Расход', 0)];

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
          title: Text('Диаграммы'),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: Text(
            'У вас нет данных',
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
            title: Text('Диаграммы'),
            centerTitle: true,
            backgroundColor: Colors.deepOrangeAccent,
          ),
          body: SfCircularChart(
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap
            ),
            series: <CircularSeries>[
              PieSeries<MoneyCircle, String>(
                dataSource:  money,
                xValueMapper: (MoneyCircle mc, _) => mc.name,
                yValueMapper: (MoneyCircle mc, _) => mc.value,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                strokeColor: Colors.blueAccent
              )
            ],
          ),
        ),
      );
    }
  }
}

class MoneyCircle{
  MoneyCircle(this.name, this.value);
  String name;
  int value;
}