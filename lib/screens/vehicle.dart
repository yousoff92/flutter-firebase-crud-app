import 'package:flutter/material.dart';
import 'dart:async';

import '../drawer.dart';
import '../model/Vehicle.dart';
import '../model/VehicleMaintenance.dart';
import '../model/MaintenanceItem.dart';
import '../screens/vehicle/vehicleform.dart';

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference vehicleRef =
    FirebaseDatabase.instance.reference().child("vehicle");

/*
*   Parent widget
*/

class VehicleScreen extends StatefulWidget {
  static String pageTitle = "Vehicle";
  static String routeName = "/vehicle";

  @override
  State<StatefulWidget> createState() {
    return new VehicleState();
  }
}

class VehicleState extends State<VehicleScreen> {
  int noOfSelectedItems = 0;
  List<Vehicle> selectedItems = new List();
  AppBar appBar = getDefaultAppBar();

  static getDefaultAppBar() => ( new AppBar(title: new Text("Vehicle"),)); 

  int onPress(bool selected, Vehicle selectedItem) {
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
        title: new Text("Selected Vehicle " + this.noOfSelectedItems.toString()),
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
    for(Vehicle item in selectedItems) {
      vehicleRef.child(item.key).remove();
      print("Removed " + item.key);
    }
    noOfSelectedItems = 0;
  }

  @override
  Widget build(BuildContext context) {
    return VehicleInheritedWidget(
      noOfSelectedItems : noOfSelectedItems,
      onPress : onPress,
      appBar : appBar,
      child : VehicleListStateful(),
    );
  }
}

class VehicleInheritedWidget extends InheritedWidget {

  VehicleInheritedWidget({
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
  bool updateShouldNotify(VehicleInheritedWidget old) => true;

  static VehicleInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(VehicleInheritedWidget);
  }
}

/*
*   The child widgets
*/

class VehicleListStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new VehicleList();
}

class VehicleList extends State<VehicleListStateful> {

  List<Vehicle> items = new List();

  static getDefaultDrawer(context) => ( new DrawerNavigation().getDrawer(context));

  VehicleList() {
    vehicleRef.onChildAdded.listen(_onEntryAdded);
    vehicleRef.onChildChanged.listen(_onEntryEdited);
    vehicleRef.onChildRemoved.listen(_onEntryRemoved);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(new Vehicle.fromSnapshot(event.snapshot));
    });
  }

  _onEntryEdited(Event event) {
    var oldValue = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(oldValue)] = new Vehicle.fromSnapshot(event.snapshot);
    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      items.removeWhere((item) => item.key == event.snapshot.key);
    });
  }

  Future _openAddDialog() async {
    Vehicle item = await Navigator.of(context).push(new MaterialPageRoute<Vehicle>(
        builder: (BuildContext context) {
          return new VehicleForm.add(new Vehicle());
        },
        fullscreenDialog: true));

    if (item != null) {
      DatabaseReference newRef = vehicleRef.push();
      newRef.set(item.toJson());

      if(item.vehicleMaintenances != null) {
        DatabaseReference maintenanceRef = vehicleRef.child(newRef.key).child("vehicleMaintenances").push();
        for (VehicleMaintenance item in item.vehicleMaintenances) {
          maintenanceRef.set(item.toJson());

          if(item.maintenanceItems != null) {
            DatabaseReference itemRef = maintenanceRef.child(maintenanceRef.key).child("maintenanceItems").push();
            for(MaintenanceItem maintenance in item.maintenanceItems) {
                itemRef.set(maintenance.toJson());
            }
          }

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final VehicleInheritedWidget inheritedWidget = VehicleInheritedWidget.of(context);
    Drawer drawer = VehicleList.getDefaultDrawer(context);
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
                new VehicleCardStateful(items[index]),
            itemCount: items.length,
          ),
          floatingActionButton: buttons,
        );

    return scaffold;
  }
}

class VehicleCardStateful extends StatefulWidget {
  final Vehicle item;
  VehicleCardStateful(this.item);

  @override
  State<StatefulWidget> createState() {
    return new VehicleCard(item);
  }
}

class VehicleCard extends State<VehicleCardStateful> {

  Vehicle item;
  bool selected = false;
  VehicleCard(this.item);

  void _onTap(BuildContext context) {
    final VehicleInheritedWidget inheritedWidget = VehicleInheritedWidget.of(context);
    if(inheritedWidget.noOfSelectedItems > 0) {
      this.selected = !this.selected;
      int selectedItems = inheritedWidget.onPress(this.selected, this.item);
      print("Tap " + selectedItems.toString());
    } else {
      _openEditDialog(context, this.item);
    }
  }

  void _onLongPress(BuildContext context) {
    final VehicleInheritedWidget inheritedWidget = VehicleInheritedWidget.of(context);
    this.selected = !this.selected;
    int selectedItems = inheritedWidget.onPress(this.selected, this.item);
    print("Long press " + selectedItems.toString());
  }

  void _openEditDialog(BuildContext context, Vehicle item) {
    Navigator
        .of(context)
        .push(
          new MaterialPageRoute<Vehicle>(
            builder: (BuildContext context) {
              return new VehicleForm.edit(item);
            },
            fullscreenDialog: true,
          ),
        )
        .then((updatedItem) {
          if (updatedItem != null) {

            Map s = updatedItem.toJson();
            print("S : " + s.toString());
            vehicleRef.child(updatedItem.key).update(s);

            if(updatedItem.vehicleMaintenances != null) {
              DatabaseReference maintenanceRef = vehicleRef.child(updatedItem.key).child("vehicleMaintenances");
              for (VehicleMaintenance vehicleMaintenance in updatedItem.vehicleMaintenances) {

                DatabaseReference newMaintRef;

                if(vehicleMaintenance.key != null) {
                  newMaintRef = maintenanceRef.child(vehicleMaintenance.key);
                  newMaintRef.update(vehicleMaintenance.toJson());
                } else {
                  newMaintRef = maintenanceRef.push();
                  newMaintRef.set(vehicleMaintenance.toJson());
                }

                if(vehicleMaintenance.maintenanceItems != null) {
                  DatabaseReference itemRef = newMaintRef.child("maintenanceItems");
                  for(MaintenanceItem maintenance in vehicleMaintenance.maintenanceItems) {
                    if(maintenance.key != null) {
                      itemRef.child(maintenance.key).update(maintenance.toJson());
                    } else {
                      itemRef.push().set(maintenance.toJson());
                    }

                  }
                }

              }
            }
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    ListTile listTile = new ListTile(
      leading: const Icon(Icons.info),
      title: new Text(item.name),
      subtitle: new Text(item.description),
      trailing: new Text(item.mileage.toString()),
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

