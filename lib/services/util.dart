import '../model/Item.dart';
import 'package:firebase_database/firebase_database.dart';

class Util {

  final DatabaseReference itemRef = FirebaseDatabase.instance.reference();

  addDummyDate() {
    final List<Item> items = <Item>[
      new Item.fromCode("Item 1", "Description 1", new DateTime.now(), 111.toDouble()),
      new Item.fromCode("Item 2", "Description 2", new DateTime.now(), 222.toDouble()),
      new Item.fromCode("Item 3", "Description 3", new DateTime.now(), 333.toDouble()),
    ];

    for (var item in items) {
      itemRef.child("item").push().set({
        'name': item.name,
        'description': item.description,
        'dateTime': item.dateTime.millisecondsSinceEpoch,
        'price': item.price,
      });
    }
  }





}