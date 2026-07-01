class DistrictModel {
  String id;
  String? provinceId;
  String nameEn;
  String? nameKm;
  int? sortOrder;
  bool? isActive;

  DistrictModel({
    required this.id,
    this.provinceId,
    required this.nameEn,
    this.nameKm,
    this.sortOrder,
    this.isActive,
  });

  // 🟢 បំប្លែងទិន្នន័យ JSON ពី API មកជា Object (Dart)
  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id:
        json["id"] ??
        json["_id"] ??
        "", // ការពារ Error បើ Backend ប្រើ _id ជំនួស id
    provinceId: json["province_id"]?.toString(),
    nameEn: json["name_en"] ?? "Unknown District",
    nameKm: json["name_km"]?.toString(),
    sortOrder: json["sort_order"],
    isActive: json["is_active"],
  );

  // 🟢 បំប្លែង Object ទៅជា JSON វិញ (បើមានតម្រូវការបោះទៅ API វិញ)
  Map<String, dynamic> toJson() => {
    "id": id,
    "province_id": provinceId,
    "name_en": nameEn,
    "name_km": nameKm,
    "sort_order": sortOrder,
    "is_active": isActive,
  };
}
