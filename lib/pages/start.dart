// import 'package:flutter/material.dart';
// import 'package:predprof/pages/auth.dart';
// import 'package:predprof/pages/home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Start extends StatelessWidget{
//
//   @override
//   Widget build(BuildContext context) {
//     return new FutureBuilder<Widget>(
//       builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
//       final prefs = await SharedPreferences.getInstance();
//       final n = prefs.getString('name') ?? 0;
//       if (n == 0)
//         return Auth();
//       else
//         return Home();
//     }
//     );
//   }
//   Future<Widget>
//
// }
