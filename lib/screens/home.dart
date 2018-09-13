import 'package:flutter/material.dart';

import '../drawer.dart';

class HomeScreen extends StatefulWidget {

  static String pageTitle = "Home";
  static String routeName = "/"; 

  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      drawer: new DrawerNavigation(),
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text("This is your home screen")],
        ),
      ),
    );
  }
}

