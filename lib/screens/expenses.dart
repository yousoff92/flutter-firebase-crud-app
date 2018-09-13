import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import '../drawer.dart';
import '../model/expenses.dart';
import '../screens/expenses/expenses_form.dart';
import '../constant/constant.dart';



final DatabaseReference expensesRef =
    FirebaseDatabase.instance.reference().child("expenses");

/*
*   Parent widget
*/

class ExpensesScreen extends StatefulWidget {
  static String pageTitle = "Expenses";
  static String routeName = "/expenses";

  @override
  State<StatefulWidget> createState() {
    return new ExpensesState();
  }
}

class ExpensesState extends State<ExpensesScreen> {
  int noOfSelectedItems = 0;
  List<Expenses> selectedItems = new List();
  AppBar appBar = getDefaultAppBar();

  static getDefaultAppBar() => ( new AppBar(title: new Text("Expenses"),)); 

  int onPress(bool selected, Expenses selectedItem) {
    setState(() {
      if(selected) {
        noOfSelectedItems++;
        selectedItems.add(selectedItem);
      } else {
        noOfSelectedItems--;
        selectedItems.removeWhere((item) => item.key == selectedItem.key);
      }
    });

    if(noOfSelectedItems > 0) {
        appBar = getSelectionAppBar();
    } else {
      appBar = getDefaultAppBar();
    }

    return noOfSelectedItems;
  }

  AppBar getSelectionAppBar() {
    return new AppBar(
        title: new Text("Selected Item " + this.noOfSelectedItems.toString()),
        actions: <Widget>[
          new IconButton(
          icon: new Icon(Icons.delete),
          tooltip: 'Delete',
          onPressed: _onPressedDelete,
        ),
        ],
      );
  }

  void _onPressedDelete() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Deletion"),
          content: new Text("Are you sure you want to delete these item(s) ? "),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                confirmedDelete();
                Navigator.of(context).pop();

                setState(() {
                  appBar = getDefaultAppBar();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void confirmedDelete() {
    for(Expenses item in selectedItems) {
      expensesRef.child(item.key).remove();
      print("Removed " + item.key);
    }
     noOfSelectedItems = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ExpensesInheritedWidget(
      noOfSelectedItems : noOfSelectedItems,
      onPress : onPress,
      appBar : appBar,
      child : ExpensesListStateful(),
    );
  }
}

class ExpensesInheritedWidget extends InheritedWidget {

  ExpensesInheritedWidget({
    Key key,
    this.noOfSelectedItems,
    this.onPress,
    this.appBar,
    Widget child,
  }) : super(key : key, child : child);

  final int noOfSelectedItems;
  final Function onPress;
  final AppBar appBar;

  @override
  bool updateShouldNotify(ExpensesInheritedWidget old) {
    return true;
  }

  static ExpensesInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ExpensesInheritedWidget);
  }
}

/*
*   The child widgets
*/

class ExpensesListStateful extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new ExpensesList();
}

class ExpensesList extends State<ExpensesListStateful> {

  Widget scaffold;
  List<Expenses> items = new List();

  @override
  void initState() {
    expensesRef.onChildAdded.listen(_onEntryAdded);
    expensesRef.onChildChanged.listen(_onEntryEdited);
    expensesRef.onChildRemoved.listen(_onEntryRemoved);
    super.initState();
  }
  

  _onEntryAdded(Event event) {
    setState(() {
      items.add(new Expenses.fromSnapshot(event.snapshot));
    });
  }

  _onEntryEdited(Event event) {
    var oldValue = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(oldValue)] = new Expenses.fromSnapshot(event.snapshot);
    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      items.removeWhere((item) => item.key == event.snapshot.key);
    });
  }

  Future _openAddDialog() async {
    Expenses item = await Navigator.of(context).push(new MaterialPageRoute<Expenses>(
        builder: (BuildContext context) {
          return new ExpensesForm.add(new Expenses());
        },
        fullscreenDialog: true));

    print("_openAddDialog");
    if (item != null) {
      expensesRef.push().set(item.toJson());
    }
  }

  Widget _buildScaffold(context) {
    final ExpensesInheritedWidget inheritedWidget = ExpensesInheritedWidget.of(context);
    AppBar appBar = inheritedWidget.appBar;

    FloatingActionButton buttons;
    if(inheritedWidget.noOfSelectedItems == 0) {
      buttons = new FloatingActionButton(
        onPressed: () => _openAddDialog(),
        child: new Icon(Icons.add),
      );
    }

    List<Widget> expensesList = [];
    // Order expenses in descending order
    items.sort((a, b) { 
      return b.transactionDate.compareTo(a.transactionDate); 
    });

    TextStyle textStyle = new TextStyle(fontWeight: FontWeight.bold, height:1.5);
    DateTime previousDate;
    DateTime today = new DateTime.now();

    for (var item in items) { 
      if(previousDate == null) {
        if((item.transactionDate.day == today.day) 
          && (item.transactionDate.month == today.month)) {
          expensesList.add(
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text("Today", 
                style: textStyle,
                )),
            );
        } else {
          expensesList.add(
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(new DateFormat("dd MMM yyyy").format(item.transactionDate), 
                style: textStyle,
              )
            ),
          );
        }

      } else if ( (item.transactionDate.day == previousDate.day) 
          && (item.transactionDate.month == previousDate.month)) {
        // do nothing
      } else {
       expensesList.add(
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text(new DateFormat("dd MMM yyyy").format(item.transactionDate), 
                style: textStyle,
              )
            ),
          );
      }
      // print(item.name + "\t" + item.key);
      Key myKey = new Key(item.key);
      expensesList.add(new ExpensesCardStateful(myKey, item));
      previousDate = item.transactionDate;
    }
    
    return new Scaffold(
          drawer: new DrawerNavigation(),
          appBar: appBar,
          body: new ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return expensesList[index];
            },
            itemCount: expensesList.length,
          ),
          floatingActionButton: buttons,
        );
  }

  @override
  Widget build(BuildContext context) {
    print("Building expenses list");
    scaffold = _buildScaffold(context);
    return scaffold;
  }
}

class ExpensesCardStateful extends StatefulWidget {
  final Expenses item;
  ExpensesCardStateful(Key key, this.item) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ExpensesCard(item);
  }
}

class ExpensesCard extends State<ExpensesCardStateful> {

  Expenses item;
  bool selected = false;
  ExpensesCard(this.item);

  void _onTap(BuildContext context) {
    final ExpensesInheritedWidget inheritedWidget = ExpensesInheritedWidget.of(context);
    if(inheritedWidget.noOfSelectedItems > 0) {
      this.selected = !this.selected;
      int selectedItems = inheritedWidget.onPress(this.selected, this.item);
      print("Tap " + selectedItems.toString());
    } else {
      _openEditDialog(context, this.item);
    }
  }

  void _onLongPress(BuildContext context) {
    final ExpensesInheritedWidget inheritedWidget = ExpensesInheritedWidget.of(context);
    this.selected = !this.selected;
    int selectedItems = inheritedWidget.onPress(this.selected, this.item);
    print("Long press " + selectedItems.toString());
  }

  void _openEditDialog(BuildContext context, Expenses item) {
    Navigator
        .of(context)
        .push(
          new MaterialPageRoute<Expenses>(
            builder: (BuildContext context) {
              return new ExpensesForm.edit(item);
            },
            fullscreenDialog: true,
          ),
        )
        .then((updatedItem) {
          if (updatedItem != null) {
            expensesRef.child(item.key).set(updatedItem.toJson());
          }
    });
  }

  @override
  Widget build(BuildContext context) {

    Icon icon;
    switch (item.category) {
      case Constant.CATEGORY_FOOD:
        icon = const Icon(Icons.restaurant);
        break;
      case Constant.CATEGORY_ENTERTAINMENT:
        icon = const Icon(Icons.videogame_asset);
        break;
      case Constant.CATEGORY_HOME:
        icon = const Icon(Icons.home);
        break;
      case Constant.CATEGORY_TRAVEL:
        icon = const Icon(Icons.directions_car);
        break;
      default:
        icon = const Icon(Icons.info);
    }

    ListTile listTile = new ListTile(
      leading: icon,
      title: new Text(item.name),
      trailing: new Text("RM " + item.price.toStringAsFixed(2)),
      selected: selected, 
      onTap: () => _onTap(context),
      onLongPress: () => _onLongPress(context),
    );

    return new Card(
      child: new Column(
          mainAxisSize: MainAxisSize.min, children: <Widget>[listTile]),
    );
  }
}

