class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;
  final int sortOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.sortOrder,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "Unnamed",
      iconUrl: json["icon_url"]?.toString() ?? "",
      sortOrder: json["sort_order"] ?? 0,
      isActive: json["is_active"] ?? false,
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
