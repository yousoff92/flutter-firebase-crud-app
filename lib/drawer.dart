import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'screens/home.dart';
import 'screens/vehicle.dart';
import 'screens/expenses.dart';
import 'screens/personal.dart';
import 'screens/settings.dart';
import 'services/authentication.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DrawerNavigationState();
  }
}

class DrawerNavigationState extends State<DrawerNavigation> {
  
  final Authentication auth = new Authentication();

  Widget _header() {

    Container container = new Container(
      child: FutureBuilder<FirebaseUser>(
        future: auth.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseUser user = snapshot.data;
            if(user == null) {
              return new UserAccountsDrawerHeader(
                accountEmail: new Text("Sign in using Google"),
                accountName: new Text(""),
                onDetailsPressed: () {
                  auth.signInGoogle().whenComplete(() {
                    setState(() {});
                  }); 
                } ,
              );
            } 

            return new UserAccountsDrawerHeader(
                accountEmail: new Text(user.email),
                accountName: new Text(user.displayName),
                onDetailsPressed: () {
                  auth.signOutGoogle().whenComplete(() {
                    setState(() {});
                  }); 
                },
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/teal-material-design.png'),
                    fit: BoxFit.cover,

                  ),
                ),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ));
          } else {
            return new Container();
          }
        },
      ),
    );
    return container;
  }

  List<Widget> _items(context) {
    Divider divider = new Divider(
      height: 10.0,
    );
    List<Widget> items = new List();
    items.add(new ListTile(
      leading: const Icon(Icons.home),
      title: new Text(HomeScreen.pageTitle),
      onTap: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      },
    ));
    items.add(new ListTile(
      leading: const Icon(Icons.person),
      title: new Text(PersonalScreen.pageTitle),
      onTap: () {
        Navigator.pushReplacementNamed(context, PersonalScreen.routeName);
      },
    ));
    items.add(new ListTile(
      leading: const Icon(Icons.directions_car),
      title: new Text(VehicleScreen.pageTitle),
      onTap: () {
        Navigator.pushReplacementNamed(context, VehicleScreen.routeName);
      },
    ));
    items.add(new ListTile(
      leading: const Icon(Icons.attach_money),
      title: new Text(ExpensesScreen.pageTitle),
      onTap: () {
        Navigator.pushReplacementNamed(context, ExpensesScreen.routeName);
      },
    ));
    items.add(divider);
    items.add(new ListTile(
      leading: const Icon(Icons.settings),
      title: new Text(SettingsScreen.pageTitle),
      onTap: () {
        Navigator.pushReplacementNamed(context, SettingsScreen.routeName);
      },
    ));
    items.add(new AboutListTile(
      applicationName: "Management App",
      applicationVersion: "0.1",
      icon: const Icon(Icons.info),
    ));
    items.add(divider);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("[DrawerNavigation] Start build..");
    List<Widget> navigations = [];
    navigations.add(_header());

    for (Widget item in _items(context)) {
      navigations.add(item);
    }

    ListView listView = new ListView(
      children: navigations,
      padding: EdgeInsets.zero,
    );
    Drawer drawer = new Drawer(
      child: listView,
    );
    return drawer;
  }

}
