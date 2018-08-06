import 'package:flutter/material.dart';
import 'dart:async';

import '../drawer.dart';
import '../model/Item.dart';
import '../screens/item/itemform.dart';

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference itemRef =
    FirebaseDatabase.instance.reference().child("item");

class ItemInheritedWidget extends InheritedWidget {
  final int noOfSelection;

  ItemInheritedWidget(key, child)
      : noOfSelection = 0,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ItemInheritedWidget old) =>
      old.noOfSelection != noOfSelection;

  static ItemInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ItemInheritedWidget);
  }
}

class ItemScreen extends StatefulWidget {
  static String pageTitle = "Item";
  static String routeName = "/item";

  @override
  State<StatefulWidget> createState() => new ItemScreenState();
}

class ItemScreenState extends State<ItemScreen> {
  List<Item> items = new List();

  int noOfSelected = 0;

  Scaffold scaffold;
  AppBar appBar;
  BuildContext buildContext;

  ItemScreenState() {
    // Listeners
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryEdited);

    print("Init");

    // Layout
    scaffold = _getDefaultScaffold(buildContext);
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

  int _onLongPressItem(bool selected, context) {
    setState(() {
      selected ? noOfSelected++ : noOfSelected--;

      if (this.noOfSelected > 0) {
        appBar = new AppBar(
          title: new Text("Selected item " + this.noOfSelected.toString()),
        );

        print("In");

        // AppBar appBar = new AppBar(
        //   title: new Text("Selected Item" + this.noOfSelected.toString()),
        //   actions: <Widget>[
        //     new IconButton(
        //     icon: new Icon(Icons.delete),
        //     tooltip: 'Delete',
        //     onPressed: _deleteItem,
        //   ),
        //   ],
        // );

        scaffold = new Scaffold(
          appBar: appBar,
          body: new ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                new ItemStateful(items[index], _onLongPressItem),
            itemCount: items.length,
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () => _openAddDialog(),
            child: new Icon(Icons.add),
          ),
        );
      } else {
        //appBar = _getDefaultAppBar();
        scaffold = _getDefaultScaffold(context);
      }
    });

    print("General selected " + this.noOfSelected.toString());
    return this.noOfSelected;
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

  _deleteItem() {
    print("Delete");
  }

  /*
    Layout
  */

  static getDefaultAppBar() {
    return new AppBar(
      title: new Text("Item"),
    );
  }

  static getDefaultDrawer(context) {
    return new DrawerNavigation().getDrawer(context);
  }

  _getDefaultScaffold(context) {
    if (context == null) {
      return null;
    }

    print("Default scaffold");

    Drawer drawer = getDefaultDrawer(context);
    appBar = getDefaultAppBar();

    return new Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new ItemStateful(items[index], _onLongPressItem),
        itemCount: items.length,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _openAddDialog(),
        child: new Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.buildContext = context;

    // if(scaffold == null) {
    //   scaffold = _getDefaultScaffold(context);
    // }

    Drawer drawer = ItemScreenState.getDefaultDrawer(context);
    appBar = ItemScreenState.getDefaultAppBar();

    Scaffold scaffold = new Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new ItemStateful(items[index], _onLongPressItem),
        itemCount: items.length,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _openAddDialog(),
        child: new Icon(Icons.add),
      ),
    );

    return scaffold;
  }
}

class ItemStateful extends StatefulWidget {
  final Item item;
  final dynamic _onLongPressItem;
  ItemStateful(this.item, this._onLongPressItem);

  @override
  State<StatefulWidget> createState() {
    return new ItemState(item, _onLongPressItem);
  }
}

class ItemState extends State<ItemStateful> {
  Item item;
  dynamic onLongPressItem;
  ItemState(this.item, this.onLongPressItem);

  bool selected = false;
  int noOfSelected = 0;

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
        itemRef.child(item.key).set((updatedItem as Item).toJson());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ListTile listTile = new ListTile(
      leading: const Icon(Icons.info),
      title: new Text(item.name),
      subtitle: new Text(item.description),
      trailing: new Text(item.dateTime.month.toString()),
      selected: selected,
      onTap: () => _onTap(context, item),
      onLongPress: () => _onLongPress(context),
    );

    return new Card(
      child: new Column(
          mainAxisSize: MainAxisSize.min, children: <Widget>[listTile]),
    );
  }

  /*  
    Actions
  */

  _onLongPress(context) {
    setState(() {
      this.selected = !this.selected;
      this.noOfSelected = onLongPressItem(selected, context);
      print(this.noOfSelected);
    });
  }

  _onTap(BuildContext context, Item item) {
      setState(() {
          this.selected = !this.selected;
      });
      print("onTap");
      print(this.noOfSelected);
  }
      // if(noOfSelected == 0 ) {
      //   _openEditDialog(context,item);
      // } else {

      // }
  

}
