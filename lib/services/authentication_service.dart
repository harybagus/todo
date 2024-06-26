import 'package:todo/models/account.dart';
import 'package:todo/repositories/repository.dart';

class AuthenticationService {
  late Repository _repository;

  AuthenticationService() {
    _repository = Repository();
  }

  // create account
  createAccount(Account account) async {
    return await _repository.createData('account', account.accountMap());
  }

  // read account by email
  readAccountByEmail(String email) async {
    return await _repository.readDataByColumnName('account', 'email', email);
  }

  // read account by id
  readAccountById(int id) async {
    return await _repository.readDataByColumnName('account', 'id', id);
  }

  updateAccount(Account account) async {
    return await _repository.updateData('account', account.accountMap());
  }
}
