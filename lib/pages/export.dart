import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

//export func
Future<void> export(String col) async {
  //get perms
  if (Platform.isAndroid) {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage
    ].request();//Permission.manageExternalStorage
  }
  //create excel
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  QuerySnapshot query = await FirebaseFirestore.instance.collection(col).orderBy('time').limit(200).get();
  for(int i = 1; i < query.docs.length; i++) {
    sheet.getRangeByName('A$i').setText(query.docs[query.docs.length - i].get('type'));
    sheet.getRangeByName('B$i').setText(query.docs[query.docs.length - i].get('day').toString() + ':' + query.docs[query.docs.length - i].get('month').toString() + ':' + query.docs[query.docs.length - i].get('year').toString());
    sheet.getRangeByName('C$i').setText(query.docs[query.docs.length - i].get('change').toString());
  }
  final List<int> bytes = workbook.saveAsStream();
  //clean
  workbook.dispose();

  if(kIsWeb){
    //web
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'output.xlsx')
        ..click();
  }
  else {
    //another
    final String? path = (await getDownloadsDirectory())?.path;
    final String fileName = '$path/output.xlsx';
    final File file = File(fileName);
    file.writeAsBytesSync(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
