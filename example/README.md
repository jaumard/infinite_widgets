# example

```
import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';

void main() {
  print('app started');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/list': (context) => InfiniteListExample(),
        '/grid': (context) => InfiniteGridExample(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              child: Text('Infinite list'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/grid');
              },
              child: Text('Infinite grid'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfiniteListExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InfiniteListExampleState();
  }
}

class _InfiniteListExampleState extends State<InfiniteListExample> {
  List<int> _data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite list'),
      ),
      body: InfiniteListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('$index', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          );
        },
        itemCount: _data.length,
        hasNext: _data.length < 200,
        nextData: this.loadNextData,
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
    );
  }

  loadNextData() {
    final initialIndex = _data.length;
    final finalIndex = _data.length + 10;
    print('load data from ${_data.length}');

    Future.delayed(Duration(seconds: 3), () {
      for (var i = initialIndex; i < finalIndex; ++i) {
        _data.add(i);
      }
      print('${_data.length} data now');
      setState(() {});
    });
  }
}

class InfiniteGridExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InfiniteGridExampleState();
  }
}

class _InfiniteGridExampleState extends State<InfiniteGridExample> {
  List<int> _data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite grid'),
      ),
      body: InfiniteGridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.grey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('$index', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        },
        itemCount: _data.length,
        hasNext: _data.length < 200,
        nextData: this.loadNextData,
      ),
    );
  }

  loadNextData() {
    final initialIndex = _data.length;
    final finalIndex = _data.length + 10;
    print('load data from ${_data.length}');

    Future.delayed(Duration(seconds: 3), () {
      for (var i = initialIndex; i < finalIndex; ++i) {
        _data.add(i);
      }
      print('${_data.length} data now');
      setState(() {});
    });
  }
}

```