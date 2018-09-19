import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

import '../drawer.dart';
import '../model/solat.dart';
import '../constant/constant.dart';
import '../util/common.dart';
import '../util/settings.dart';


final DatabaseReference itemRef =
    FirebaseDatabase.instance.reference().child("personal");
final DatabaseReference solatRef =
    FirebaseDatabase.instance.reference().child("solat");

/*
*   Parent widget
*/

// load data based on current user
class PersonalScreen extends StatefulWidget {
  static String pageTitle = "Personal";
  static String routeName = "/personal";

  @override
  State<StatefulWidget> createState() {
    return new PersonalState();
  }
}

class PersonalState extends State<PersonalScreen> {

  @override
  void initState() {
    super.initState();
    _initSolat();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeSolat();
  }

  // Start License
  Widget _buildMotorcyleLicense() {
    return new Card(
        child: new Column(children: <Widget>[
      new ListTile(
        title: new Text(
          "Motorcycle License",
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: new Text("Valid period : Until 15 January 2019"),
      ),
    ]));
  }

  Widget _buildDrivingLicense() {
    return new Card(
        child: new Column(children: <Widget>[
      new ListTile(
        title: new Text(
          "Driving License",
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: new Text("Valid period : 7 August 2017 - 5 August 2022"),
      ),
    ]));
  }
  // End License

  // Start Solat
  List<Solat> waktuSolatList = new List();
  num triggerInsertion = 0;

  String _zoneWaktuSolat;

  StreamSubscription onChildAddSolat;
  StreamSubscription onChildChangedSolat;
  StreamSubscription onChildRemovedSolat;

  void _initSolat() {
    Settings.getSettings("zoneWaktuSolat", null).then((val) {
      setState(() {
        _zoneWaktuSolat = val;
      });
    });
    onChildAddSolat = solatRef.onChildAdded.listen((event) {
      setState(() {
        waktuSolatList.add(new Solat.fromSnapshot(event.snapshot));
      });
    });
    onChildChangedSolat = solatRef.onChildChanged.listen((event) {
      var oldValue = waktuSolatList.singleWhere((entry) {
        return entry.key == event.snapshot.key;
      });
      setState(() {
        waktuSolatList[waktuSolatList.indexOf(oldValue)] =
            new Solat.fromSnapshot(event.snapshot);
      });
    });
    onChildRemovedSolat = solatRef.onChildRemoved.listen((event) {
      setState(() {
        waktuSolatList.removeWhere((item) => item.key == event.snapshot.key);
      });
    });
  }

  void _disposeSolat() {
    onChildAddSolat.cancel();
    onChildChangedSolat.cancel();
    onChildRemovedSolat.cancel();
  }

  void _preBuildSolat() async {
   // check ada internet connection || data dah ada
    bool isRequireRequestJson = true;
    DateTime today = DateTime.now();

    var connectivityResult = await (new Connectivity().checkConnectivity());
    
    String zone = _zoneWaktuSolat;
    if(connectivityResult == ConnectivityResult.none || zone == null|| triggerInsertion == 0) {
      isRequireRequestJson = false;
      triggerInsertion++;
    } else {
      for (Solat solat in waktuSolatList) {
        if (solat.dateTime.month == today.month &&
            solat.dateTime.year == today.year && zone == solat.zone) {
              isRequireRequestJson = false;
              break;
        }
      }
    }

    if(isRequireRequestJson) {
      debugPrint("[PersonalState] Requesting new solat json for zone $zone");
      String url = Constant.ESOLAT_WEEK_URL + "&zone=" + zone;
      
      try {
        
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close(); 

        // transforms and prints the response
        waktuSolatList.clear();
        await for (var contents in response.transform(Utf8Decoder())) {
          Map<String, dynamic> j = json.decode(contents);
          List<dynamic> l = j["prayerTime"];

          for (var item in l) {
            waktuSolatList.add(Solat.fromRequestJson(item, zone));
          }
        }

        debugPrint("[PersonalState] Inserting new json into Firebase");
        solatRef.remove();
        for (Solat item in waktuSolatList) {
          solatRef.push().set(item.toJson());
        }
      } catch (e) {
        print(e.toString());
      }

    }
  }

  Widget _buildSolat() {
    _preBuildSolat();
    DateTime today = DateTime.now();

    Solat s = waktuSolatList.firstWhere((solat) {
      return (solat.dateTime.month == today.month &&
          solat.dateTime.year == today.year);
    }, orElse: () => null);

    if(s != null) {

      TableRow r1 = new TableRow(
        children: <Widget>[new Text("Imsak"), new Text(s.imsak)]
      );
      TableRow r2 = new TableRow(
        children: <Widget>[new Text("Subuh"), new Text(s.subuh)]
      );
      TableRow r3 = new TableRow(
        children: <Widget>[new Text("Syuruk"),new Text(s.syuruk)]
      );
      TableRow r4 = new TableRow(
        children: <Widget>[new Text("Zohor"),new Text(s.zohor)]
      );
      TableRow r5 = new TableRow(
        children: <Widget>[new Text("Asar"),new Text(s.asar)]
      );
      TableRow r6 = new TableRow(
        children: <Widget>[new Text("Maghrib"),new Text(s.maghrib)]
      );
      TableRow r7 = new TableRow(
        children: <Widget>[new Text("Isyak"),new Text(s.isyak)]
      );

      List<TableRow> trList = <TableRow>[r1,r2,r3,r4,r5,r6,r7];
      Table table = new Table(
        children: trList,
      );

      DateTime hijriDate = new DateFormat("yyyy-MM-dd").parse(s.hijri);
      String hijriStr = hijriDate.day.toString() + " " + CommonUtil.getHijrahMonth(hijriDate.month) + " " + hijriDate.year.toString();

      return new Card(
        child: new Column(children: <Widget>[
          new ListTile(
            title: new Text("Solat",style: TextStyle(fontSize: 20.0),), 
            subtitle: new Text("Zone :  " + Constant.getZonSolat()[s.zone] + "\n" + new DateFormat("dd MMMM yyyy").format(s.dateTime) + " | " + hijriStr )
          ),
          new ListTile(title: table)
        ])
      );
    }
    return null;
  
  }

  // End solat


  @override
  Widget build(BuildContext context) {
    debugPrint("[PersonalState] Start build..");

    List<Widget> widgets = new List();
    widgets.add(_buildMotorcyleLicense());
    widgets.add(_buildDrivingLicense());

    Widget solatWidget = _buildSolat();
    if(solatWidget != null) {
      widgets.add(solatWidget);
    }

    return new Scaffold(
        drawer: new DrawerNavigation(),
        appBar: new AppBar(
          title: new Text("Personal"),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return widgets[index];
          },
          itemCount: widgets.length,
        ));
  }

}

