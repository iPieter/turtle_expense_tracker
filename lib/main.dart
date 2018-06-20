import 'ExpenseCategories.dart';
import 'package:flutter/material.dart';
import 'ApplicationDatabase.dart';

void main() => runApp(new Turtle());

class Turtle extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //remove shitty debug banner
      title: 'Expenses',
      home: new ExpenseCategories(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}