import 'package:flutter/material.dart';

import '../../model/Vehicle.dart';
import '../../model/VehicleMaintenance.dart';
import 'maintenanceform.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class VehicleForm extends StatefulWidget {
  static String pageTitle = "Vehicle";
  final Vehicle item;

  VehicleForm.add(Vehicle item) : item = item;

  VehicleForm.edit(Vehicle existingItem) : item = existingItem;

  @override
  State<StatefulWidget> createState() {
    return new VehicleFormState(item);
  }
}

class VehicleFormState extends State<VehicleForm> {
  Vehicle _item;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  VehicleFormState(Vehicle item) {
    this._item = item;
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

      if(_item.createdDate != null) {
        _item.updatedDate = new DateTime.now();
        _item.updatedBy = "user";
      } else {
        _item.createdDate = new DateTime.now();
        _item.createdBy = "user";
      }

      Vehicle item = Vehicle.fromCode(_item.key, _item.name, _item.description, _item.createdDate, _item.createdBy, _item.updatedDate, _item.updatedBy, 
        _item.year, _item.monthlyInsurance, _item.image, _item.mileage, _item.vehicleMaintenances);

      Navigator.of(context).pop(item);
      showInSnackBar('Added new item.');
    }
  }

  Future _onPressedAdd(BuildContext context) async {
    VehicleMaintenance item = await Navigator.of(context).push(new MaterialPageRoute<VehicleMaintenance>(
        builder: (BuildContext context) {
          return new MaintenanceForm.add(new VehicleMaintenance());
        },
        fullscreenDialog: true)
    );

    if(item != null) {
      if(_item.vehicleMaintenances == null) {
        _item.vehicleMaintenances = [];
      }
      _item.vehicleMaintenances.add(item);         
    }
  }

  void _onTapMaintenance(context, VehicleMaintenance item) {
    Navigator
        .of(context)
        .push(
          new MaterialPageRoute<VehicleMaintenance>(
            builder: (BuildContext context) {
              return new MaintenanceForm.edit(item);
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
    print("Rebuild vehicleForm.dart");

    Widget vehicleHeader = new ListTile(
      title: new Text("Vehicle Information", style: TextStyle(fontSize: 24.0),),
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

    Widget yearField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.year != null ? _item.year : '',
        decoration: new InputDecoration(
          hintText: "Year",
          labelText : "Year",
        ),
        onSaved: (val) => _item.year = val,
      ),
    );

    Widget monthlyInsuranceField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.monthlyInsurance != null ? _item.monthlyInsurance.toString() : '',
        decoration: new InputDecoration(
          hintText: "Monthly Insurance",
          labelText : "Monthly Insurance",
        ),
        onSaved: (val) {

          dynamic newVal = int.tryParse(val);
          if(newVal == null) {
            newVal = double.tryParse(val);
          }
          _item.monthlyInsurance =  newVal;
        }, 
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );

    Widget imageField = null;

    Widget mileageField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.mileage != null ? _item.mileage.toString() : '',
        decoration: new InputDecoration(
          hintText: "Mileage",
          labelText : "Mileage",
        ),
        onSaved: (val) => _item.mileage = double.parse(val),
        keyboardType: TextInputType.number,
      ),
    );

    Widget divider = new Divider(height : 15.0, color: Colors.black,);

    Widget maintenanceHeader = new ListTile(
      title: new Text("Maintenance", style: TextStyle(fontSize: 24.0),),
      trailing: new RaisedButton(onPressed: () => _onPressedAdd(context), child: Icon(Icons.add), color: Colors.blue,),
    );

    List<VehicleMaintenance> maintenances = _item.vehicleMaintenances;
    if(maintenances == null) {
      maintenances = new List<VehicleMaintenance>();
    } 

    print("maintenances.length : " + maintenances.length.toString());

    List<Widget> children = <Widget>[];
    children.add(vehicleHeader);
    children.add(nameField);
    children.add(descriptionField);
    children.add(yearField);
    children.add(monthlyInsuranceField);
    children.add(mileageField);
    children.add(divider);
    children.add(maintenanceHeader);

    for (var m in maintenances) {

      String leading = "";

      if(m.serviceDate != null) {
        String monthDay = new DateFormat("MMM d").format(m.serviceDate);
        String year = new DateFormat("yyyy").format(m.serviceDate);
        leading = monthDay + "\n" + year;
      }

      Text text = new Text(leading, softWrap: true, 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, ),
        textAlign: TextAlign.center);

      ListTile l = new ListTile(
        leading: text,
        title: new Text(m.name),
        onTap: () => _onTapMaintenance(context, m),
      );
      children.add(l);
    }

    var body = new SafeArea(
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
          title: new Text("Vehicle"),
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
