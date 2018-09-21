import 'package:flutter/material.dart';
import 'package:quiver/strings.dart' as quiver;
import '../../model/expenses.dart';
import '../../constant/constant.dart';
import '../../component/datetime.dart';
import './../../services/authentication.dart';

class ExpensesForm extends StatefulWidget {
  static String pageTitle = "Expenses";
  final Expenses item;

  ExpensesForm.add(Expenses item) : item = item;

  ExpensesForm.edit(Expenses existingItem) : item = existingItem;

  @override
  State<StatefulWidget> createState() {
    return new ItemFormState(item);
  }
}

class ItemFormState extends State<ExpensesForm> {
  Expenses _item;
  DateTime _transactionDate = new DateTime.now();
  TimeOfDay _transactionTime = const TimeOfDay(hour: 0, minute: 0);
  List<DropdownMenuItem> _categories = [];
  String currentUsername;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    Authentication.getStaticCurrentUser().then((user) {
      if (user != null) {
        currentUsername = user.displayName;
        setState(() {});
      }
    });

    _categories.add(new DropdownMenuItem(
      child: new Text(Constant.CATEGORY_FOOD),
      value: Constant.CATEGORY_FOOD,
    ));
    _categories.add(new DropdownMenuItem(
      child: new Text(Constant.CATEGORY_HOME),
      value: Constant.CATEGORY_HOME,
    ));
    _categories.add(new DropdownMenuItem(
      child: new Text(Constant.CATEGORY_TRAVEL),
      value: Constant.CATEGORY_TRAVEL,
    ));
    _categories.add(new DropdownMenuItem(
      child: new Text(Constant.CATEGORY_ENTERTAINMENT),
      value: Constant.CATEGORY_ENTERTAINMENT,
    ));
    _categories.add(new DropdownMenuItem(
      child: new Text(Constant.CATEGORY_OTHER),
      value: Constant.CATEGORY_OTHER,
    ));
  }

  ItemFormState(Expenses item) {
    this._item = item;

    if (item.transactionDate != null) {
      _transactionDate = item.transactionDate;
    } else {
      item.transactionDate = _transactionDate;
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
      Navigator.of(context).pop(new Expenses.fromCode(
          _item.key,
          _item.name,
          _item.description,
          _item.createdDate,
          _item.createdBy,
          _item.updatedDate,
          _item.updatedBy,
          _item.category,
          _item.price,
          _item.location,
          _item.transactionDate,
          _item.transactionBy));
      showInSnackBar('Added new item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("[ExpensesForm] Start build..");
    final Widget nameField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.name != null ? _item.name : '',
        decoration: new InputDecoration(
          labelText: "Name",
        ),
        onSaved: (val) => _item.name = val,
      ),
    );

    final Widget descriptionField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.description != null ? _item.description : '',
        decoration: new InputDecoration(
          labelText: "Description",
        ),
        onSaved: (val) => _item.description = val,
      ),
    );

    final Widget categoryField = new ListTile(
      leading: const Icon(Icons.info),
      title: new DropdownButton(
          hint: new Text("Category"),
          items: _categories,
          value: _item.category,
          onChanged: (val) {
            _item.category = val;
            setState(() {});
          }),
    );

    final Widget priceField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.price != null ? _item.price.toString() : '',
        decoration: new InputDecoration(
          labelText: "Price",
          prefixText: "RM ",
        ),
        onSaved: (val) {
          _item.price = double.parse(!quiver.isBlank(val) ? val : "0.0");
        },
        keyboardType: TextInputType.number,
      ),
    );

    final Widget locationField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        initialValue: _item.location != null ? _item.location : '',
        decoration: new InputDecoration(
          labelText: "Buy Location",
        ),
        onSaved: (val) => _item.location = val,
      ),
    );

    final Widget transactionDateField = new ListTile(
      leading: const Icon(Icons.calendar_today),
      title: new DateTimePicker(
        selectedDate: _transactionDate,
        selectedTime: _transactionTime,
        onlyFutureDate: true,
        selectDate: (DateTime date) {
          _transactionDate = date;
          _item.transactionDate = date;
          setState(() {});
        },
        labelText: "Transaction Date",
      ),
    );

    final Widget transactionByField = new ListTile(
      leading: const Icon(Icons.info),
      title: new TextFormField(
        controller: new TextEditingController(
            text: _item.transactionBy ?? (currentUsername ?? 'aaa')),
        decoration: new InputDecoration(
          labelText: "Transaction By",
        ),
        onSaved: (val) => _item.transactionBy = val,
      ),
    );

    List<Widget> children = <Widget>[];
    children.add(nameField);
    children.add(descriptionField);
    children.add(categoryField);
    children.add(priceField);
    children.add(locationField);
    children.add(transactionDateField);
    children.add(transactionByField);

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
          title: new Text("Expenses"),
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
