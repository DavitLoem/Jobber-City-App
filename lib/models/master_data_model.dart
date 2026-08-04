class MasterDataResponse {
  final bool success;
  final String message;
  final List<MasterDataModel> data;

  MasterDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    return MasterDataResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<MasterDataModel>.from(
              json['data'].map((x) => MasterDataModel.fromJson(x)),
            )
          : [],
    );
  }
}

class MasterDataModel {
  final String id;
  final String name;
  final int order;
  final bool isActive;

  MasterDataModel({
    required this.id,
    required this.name,
    required this.order,
    required this.isActive,
  });

  factory MasterDataModel.fromJson(Map<String, dynamic> json) {
    return MasterDataModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }
}
