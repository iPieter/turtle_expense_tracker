import 'package:path_provider/path_provider.dart';
import 'package:turtle/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:io';

void main() => runApp(new Turtle());

class Turtle extends StatelessWidget {
  final Logger _log = new Logger('Turtle');

  Turtle() {
    //configurate logger
    Logger.root.level = Level.FINEST;
    Logger.root.onRecord.listen((LogRecord rec) async {
      final directory = await getApplicationDocumentsDirectory();
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
      new File('${directory.path}/finer.log')
          .writeAsStringSync('${rec.level.name}: ${rec.time}: ${rec.message}', mode: FileMode.writeOnlyAppend);
    });

    _log.info("Logger configurated");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //remove shitty debug banner
      title: 'Expenses',
      home: new Homepage(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
