class Todo {
  int? id;
  int? accountId;
  String? title;
  String? description;
  int? categoryId;
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
    mapping['date'] = date;
    mapping['status'] = status;

    return mapping;
  }
}
