
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Added .dart files
import 'screens/home.dart';
import 'screens/vehicle.dart';
import 'screens/expenses.dart';
import 'screens/personal.dart';
import 'screens/settings.dart';

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  print("[Management App] Started...");
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {

    var routes = <String, WidgetBuilder> {
      '/vehicle' : (BuildContext context) => new VehicleScreen(),
      '/expenses' : (BuildContext context) => new ExpensesScreen(),
      '/personal' : (BuildContext context) => new PersonalScreen(),
      '/settings' : (BuildContext context) => new SettingsScreen(),
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