import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Added .dart files
import 'screens/home.dart';
import 'screens/item.dart';
import 'screens/vehicle.dart';
import 'screens/expenses.dart';

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  print("Started...");
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {

    var routes = <String, WidgetBuilder> {
      '/item' : (BuildContext context) => new ItemScreen(),
      '/vehicle' : (BuildContext context) => new VehicleScreen(),
      '/expenses' : (BuildContext context) => new ExpensesScreen(),
    };

    return new MaterialApp(
      title: 'Management App',
      home: new HomeScreen(),
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      routes: routes,
    );
  }
}