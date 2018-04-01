import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/item.dart';

class DrawerNavigation {

  DrawerHeader _header() {
    DrawerHeader drawerHeader = new DrawerHeader(
      child: null,
      decoration: new FlutterLogoDecoration(
        style: FlutterLogoStyle.horizontal
      )
    );
    return drawerHeader;
  }

  List<Widget> _items(context) {
    List<Widget> items = new List();
    items.add(
      new ListTile(
        leading: const Icon(Icons.event_seat),
        title: new Text(HomeScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
      )
    );
    items.add(
      new ListTile(
        leading: const Icon(Icons.event_seat),
        title: new Text(ItemScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, ItemScreen.routeName);
        },
      )
    );
    items.add(
      new AboutListTile(
        applicationName: "Flutter Firebase CRUD App",
        applicationVersion: "0.1",
      )
    );
    return items;
  }

  Drawer getDrawer(context) {
    
    var navigations = [];
    navigations.add(_header());

    for (Widget item in _items(context)) {
      navigations.add(item);
    }

    ListView listView = new ListView(children: navigations,);
    Drawer drawer = new Drawer(child: listView,);
    return drawer;
  }

}