import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../drawer.dart';
import '../model/expenses.dart';
import '../component/timechart.dart';
import '../component/barchart.dart';
import '../constant/constant.dart';

final DatabaseReference expensesRef =
    FirebaseDatabase.instance.reference().child("expenses");

class HomeScreen extends StatefulWidget {
  static String pageTitle = "Home";
  static String routeName = "/";

  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _initExpenses();
  }

  @override
  void dispose() {
    _disposeExpenses();
    super.dispose();
  }

  // Start Expenses

  List<Expenses> expensesList = new List();
  StreamSubscription onExpensesAdded;

  void _initExpenses() {
    onExpensesAdded = expensesRef.onChildAdded.listen((event) {
      setState(() {
        expensesList.add(new Expenses.fromSnapshot(event.snapshot));
      });
    });
  }

  void _disposeExpenses() {
    onExpensesAdded.cancel();
  }

  static List<charts.Series<TimeSeriesItem, DateTime>> _createExpensesData(
      data) {
    return [
      new charts.Series<TimeSeriesItem, DateTime>(
        id: 'Expenses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesItem item, _) => item.time,
        measureFn: (TimeSeriesItem item, _) => item.value,
        data: data,
      )
    ];
  }

  static List<charts.Series<BarChartItem, String>> _createExpensesCategoryData(data) {
    return [
      new charts.Series<BarChartItem, String>(
        id: 'ExpensesCategory',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartItem item, _) => item.key,
        measureFn: (BarChartItem item, _) => item.value,
        data: data,
      )
    ];
  }

  Widget _buildExpenses() {
    DateTime today = new DateTime.now();
    double sum = 0.0;

    Map<DateTime,num> expensesChartMap = new Map();
    List<TimeSeriesItem> expensesChartData = new List();
    Map<String,num> expensesCategoryMap = new Map();
    List<BarChartItem> expensesCategoryData = new List();
    expensesList.sort((a, b) {
      return a.transactionDate.compareTo(b.transactionDate);
    });

    expensesList.where((expenses) {
      return (expenses.transactionDate.month == today.month &&
          expenses.transactionDate.year == today.year);
    }).forEach((expenses) {
      sum += expenses.price;

      DateTime t = new DateTime(expenses.transactionDate.year, expenses.transactionDate.month, expenses.transactionDate.day);
      String c = expenses.category ?? Constant.CATEGORY_OTHER;

      // For timeseries chart
      if(expensesChartMap.containsKey(t)) {
        expensesChartMap[t] = expensesChartMap[t] + expenses.price;
      } else {
        expensesChartMap[t] = expenses.price;
      }

      // For barchart
        if(expensesCategoryMap.containsKey(c)) {
          expensesCategoryMap[c] = expensesCategoryMap[c] + expenses.price;
        } else {
          expensesCategoryMap[c] = expenses.price;
        }
      
      
    });

    expensesChartMap.forEach((t,n) {
      expensesChartData
        .add(new TimeSeriesItem(t, n));
    });

    expensesCategoryMap.forEach((t,n) {
      expensesCategoryData
        .add(new BarChartItem(t, n));
    });

    Widget chart;
    if (expensesChartData.isNotEmpty) {
      chart = new SimpleTimeSeriesChart(
        _createExpensesData(expensesChartData),
        animate: true,
      );
    }

    Widget expensesCategoryChart;
    if(expensesCategoryData != null) {
      expensesCategoryChart = new SimpleBarChart(
        _createExpensesCategoryData(expensesCategoryData),
        animate: true,
      );
    }

    return new Card(
        child: new Column(children: <Widget>[
      new ListTile(
        title: new Text(
          "Expenses",
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: new Text(new DateFormat('MMMM y').format(today)),
        trailing: new Text("RM " + sum.toStringAsFixed(2)),
      ),
      new ListTile(title: new Text("By date"), subtitle: Container(child: chart, height: 200.0)),
      new ListTile(title: new Text("By category"), subtitle: Container(child: expensesCategoryChart, height: 200.0)),
    ]));
  }

  // End expenses

  @override
  Widget build(BuildContext context) {
    debugPrint("[HomeScreenState] Start build..");

    List<Widget> widgets = <Widget>[
      _buildExpenses(),
    ];

    return new Scaffold(
        drawer: new DrawerNavigation(),
        appBar: new AppBar(
          title: new Text("Home"),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return widgets[index];
          },
          itemCount: widgets.length,
        ));
  }
}
