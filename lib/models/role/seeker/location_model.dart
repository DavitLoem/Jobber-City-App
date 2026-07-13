<<<<<<< HEAD
=======
// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

>>>>>>> origin/profile_new
import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  String id;
  dynamic nameKm;
  String nameEn;

  LocationModel({required this.id, required this.nameKm, required this.nameEn});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"]?.toString() ?? json["_id"]?.toString() ?? '',
    nameKm: json["name_km"],
    nameEn: json["name_en"]?.toString() ?? json["name"]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_km": nameKm,
    "name_en": nameEn,
  };
}
