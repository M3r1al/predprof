import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget{
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  void initState() {
    super.initState();
  }

  //set name to sharedpreferences and go to main page
  void setName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('name', _login.text);
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Авторизация пользователя'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child:
          Column(
            children: [
              SizedBox(height: 40,),
              //input login
              TextField(
                controller: _login,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 30.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Логин',
                  ),
                ),
              ),
              SizedBox(height: 4,),
              //input password
              TextField(
                controller: _password,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                    fontSize: 30.0
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Пароль',
                  )
                ),
              ),
              SizedBox(height: 14,),
              //get send data from to firebase
              Row(
                children: [
                  ElevatedButton(onPressed: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance.collection(_login.text).orderBy('time', descending: false).get();
                    if(query.docs.length > 0) {
                      String _pass = query.docs[0].get('name');
                      if(_pass == _password.text)
                      {
                        setName();
                      }
                    }
                  }, child: Text(
                    'Авторизация',
                    style: TextStyle(
                      fontSize: 25.0
                    ),
                  )),
                  ElevatedButton(onPressed: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance.collection(_login.text).get();
                    if(query.docs.length <= 0) {
                      setName();
                      FirebaseFirestore.instance.collection(_login.text).add(
                          {'name': _password.text, 'time': -1});
                    }
                  }, child: Text(
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 25.0
                    ),
                  )),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              )
            ],
          )
      )
    );
  }
}