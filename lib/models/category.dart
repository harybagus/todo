class Category {
  int? id;
  int? accountId;
  String? category;
  int? color;

  // create mapping for category
  categoryMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['accountId'] = accountId;
    mapping['category'] = category;
    mapping['color'] = color;

    return mapping;
  }
}
