import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'ApplicationDatabase.dart';
import 'Expense.dart';

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //subtitle: new Text("test"),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        setState(() async {

          ApplicationDatabase db = new ApplicationDatabase();
          await db.insertExpense(new Expense(3.0, "test", DateTime.now(), "here", "De Oplossing"));

          var list = await db.getExpenses();
          print(list);

          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add expense'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushExpense() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Add expense'),
          ),
          body: new GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 5,
                  children: <Widget>[
                    new FlatButton(
                        onPressed: () {},
                        child: const Icon(Icons.free_breakfast,
                            color: Colors.blue)),
                  ],
                ),
        );
      }),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Image.network(
            "https://emoji.slack-edge.com/T7738P6P3/bob/0dbb39dcbacebe4e.png"),
        onPressed: () {},
      ),
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: _pushExpense,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
