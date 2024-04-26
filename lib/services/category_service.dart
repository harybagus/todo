import 'package:todo/models/category.dart';
import 'package:todo/repositories/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  // create category
  createCategory(Category category) async {
    return await _repository.createData('category', category.categoryMap());
  }

  // read categories by account id
  readCategoriesByAccountId(int accountId) async {
    return await _repository.readDataByColumnName(
      'category',
      'accountId',
      accountId,
    );
  }

  // update category
  updateCategory(Category category) async {
    return await _repository.updateData('category', category.categoryMap());
  }
}
