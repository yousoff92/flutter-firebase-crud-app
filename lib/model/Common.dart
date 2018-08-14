import 'package:firebase_database/firebase_database.dart';

class Common {
  String key;
  String name;
  String description;
  DateTime createdDate;
  String createdBy;
  DateTime updatedDate;
  String updatedBy;

  Common();

  Common.fromCode(
      key, name, description, createdDate, createdBy, updatedDate, updatedBy)
      : this.key = key,
        this.name = name,
        this.description = description,
        this.createdDate = createdDate,
        this.createdBy = createdBy,
        this.updatedDate = updatedDate,
        this.updatedBy = updatedBy;

  Common.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        description = snapshot.value['description'],
        createdDate = snapshot.value['createdDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            snapshot.value['createdDate']) : null,
        createdBy = snapshot.value['createdBy'],
        updatedDate = snapshot.value['updatedDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            snapshot.value['updatedDate']) : null,
        updatedBy = snapshot.value['updatedBy'];

  Common.fromMap(Map<dynamic, dynamic> map)
    :   key = map["key"],
        name = map['name'],
        description = map['description'],
        createdDate = map['createdDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            map['createdDate']) : null,
        createdBy = map['createdBy'],
        updatedDate = map['updatedDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            map['updatedDate']) : null,
        updatedBy = map['updatedBy'];

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "createdDate": createdDate != null ? createdDate.millisecondsSinceEpoch : null,
      "createdBy": createdBy,
      "updatedDate": updatedDate != null ? updatedDate.millisecondsSinceEpoch : null,
      "updatedBy": updatedBy
    };
  }
}
