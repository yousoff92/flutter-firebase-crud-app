import 'package:firebase_database/firebase_database.dart';

class Item {

  String key;
  String name;
  String description;
  DateTime dateTime;
  double price;

  Item();

  Item.fromCode(name, description, dateTime, price) :
    this.name = name,
    this.description = description,
    this.dateTime = dateTime,
    this.price = price;
 
  Item.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    name = snapshot.value['name'],
    description = snapshot.value['description'],
    dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value['dateTime']),
    price = snapshot.value['price'].toDouble();

  toJson() {
    return {
      "name" : name,
      "description" : description,
      "dateTime" : dateTime.millisecondsSinceEpoch,
      "price": price,
    };
  }

}