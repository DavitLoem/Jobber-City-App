import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String id;
  String name;
  String iconUrl;
  int sortOrder;
  bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.sortOrder,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      // 1. Safely handle "id" or MongoDB "_id" fields and convert to String
      id: (json["id"] ?? json["_id"] ?? "").toString(),

      // 2. Fallback to "Unknown" if the category name is missing
      name: json["name"]?.toString() ?? "Unnamed Category",

      // 3. 🛡️ Crucial: Prevents 'Null is not a subtype of String' if icon_url is null
      iconUrl: json["icon_url"]?.toString() ?? "",

      // 4. Safely parse integer values even if sent as strings from the database
      sortOrder: json["sort_order"] is int
          ? json["sort_order"]
          : int.tryParse(json["sort_order"]?.toString() ?? "0") ?? 0,

      // 5. Safely handle boolean assignment
      isActive: json["is_active"] is bool
          ? json["is_active"]
          : (json["is_active"]?.toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon_url": iconUrl,
    "sort_order": sortOrder,
    "is_active": isActive,
  };
}
