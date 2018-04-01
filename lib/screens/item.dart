import 'package:flutter/material.dart';
import 'dart:async';

import '../drawer.dart';
import '../model/Item.dart';
import '../screens/item/itemform.dart';

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference itemRef =
    FirebaseDatabase.instance.reference().child("item");

class ItemScreen extends StatefulWidget {
  static String pageTitle = "Item";
  static String routeName = "/item";

  @override
  State<StatefulWidget> createState() => new ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  List<Item> items = new List();

  ItemScreenState() {
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryEdited);
  }

  /*
    Listeners
  */

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

  /*
    Add, Edit
  */

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
    Drawer drawer = new DrawerNavigation().getDrawer(context);

    return new Scaffold(
      drawer: drawer,
      appBar: new AppBar(
        title: new Text("Item"),
      ),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new ItemState(items[index]),
        itemCount: items.length,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _openAddDialog(),
        child: new Icon(Icons.add),
      ),
    );
  }
}

class ItemState extends StatelessWidget {
  final Item item;
  ItemState(this.item);

  _openEditDialog(BuildContext context, Item item) {
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
        itemRef.child(item.key).set( (updatedItem as Item).toJson());
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
          onTap: () => _openEditDialog(context, item),
        );

    return new Card(
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        listTile
      ]),
    );
  }
}
