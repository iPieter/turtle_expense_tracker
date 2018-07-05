import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CategoryDetail extends StatefulWidget {
  final Tuple3 _category;

  const CategoryDetail(this._category);

  @override
  _CategoryDetailState createState() => _CategoryDetailState(_category);
}

class _CategoryDetailState extends State<CategoryDetail> {
  final Tuple3 _category;

  _CategoryDetailState(this._category);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_category.item1),
      ),
      body: new Text('€ ' + _category.item2.toString()),
    );
  }
}
