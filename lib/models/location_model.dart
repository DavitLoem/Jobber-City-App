class LocationModel {
  final String id;
  final String? provinceId;
  final String nameKm;
  final String nameEn;
  final int sortOrder;
  final bool isActive;

  LocationModel({
    required this.id,
    this.provinceId,
    required this.nameKm,
    required this.nameEn,
    required this.sortOrder,
    required this.isActive,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json["id"]?.toString() ?? '',
      provinceId: json["province_id"]?.toString(),
      nameKm: json["name_km"]?.toString() ?? '',
      nameEn: json["name_en"]?.toString() ?? '',
      sortOrder: json["sort_order"] ?? 0,
      isActive: json["is_active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      if (provinceId != null) "province_id": provinceId,
      "name_km": nameKm,
      "name_en": nameEn,
      "sort_order": sortOrder,
      "is_active": isActive,
    };
  }
}
