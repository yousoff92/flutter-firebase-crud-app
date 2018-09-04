import 'package:flutter/material.dart';

import '../../model/MaintenanceItem.dart';


class MaintenanceItemForm extends StatefulWidget {
  static String pageTitle = "Maintenance Item";
  final MaintenanceItem item;

  MaintenanceItemForm.add(MaintenanceItem item) : item = item;

  MaintenanceItemForm.edit(MaintenanceItem existingItem) : item = existingItem;

  @override
  State<StatefulWidget> createState() {
    return new MaintenanceItemFormState(item);
  }
}

class MaintenanceItemFormState extends State<MaintenanceItemForm> {
  MaintenanceItem _item;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  MaintenanceItemFormState(MaintenanceItem item) {
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

      MaintenanceItem maintenance = new MaintenanceItem.fromCode(_item.key, _item.name, _item.description, 
      _item.createdDate, _item.createdBy, _item.updatedDate, _item.updatedBy, _item.price);

      Navigator.of(context).pop(maintenance);
      showInSnackBar('Added new item.');
    }
  }

  @override
  Widget build(BuildContext context) {

    print("Build item form");

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



    Widget priceField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue:
            _item.price != null ? _item.price.toString() : '',
        decoration: new InputDecoration(
          hintText: "Price",
          labelText: "Price",
          prefixText: "RM ",
        ),
        onSaved: (val) {
          _item.price = double.parse(val != null ? val : "0");
        },
        keyboardType: TextInputType.number,
      ),
    );

    Widget body = new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            nameField,
            descriptionField,
            priceField,
          ],
        ),
      ));

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Maintenance Item"),
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
