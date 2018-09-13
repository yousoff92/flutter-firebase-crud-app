import 'common.dart';
import 'maintenance_item.dart';
import 'package:firebase_database/firebase_database.dart';

class VehicleMaintenance extends Common {
  DateTime serviceDate;
  String serviceLocation;
  num currentMileage;
  num nextServiceMileage;
  List<MaintenanceItem> maintenanceItems;

  VehicleMaintenance();

  VehicleMaintenance.fromCode(
      key,
      name,
      description,
      createdDate,
      createdBy,
      updatedDate,
      updatedBy,
      serviceDate,
      serviceLocation,
      currentMileage,
      nextServiceMileage,
      maintenanceItems)
      : this.serviceDate = serviceDate,
        this.serviceLocation = serviceLocation,
        this.currentMileage = currentMileage,
        this.nextServiceMileage = nextServiceMileage,
        this.maintenanceItems = maintenanceItems,
        super.fromCode(
            key, name, description, createdDate, createdBy, updatedDate, updatedBy);

  VehicleMaintenance.fromSnapshot(DataSnapshot snapshot)
      : serviceDate = snapshot.value['serviceDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            snapshot.value['serviceDate']) : null,
        serviceLocation = snapshot.value['serviceLocation'],
        currentMileage = snapshot.value['currentMileage'],
        nextServiceMileage = snapshot.value['nextServiceMileage'],
        maintenanceItems = convertObject(snapshot.value['maintenanceItems']),
        super.fromSnapshot(snapshot);

  VehicleMaintenance.fromMap(Map<dynamic, dynamic> map)
    : serviceDate = map['serviceDate'] != null ? new DateTime.fromMillisecondsSinceEpoch(
            map['serviceDate']) : null,
        serviceLocation = map['serviceLocation'],
        currentMileage = map['currentMileage'],
        nextServiceMileage = map['nextServiceMileage'],
        maintenanceItems = convertObject(map['maintenanceItems']),
        super.fromMap(map);

  @override
  toJson() {
    Map<String, dynamic> json = super.toJson();
    json['serviceDate'] = serviceDate != null ? serviceDate.millisecondsSinceEpoch : null;
    json['serviceLocation'] = serviceLocation;
    json['currentMileage'] = currentMileage;
    json['nextServiceMileage'] = nextServiceMileage;
    //json['maintenanceItems'] = maintenanceItems;
    return json;
  }

  static List convertObject(Map<dynamic, dynamic> items) {
    List<MaintenanceItem> list = [];
    if(items != null) {
      for (String key in items.keys) {
        MaintenanceItem v = MaintenanceItem.fromMap(items[key]);
        if(v != null) {
          v.key = key;
          list.add(v);
        }
      }
    }
    return list;
  }

}
