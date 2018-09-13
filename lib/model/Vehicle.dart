import 'common.dart';
import 'vehicle_maintenance.dart';
import 'package:firebase_database/firebase_database.dart';

class Vehicle extends Common {
  String year;
  num monthlyInsurance;
  var image;
  num mileage;
  List<VehicleMaintenance> vehicleMaintenances;

  Vehicle();

  Vehicle.fromCode(key, name, description, createdDate, createdBy, updatedDate,
      updatedBy, year, monthlyInsurance, image, mileage, vehicleMaintenances)
      : this.year = year,
        this.monthlyInsurance = monthlyInsurance,
        this.image = image,
        this.mileage = mileage,
        this.vehicleMaintenances = vehicleMaintenances,
        super.fromCode(
            key, name, description, createdDate, createdBy, updatedDate, updatedBy);

  Vehicle.fromSnapshot(DataSnapshot snapshot) 
      : year = snapshot.value['year'],
        monthlyInsurance = snapshot.value['monthlyInsurance'],
        image = snapshot.value['image'],
        mileage = snapshot.value['mileage'],
        vehicleMaintenances = convertObject(snapshot.value['vehicleMaintenances']),
        super.fromSnapshot(snapshot);

  static List convertObject(Map<dynamic, dynamic> items) {
    List<VehicleMaintenance> list = [];
    if(items != null) {
      for (String key in items.keys) {
        VehicleMaintenance v = VehicleMaintenance.fromMap(items[key]);

        if(v != null) {
          v.key = key;
          list.add(v);
        }
      }
    }
    return list;
  }      

  @override
  toJson() {
    Map<String, dynamic> json = super.toJson();
    json['year'] = year;
    json['monthlyInsurance'] = monthlyInsurance;
    json['image'] = image;
    json['mileage'] = mileage;
    //json['vehicleMaintenances'] = jsonEncode(vehicleMaintenances);
    return json;
  }
}
