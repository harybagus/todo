import 'package:todo/models/account.dart';
import 'package:todo/repositories/repository.dart';

class AuthenticationService {
  late Repository _repository;

  AuthenticationService() {
    _repository = Repository();
  }

  createAccount(Account account) async {
    return await _repository.createData('account', account.accountMap());
  }

  readAccountByEmail(String email) async {
    return await _repository.readDataByColumnName('account', 'email', email);
  }
}
