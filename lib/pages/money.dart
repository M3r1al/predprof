// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Money extends StatefulWidget{
  //const Home({Key key}) : super(key : key);

  @override
  State<Money> createState() => _MoneyState();
}

class _MoneyState extends State<Money> {

  // void initFirebase() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }

  String typeOfMoney = '';
  int data0 = 0;
  int data1 = 0;
  int data2 = 0;
  int moneyChange = 0;
  final TextEditingController type_controller = TextEditingController();
  final TextEditingController data0_controller = TextEditingController();
  final TextEditingController data1_controller = TextEditingController();
  final TextEditingController data2_controller = TextEditingController();
  final TextEditingController change_controller = TextEditingController();

  void initState(){
    super.initState();

    // initFirebase();
  }

  double pow = 1.8;

  List balance = [];

  @override
  Widget build(BuildContext context){
    final arguments = ModalRoute.of(context)!.settings.arguments as String;
    String _name = arguments;

    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Изменение данных'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child:
          Column(
            children: [
              SizedBox(height: 40,),
              Text(
                  'Добавление расхода/дохода',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    // decoration: TextDecoration.combine([TextDecoration.overline, TextDecoration.underline]),
                    decoration: TextDecoration.overline,
                    decorationColor: Colors.deepOrangeAccent
                  ),
              ),
              SizedBox(height: 14,),
              TextField(
                controller: type_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 25.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Категория',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              TextField(
                controller: data0_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 25.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'День',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              TextField(
                controller: data1_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 25.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Месяц',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              TextField(
                controller: data2_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 25.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Год',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              TextField(
                controller: change_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 25.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Изменение баланса',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              ElevatedButton(onPressed: () {
                FirebaseFirestore.instance.collection(_name).add({'day' : data0_controller.text, 'month' : data1_controller.text, 'year' : data2_controller.text, 'change' : change_controller.text, 'type' : type_controller.text});
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }, child: Text('Применить', style: TextStyle(fontSize: 30),))
            ],
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
      )

    );
  }
}

/* old column
Column(
            children: [
              SizedBox(height: 40,),
              Text('Добавление нового расхода/дохода'),
              SizedBox(height: 14,),
              TextField(
                controller: type_controller,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontSize: 20.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Добавление нового расхода/дохода',
                  ),
                ),
              ),
              SizedBox(height: 14,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  TextField(
                    controller: data0_controller,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        'День',
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  TextField(
                    controller: data1_controller,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        'Месяц',
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  TextField(
                    controller: data2_controller,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                    decoration: InputDecoration(
                      label: Text(
                        'Год',
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              )
            ],
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
 */