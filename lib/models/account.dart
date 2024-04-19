class Account {
  int? id;
  String? name;
  String? email;
  String? password;
  String? imageName;

  // create mapping for account
  accountMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['name'] = name;
    mapping['email'] = email;
    mapping['password'] = password;
    mapping['imageName'] = imageName;

    return mapping;
  }
}
