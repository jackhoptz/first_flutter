import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'second_route.dart';

import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.amber,
          buttonTheme: const ButtonThemeData(height: 50.0)),
      home: new Scaffold(
        body: new MyHomePage(title: 'Flutter ❤️ Native'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const channel = const MethodChannel("flutter.testfairy.com/hello");

  Future<Null> _openNewPage() async {
    final response =
        await channel.invokeMethod("openPage", ["Hi From Flutter"]);
    print(response);
  }

  Future<Null> _showDialog() async {
    final response =
        await channel.invokeMethod("showDialog", ["Called From Flutter"]);
//    print(response);
    final snackbar = new SnackBar(content: new Text(response));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  Future<Null> _requestNetwork() async {
    final response = await channel.invokeMethod(
        "request", ["https://www.thesportsdb.com/api/v1/json/1/"]);
//    print(response);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new SecondRoute(data: response),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // the App.build method, and use it to set our appbar title.
        title: new Center(
          child: new Text(widget.title),
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new RaisedButton(
                onPressed: () => _openNewPage(),
                child: new Text("Open Second Activity / UIViewController"),
                color: Colors.deepPurple,
                textColor: Colors.white,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new RaisedButton(
                onPressed: () => _showDialog(),
                child: new Text("Show Dialog / Alert"),
                color: Colors.blueAccent,
                textColor: Colors.white,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new RaisedButton(
                onPressed: () => _requestNetwork(),
                child: new Text("Call Retrofit / Alamofire"),
                color: Colors.teal,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
    // Here we take the value from the MyHomePage object that was created by
  }
}
