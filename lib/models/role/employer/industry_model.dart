// To parse this JSON data, do
//
//     final industryModel = industryModelFromJson(jsonString);
class IndustryModel {
  final String id;
  final String name;
  final int order;
  final bool isActive;

  IndustryModel({
    required this.id,
    required this.name,
    required this.order,
    required this.isActive,
  });

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      id: json['id'],
      name: json['name'],
      order: json['order'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "order": order,
    "is_active": isActive,
  };
}
