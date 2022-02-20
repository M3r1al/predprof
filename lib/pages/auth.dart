import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget{
  // const Home({Key key}) : super(key : key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  // void initFirebase() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyDdxrL4eZ4CcyJzH1ayPGFdXMY3LYCRq84",
  //           appId: "1:1035250211649:android:01298023ad703a6c3f1fc0",
  //           messagingSenderId: "1035250211649",
  //           projectId: "predprof-68d0e",
  //       ),
  //   );
  // }

  void initState() {
    super.initState();

    // initFirebase();
  }

  void setName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('name', _login.text);
      // Navigator.pushReplacementNamed(context, '/');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
              TextField(
                controller: _login,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 30.0
                ),
                decoration: InputDecoration(
                  // labelText: 'Логин',
                  label: Text(
                    'Логин',
                    //textScaleFactor: 1.8,
                  ),
                ),
              ),
              SizedBox(height: 4,),
              TextField(
                controller: _password,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                    fontSize: 30.0
                ),
                decoration: InputDecoration(
                  //labelText: 'Пароль',
                  label: Text(
                    'Пароль',
                    //textScaleFactor: 1.8,
                  )
                ),
              ),
              SizedBox(height: 14,),
              Row(
                children: [
                  ElevatedButton(onPressed: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance.collection(_login.text).orderBy('time', descending: false).get();
                    // var goOn = false;
                    if(query.docs.length > 0) {
                      String _pass = query.docs[0].get('name');
                      if(_pass == _password.text)
                      {
                        setName();
                      }
                    }
                  }, child: Text(
                    'Авторизация',
                    //textScaleFactor: 1.8,
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
                    //textScaleFactor: 1.8,
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