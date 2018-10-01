import 'package:firebase_database/firebase_database.dart';

import 'package:intl/intl.dart';

class Solat {

  String key;
  DateTime dateTime;
  String hijri;
  String imsak;
  String subuh;
  String syuruk;
  String zohor;
  String asar;
  String maghrib;
  String isyak;
  String zone;

  Solat();

  Solat.fromCode(dateTime, hijri, imsak, subuh, syuruk, zohor, asar, maghrib, isyak, zone) :
    this.dateTime = dateTime,
    this.hijri = hijri,
    this.imsak = imsak,
    this.subuh = subuh,
    this.syuruk = syuruk,
    this.zohor = zohor,
    this.asar = asar,
    this.maghrib = maghrib,
    this.isyak = isyak,
    this.zone = zone;
 
  Solat.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value['dateTime']),
    this.hijri = snapshot.value['hijri'],
    this.imsak = snapshot.value['imsak'],
    this.subuh = snapshot.value['subuh'],
    this.syuruk = snapshot.value['syuruk'],
    this.zohor = snapshot.value['zohor'],
    this.asar = snapshot.value['asar'],
    this.maghrib = snapshot.value['maghrib'],
    this.isyak = snapshot.value['isyak'],
    this.zone = snapshot.value['zone'];

  toJson() {
    return {
      "dateTime" : dateTime.millisecondsSinceEpoch,
      "hijri" : hijri,
      "imsak" : imsak,
      "subuh" : subuh,
      "syuruk" : syuruk,
      "zohor" : zohor,
      "asar" : asar,
      "maghrib" : maghrib,
      "isyak" : isyak,
      "zone" : zone,
    };
  }

  Solat.fromRequestJson(Map<String, dynamic> json, String zone) {

    String mappedDate = _getMappedDate(json["date"]);
    dateTime = new DateFormat("dd-MMM-yyyy").parse(mappedDate);

    DateFormat parseDf = new DateFormat("HH:mm:ss");
    DateFormat formatDf = new DateFormat("h:mm a");

    this.hijri = json['hijri'];
    this.imsak = formatDf.format(parseDf.parse(json['imsak']));
    this.subuh = formatDf.format(parseDf.parse(json['fajr']));
    this.syuruk = formatDf.format(parseDf.parse(json['syuruk']));
    this.zohor = formatDf.format(parseDf.parse(json['dhuhr']));
    this.asar = formatDf.format(parseDf.parse(json['asr']));
    this.maghrib = formatDf.format(parseDf.parse(json['maghrib']));
    this.isyak = formatDf.format(parseDf.parse(json['isha']));
    this.zone = zone;
  }

  // Convert Malay to English month abbr
  String _getMappedDate(String date) {
    if(date.contains(new RegExp(r'Mac'))) {
      return date.replaceFirst(new RegExp(r'Mac'), "Mar");
    } else if(date.contains(new RegExp(r'Mei'))) {
      return date.replaceFirst(new RegExp(r'Mei'), "May");
    } else if(date.contains(new RegExp(r'Okt'))) {
      return date.replaceFirst(new RegExp(r'Okt'), "Oct");
    } else if(date.contains(new RegExp(r'Ogos'))) {
      return date.replaceFirst(new RegExp(r'Ogos'), "Aug");
    } else if(date.contains(new RegExp(r'Dis'))) {
      return date.replaceFirst(new RegExp(r'Dis'), "Dec");
    } else {
      return date;
    }
  }
}