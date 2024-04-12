class Account {
  int? id;
  String? name;
  String? email;
  String? password;
  String? photoName;

  // create mapping for account
  accountMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['name'] = name;
    mapping['email'] = email;
    mapping['password'] = password;
    mapping['photoName'] = photoName;

    return mapping;
  }
}
