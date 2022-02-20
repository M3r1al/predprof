import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Money extends StatefulWidget{
  @override
  State<Money> createState() => _MoneyState();
}

class _MoneyState extends State<Money> {

  //what we get and send to db
  String typeOfMoney = '';
  final TextEditingController data0_controller = TextEditingController();
  final TextEditingController data1_controller = TextEditingController();
  final TextEditingController data2_controller = TextEditingController();
  final TextEditingController change_controller = TextEditingController();

  //create menu item from string
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.grey[900]
      ),
    ),
  );

  void initState(){
    super.initState();
    typ = items[0];
  }

  List balance = [];
  String typ = '';

  //available types
  List<String> items = ['Транспорт', 'Аптеки', 'Дом', 'Одежда', 'Супермаркеты', 'Такси', 'Прочее'];

  @override
  Widget build(BuildContext context){
    //get name
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
              //all sized box for space
              SizedBox(height: 40,),
              //title
              Text(
                  'Добавление расхода/дохода',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    decoration: TextDecoration.overline,
                    decorationColor: Colors.deepOrangeAccent
                  ),
              ),
              SizedBox(height: 14,),
              //drop down list
              DropdownButton<String>(
                underline: Container(
                  height: 1.5,
                  color: Colors.grey[800],
                ),
                value: typ,
                items: items.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() => typ = value!),
                dropdownColor: Colors.grey[700],
              ),
              SizedBox(height: 14,),
              //input day
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
              //input month
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
              //input year
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
              //input change
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
                //send data to firebase
                int dday = clamp(int.parse(data0_controller.text)), mmonth = clamp(int.parse(data1_controller.text)), yyear = clamp(int.parse(data2_controller.text));
                int ttime = dday + mmonth + yyear;
                FirebaseFirestore.instance.collection(_name).add({'time': ttime, 'day' : dday, 'month' : mmonth, 'year' : yyear, 'change' : int.parse(change_controller.text), 'type' : typ});
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }, child: Text('Применить', style: TextStyle(fontSize: 30),))
            ],
          )
      )

    );
  }
}

clamp(int n) {
  if(n > 1)
    return n;
  else
    return 1;
}