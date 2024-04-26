class TodoJoinCategory {
  int? id;
  int? accountId;
  String? title;
  String? description;
  int? categoryId;
  String? category;
  int? color;
  String? date;
  String? status;

  // create mapping for todo
  todoMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['accountId'] = accountId;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['categoryId'] = categoryId;
    mapping['category'] = category;
    mapping['color'] = color;
    mapping['date'] = date;
    mapping['status'] = status;

    return mapping;
  }
}
