import 'package:flutter/material.dart';
import 'package:predprof/pages/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState(){
    super.initState();
    loadName();
  }

  String _name = "Guest";

  //get name from sharedpreferences and go to auth page if no one found
  void loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? '0').toString();
      if(_name == '0')
        Navigator.pushReplacementNamed(context, '/auth');
    });
  }

  //log out func
  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    Navigator.pushReplacementNamed(context, '/auth');
  }

  double pow = 1.8;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Главная страница | ' + _name),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      //menu
      body: Row(
        children: [
          Column(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/money', arguments: _name);
              }, child: Text('Добавление доходов\nи расходов', textScaleFactor: pow, textAlign: TextAlign.center,)),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/graph', arguments: _name);
              }, child: Text('Просмотреть график\nс прогнозом', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/chart', arguments: _name);
              }, child: Text('Просмотреть диаграмму\nрасходов', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                export(_name);
              }, child: Text('Экспорт данных в\nэксель файл', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                logOut();
              }, child: Text('Выйти из аккаунта', textScaleFactor: pow, textAlign: TextAlign.center,),)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),

    );
  }
}