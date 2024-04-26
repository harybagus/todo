import 'package:todo/models/todo.dart';
import 'package:todo/repositories/repository.dart';

class TodoService {
  late Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  // create todo
  createTodo(Todo todo) async {
    return await _repository.createData('todo', todo.todoMap());
  }

  // read todo by joining category
  readTodoByJoiningCategory(int accountId, String date) async {
    return await _repository.readDataByJoiningTables(
      'SELECT todo.id, todo.accountId, todo.title, todo.description, '
      'todo.categoryId, category.category, category.color, todo.date, todo.status '
      'FROM todo '
      'INNER JOIN category ON todo.categoryId = category.id '
      'WHERE todo.accountId = ? AND todo.date = ? '
      'ORDER BY todo.id DESC',
      [accountId, date],
    );
  }

  // read todo by category id
  readTodoByCategoryId(int accountId, String date, int categoryId) async {
    return await _repository.readDataByJoiningTables(
      'SELECT todo.id, todo.accountId, todo.title, todo.description, '
      'todo.categoryId, category.category, category.color, todo.date, todo.status '
      'FROM todo '
      'INNER JOIN category ON todo.categoryId = category.id '
      'WHERE todo.accountId = ? AND todo.date = ? AND todo.categoryId = ?'
      'ORDER BY todo.id DESC',
      [accountId, date, categoryId],
    );
  }

  // read todo by title
  readTodoByTitle(int accountId, String date, String title) async {
    return await _repository.readDataByJoiningTables(
      'SELECT todo.id, todo.accountId, todo.title, todo.description, '
      'todo.categoryId, category.category, category.color, todo.date, todo.status '
      'FROM todo '
      'INNER JOIN category ON todo.categoryId = category.id '
      'WHERE todo.accountId = ? AND todo.date = ? AND todo.title LIKE ?'
      'ORDER BY todo.id DESC',
      [accountId, date, '%$title%'],
    );
  }

  // read todo by title
  readTodoByTitleAndCategoryId(
    int accountId,
    String date,
    String title,
    int categoryId,
  ) async {
    return await _repository.readDataByJoiningTables(
      'SELECT todo.id, todo.accountId, todo.title, todo.description, '
      'todo.categoryId, category.category, category.color, todo.date, todo.status '
      'FROM todo '
      'INNER JOIN category ON todo.categoryId = category.id '
      'WHERE todo.accountId = ? AND todo.date = ? AND todo.title LIKE ? AND todo.categoryId = ?'
      'ORDER BY todo.id DESC',
      [accountId, date, '%$title%', categoryId],
    );
  }

  // update todo
  updateTodo(Todo todo) async {
    return await _repository.updateData('todo', todo.todoMap());
  }

  // delete todo
  deleteTodo(int todoId) async {
    return await _repository.deleteData('todo', todoId);
  }
}
