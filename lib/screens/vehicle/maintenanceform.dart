import 'package:flutter/material.dart';

import '../../model/VehicleMaintenance.dart';
import '../../model/MaintenanceItem.dart';
import '../../component/datetime.dart';
import 'maintenanceitemform.dart';

import 'dart:async';

class MaintenanceForm extends StatefulWidget {
  static String pageTitle = "Maintenance";
  final VehicleMaintenance item;

  MaintenanceForm.add(VehicleMaintenance item) : item = item;

  MaintenanceForm.edit(VehicleMaintenance existingItem) : item = existingItem;

  @override
  State<StatefulWidget> createState() {
    return new VehicleMaintenanceFormState(item);
  }
}

class VehicleMaintenanceFormState extends State<MaintenanceForm> {
  VehicleMaintenance _item;
  DateTime _serviceDate = new DateTime.now();
  TimeOfDay _serviceTime = const TimeOfDay(hour: 7, minute: 28);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  VehicleMaintenanceFormState(VehicleMaintenance item) {
    this._item = item;

    if (item.serviceDate != null) {
      _serviceDate = item.serviceDate;
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted(BuildContext context) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      VehicleMaintenance maintenance = new VehicleMaintenance.fromCode(_item.key, _item.name, _item.description, 
      _item.createdDate, _item.createdBy, _item.updatedDate, _item.updatedBy, _serviceDate, 
      _item.serviceLocation, _item.currentMileage, _item.nextServiceMileage, _item.maintenanceItems);

      Navigator.of(context).pop(maintenance);
      showInSnackBar('Added new item.');
    }
  }

  Future _onPressedAdd(BuildContext context) async {
    MaintenanceItem item = await Navigator.of(context).push(new MaterialPageRoute<MaintenanceItem>(
        builder: (BuildContext context) {
          return new MaintenanceItemForm.add(new MaintenanceItem());
        },
        fullscreenDialog: true)
    );

    if(item != null) {
      if(_item.maintenanceItems == null) {
        _item.maintenanceItems = [];
      }
      _item.maintenanceItems.add(item);         
    }
  }

    void _onTapMaintenance(context, MaintenanceItem item) {
    Navigator
        .of(context)
        .push(
          new MaterialPageRoute<MaintenanceItem>(
            builder: (BuildContext context) {
              return new MaintenanceItemForm.edit(item);
            },
            fullscreenDialog: true,
          ),
        )
        .then((updatedItem) {
          if (updatedItem != null) {
            item = updatedItem;
          }
    });
  }

  @override
  Widget build(BuildContext context) {

    print("Build maintenance form");

    Widget maintenanceHeader = new ListTile(
      title: new Text("Maintenance Information", style: TextStyle(fontSize: 24.0),),
    );

    Widget nameField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.name != null ? _item.name : '',
        decoration: new InputDecoration(
          hintText: "Name",
          labelText: "Name",
        ),
        onSaved: (val) => _item.name = val,
      ),
    );

    Widget descriptionField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.description != null ? _item.description : '',
        decoration: new InputDecoration(
          hintText: "Description",
          labelText: "Description",
        ),
        onSaved: (val) => _item.description = val,
      ),
    );

    Widget serviceDateField = new ListTile(
      leading: const Icon(Icons.calendar_today),
      title: new DateTimePicker(
        selectedDate: _serviceDate,
        selectedTime: _serviceTime,
        selectDate: (DateTime date) {
          setState(() {
            _serviceDate = date;
          });
        },
      ),
    );

    Widget serviceLocationField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.serviceLocation != null ? _item.serviceLocation : '',
        decoration: new InputDecoration(
          hintText: "Service Location",
          labelText: "Service Location",
        ),
        onSaved: (val) => _item.serviceLocation = val,
      ),
    );


    Widget currentMileageField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.currentMileage != null ? _item.currentMileage.toString() : '',
        decoration: new InputDecoration(
          hintText: "Current Mileage",
          labelText: "Current Mileage",
        ),
        onSaved: (val) {
          _item.currentMileage = double.parse(val != null ? val : "0");
        },
        keyboardType: TextInputType.number,
      ),
    );

    Widget nextServiceMileageField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.nextServiceMileage != null ? _item.nextServiceMileage.toString() : '',
        decoration: new InputDecoration(
          hintText: "Next Mileage",
          labelText: "Next Mileage",
        ),
        onSaved: (val) {
          _item.nextServiceMileage = double.parse(val != null ? val : "0");
        }, 
        keyboardType: TextInputType.number,
      ),
    );

    Widget divider = new Divider(height : 15.0, color: Colors.black,);

    Widget maintenanceItemHeader = new ListTile(
      title: new Text("Maintenance Item", style: TextStyle(fontSize: 24.0),),
      trailing: new RaisedButton(onPressed: () => _onPressedAdd(context), child: Icon(Icons.add), color: Colors.blue,),
    );

    List<Widget> children = <Widget>[];
    children.add(maintenanceHeader);
    children.add(nameField);
    children.add(descriptionField);
    children.add(serviceDateField);
    children.add(serviceLocationField);
    children.add(currentMileageField);
    children.add(nextServiceMileageField);
    children.add(divider);
    children.add(maintenanceItemHeader);

    List<MaintenanceItem> maintenances = _item.maintenanceItems;
    if(maintenances == null) {
      maintenances = new List<MaintenanceItem>();
    } 

    print("maintenances.length : " + maintenances.length.toString());

    for (var m in maintenances) {

      ListTile l = new ListTile(
        title: new Text(m.name),
        trailing: new Text("RM " + m.price.toStringAsFixed(2)),
        onTap: () => _onTapMaintenance(context, m),
      );
      children.add(l);
    }


    Widget body = new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        child: new ListView(
          children: children,
        ),
      ));

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Maintenance"),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _handleSubmitted(context);
                })
          ],
        ),
        body: body);
  }
}
