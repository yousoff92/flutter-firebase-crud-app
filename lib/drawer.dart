import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/item.dart';
import 'screens/vehicle.dart';
import 'screens/expenses.dart';

class DrawerNavigation extends StatelessWidget {

  UserAccountsDrawerHeader _header() {
    UserAccountsDrawerHeader drawerHeader = new UserAccountsDrawerHeader(
      accountEmail: new Text("yousoff92@gmail.com"),
      accountName: new Text("Yousoff Effendy"),
      currentAccountPicture: null,);
    return drawerHeader;
  }

   List<Widget> _items(context) {
    Divider divider = new Divider( height: 10.0,);
    List<Widget> items = new List();
    items.add(
      new ListTile(
        leading: const Icon(Icons.home),
        title: new Text(HomeScreen.pageTitle),
        onTap: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      )
    );
    items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.event_note),
        title: new Text(ItemScreen.pageTitle),
        onTap: () {
          Navigator.pushReplacementNamed(context, ItemScreen.routeName);
        },
      )
    );
    items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.directions_car),
        title: new Text(VehicleScreen.pageTitle),
        onTap: () {
          Navigator.pushReplacementNamed(context, VehicleScreen.routeName);
        },
      )
    );
        items.add(divider);
    items.add(
      new ListTile(
        leading: const Icon(Icons.attach_money),
        title: new Text(ExpensesScreen.pageTitle),
        onTap: () {
          Navigator.pushReplacementNamed(context, ExpensesScreen.routeName);
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

  @override
  Widget build(BuildContext context) {
    print("Drawer");
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
