import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../drawer.dart';
import '../model/item.dart';
import '../screens/item/item_form.dart';



final DatabaseReference itemRef =
    FirebaseDatabase.instance.reference().child("item");

/*
*   Parent widget
*/

class ItemScreen extends StatefulWidget {
  static String pageTitle = "Item";
  static String routeName = "/item";

  @override
  State<StatefulWidget> createState() {
    return new ItemState();
  }
}

class ItemState extends State<ItemScreen> {
  int noOfSelectedItems = 0;
  List<Item> selectedItems = new List();
  AppBar appBar = getDefaultAppBar();

  static getDefaultAppBar() => ( new AppBar(title: new Text("Item"),)); 

  int onPress(bool selected, Item selectedItem) {
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
    for(Item item in selectedItems) {
      itemRef.child(item.key).remove();
      print("Removed " + item.key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemInheritedWidget(
      noOfSelectedItems : noOfSelectedItems,
      onPress : onPress,
      appBar : appBar,
      child : ItemListStateful(),
    );
  }
}

class ItemInheritedWidget extends InheritedWidget {

  ItemInheritedWidget({
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
  bool updateShouldNotify(ItemInheritedWidget old) => true;

  static ItemInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ItemInheritedWidget);
  }
}

/*
*   The child widgets
*/

class ItemListStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ItemList();
}

class ItemList extends State<ItemListStateful> {

  List<Item> items = new List();

  static getDefaultDrawer(context) => ( new DrawerNavigation().getDrawer(context));

  ItemList() {
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryEdited);
    itemRef.onChildRemoved.listen(_onEntryRemoved);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(new Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryEdited(Event event) {
    var oldValue = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(oldValue)] = new Item.fromSnapshot(event.snapshot);
    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      items.removeWhere((item) => item.key == event.snapshot.key);
    });
  }

  Future _openAddDialog() async {
    Item item = await Navigator.of(context).push(new MaterialPageRoute<Item>(
        builder: (BuildContext context) {
          return new ItemForm.add(new Item());
        },
        fullscreenDialog: true));

    if (item != null) {
      itemRef.push().set(item.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ItemInheritedWidget inheritedWidget = ItemInheritedWidget.of(context);
    Drawer drawer = ItemList.getDefaultDrawer(context);
    AppBar appBar = inheritedWidget.appBar;

    FloatingActionButton buttons;
    if(inheritedWidget.noOfSelectedItems == 0) {
      buttons = new FloatingActionButton(
        onPressed: () => _openAddDialog(),
        child: new Icon(Icons.add),
      );
    }

    Scaffold scaffold = new Scaffold(
          drawer: drawer,
          appBar: appBar,
          body: new ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                new ItemCardStateful(items[index]),
            itemCount: items.length,
          ),
          floatingActionButton: buttons,
        );

    return scaffold;
  }
}

class ItemCardStateful extends StatefulWidget {
  final Item item;
  ItemCardStateful(this.item);

  @override
  State<StatefulWidget> createState() {
    return new ItemCard(item);
  }
}

class ItemCard extends State<ItemCardStateful> {

  Item item;
  bool selected = false;
  ItemCard(this.item);

  void _onTap(BuildContext context) {
    final ItemInheritedWidget inheritedWidget = ItemInheritedWidget.of(context);
    if(inheritedWidget.noOfSelectedItems > 0) {
      this.selected = !this.selected;
      int selectedItems = inheritedWidget.onPress(this.selected, this.item);
      print("Tap " + selectedItems.toString());
    } else {
      _openEditDialog(context, this.item);
    }
  }

  void _onLongPress(BuildContext context) {
    final ItemInheritedWidget inheritedWidget = ItemInheritedWidget.of(context);
    this.selected = !this.selected;
    int selectedItems = inheritedWidget.onPress(this.selected, this.item);
    print("Long press " + selectedItems.toString());
  }

  void _openEditDialog(BuildContext context, Item item) {
    Navigator
        .of(context)
        .push(
          new MaterialPageRoute<Item>(
            builder: (BuildContext context) {
              return new ItemForm.edit(item);
            },
            fullscreenDialog: true,
          ),
        )
        .then((updatedItem) {
          if (updatedItem != null) {
            itemRef.child(item.key).set(updatedItem.toJson());
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    ListTile listTile = new ListTile(
      leading: const Icon(Icons.info),
      title: new Text(item.name),
      subtitle: new Text(item.description),
      trailing: new Text(item.dateTime.month.toString()),
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

