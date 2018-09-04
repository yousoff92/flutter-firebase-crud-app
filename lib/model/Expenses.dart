
import 'Common.dart';
import 'package:firebase_database/firebase_database.dart';

class Expenses extends Common {

  String category;
  num price;
  String location;
  DateTime transactionDate;
  String transactionBy;

Expenses();

Expenses.fromCode(key, name, description, createdDate, createdBy, updatedDate,
      updatedBy, category, price, location, transactionDate, transactionBy)
      : this.category = category,
        this.price = price,
        this.location = location,
        this.transactionDate = transactionDate,
        this.transactionBy = transactionBy,
        super.fromCode(
            key, name, description, createdDate, createdBy, updatedDate, updatedBy);

Expenses.fromSnapshot(DataSnapshot snapshot)
  : category = snapshot.value['category'],
    price = snapshot.value['price'],
    location = snapshot.value['location'],
    transactionDate = snapshot.value['transactionDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            snapshot.value['transactionDate']) : null,
    transactionBy = snapshot.value['transactionBy'],
    super.fromSnapshot(snapshot);

@override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['category'] = category;
    json['price'] = price;
    json['location'] = location;
    json['transactionDate'] = transactionDate != null ? transactionDate.millisecondsSinceEpoch : null;
    json['transactionBy'] = transactionBy;
    return json;
  }

}