import 'Common.dart';
import 'package:firebase_database/firebase_database.dart';

class MaintenanceItem extends Common {
  num price;

  MaintenanceItem();

  MaintenanceItem.fromCode(
      key, name, description, createdDate, createdBy, updatedDate, updatedBy, price)
      : this.price = price,
        super.fromCode(
            key, name, description, createdDate, createdBy, updatedDate, updatedBy);

  MaintenanceItem.fromSnapshot(DataSnapshot snapshot)
      : price = snapshot.value['price'],
        super.fromSnapshot(snapshot);
  
  MaintenanceItem.fromMap(Map<dynamic, dynamic> map)
      : price = map['price'],
        super.fromMap(map);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['price'] = price;
    return json;
  }
}
