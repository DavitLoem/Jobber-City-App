class MasterDataItem {
  final String id;
  final String name;

  MasterDataItem({required this.id, required this.name});

  factory MasterDataItem.fromJson(Map<String, dynamic> json) => MasterDataItem(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    name:
        (json['name'] ??
                json['name_en'] ??
                json['name_km'] ??
                json['title'] ??
                '')
            .toString(),
  );
}
