// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{
  //const Home({Key key}) : super(key : key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // void initFirebase() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }

  void initState(){
    super.initState();

    // initFirebase();
  }

  String _name = "Guest";

  void loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? 0).toString();
      if(_name == '0')
        Navigator.pushReplacementNamed(context, '/auth');
    });
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
      body: Row(
        children: [
          Column(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/money');
              }, child: Text('Добавление доходов\nи расходов', textScaleFactor: pow, textAlign: TextAlign.center,)),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/graph');
              }, child: Text('Просмотреть график\nс прогнозом', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/auth');
              }, child: Text('Просмотреть диаграмму\nрасходов', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                //export
              }, child: Text('Экспорт данных в\nэксель файл', textScaleFactor: pow, textAlign: TextAlign.center,),),
              ElevatedButton(onPressed: () {
                //logout
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