
import 'package:flutter/material.dart';

import '../drawer.dart';
import '../util/settings.dart';
import '../constant/constant.dart';

class SettingsScreen extends StatefulWidget {
  static String pageTitle = "Settings";
  static String routeName = "/settings";

  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<SettingsScreen> {
//Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _initSolat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Start - Waktu Solat

  String _zoneWaktuSolat;

  _initSolat() {
    Settings.getSettings("zoneWaktuSolat", null).then((val) {
      _zoneWaktuSolat = val;
      setState(() {});
    });
  }

  void _onChangedWaktuSolat(val) {
    Settings.setSettings("zoneWaktuSolat", val).then((isSuccess) {
      _zoneWaktuSolat = val;
      setState(() {});
    });
  }

  Widget _buildSolatDropdown() {
    //  String val = await _zoneWaktuSolatFuture;
    String val = _zoneWaktuSolat;
    List<DropdownMenuItem> categories = [];
    categories.add(new DropdownMenuItem(
      child: new Text("Please select solat timezone"),
      value: null,
    ));

    Constant.getZonSolat().forEach((code, label) {
      categories.add(new DropdownMenuItem(
        //child : new Expanded(child: new Column(children: <Widget>[new Text(label),],)),
        child: new Container(
          width: 300.0,
          child: new Text(
          label,
          overflow: TextOverflow.ellipsis,
        )
        )  ,
        value: code,
      ));
    });
    return new Column(
      children: <Widget>[
        new Container(
            decoration: new BoxDecoration(
              color: Colors.grey[300],
            ),
            child: new ListTile(title: new Text("Solat"))),
        new ListTile(
          title: new DropdownButton(
            items: categories,
            value: val,
            isDense: true,
            onChanged: (val) {
              _onChangedWaktuSolat(val);
            },
          ),
        )
      ],
    );
  }

  Widget _buildSolatSettings() {
    return _buildSolatDropdown();
  }

  // End - Waktu solat

  @override
  Widget build(BuildContext context) {
    debugPrint("[SettingsState] Start build..");
    List<Widget> widgets = new List();
    widgets.add(_buildSolatSettings());

    return new Scaffold(
        drawer: new DrawerNavigation(),
        appBar: new AppBar(
          title: new Text("Settings"),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return widgets[index];
          },
          itemCount: widgets.length,
        ));
  }
}
