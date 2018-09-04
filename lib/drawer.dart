import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/item.dart';
import 'screens/vehicle.dart';
import 'screens/expenses.dart';

class DrawerNavigation {

  UserAccountsDrawerHeader _header() {

  

    UserAccountsDrawerHeader drawerHeader = new UserAccountsDrawerHeader(
      accountEmail: new Text("yousoff92@gmail.com"),
      accountName: new Text("Yousoff Effendy"),
      currentAccountPicture: null,);


    // DrawerHeader drawerHeader = new DrawerHeader(
    //   child: null,
    //   decoration: new FlutterLogoDecoration(
    //     style: FlutterLogoStyle.horizontal
    //   )
    // );
    return drawerHeader;
  }

  Divider divider = new Divider( height: 10.0,);
  

  // TODO - Prevent navigation from stacks

  List<Widget> _items(context) {
    List<Widget> items = new List();
    items.add(
      new ListTile(
        leading: const Icon(Icons.home),
        title: new Text(HomeScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
      )
    );
    items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.event_note),
        title: new Text(ItemScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, ItemScreen.routeName);
        },
      )
    );
    items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.directions_car),
        title: new Text(VehicleScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, VehicleScreen.routeName);
        },
      )
    );
        items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.attach_money),
        title: new Text(ExpensesScreen.pageTitle),
        onTap: () {
          Navigator.pushNamed(context, ExpensesScreen.routeName);
        },
      )
    );
    items.add(divider);
    items.add(
      new AboutListTile(
        applicationName: "Management App",
        applicationVersion: "0.1",
      )
    );
    items.add(divider);
    return items;
  }

  Drawer getDrawer(context) {
    List<Widget> navigations = [];
    navigations.add(_header());

    for (Widget item in _items(context)) {
      navigations.add(item);
    }

    ListView listView = new ListView(children: navigations, padding: EdgeInsets.zero,);
    Drawer drawer = new Drawer(child: listView, );
    return drawer;
  }

}