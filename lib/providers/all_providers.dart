import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_model.dart';

enum TodoListFilter {
  all,
  active,
  completed
}

final todoListFilterProvider = StateProvider((ref) {
  return TodoListFilter.all;
});

final filteredTodoList = Provider((ref){
  final filter = ref.watch(todoListFilterProvider);
  final todoList = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.all :
      return todoList;
    case TodoListFilter.completed:
      return todoList.where((element) => element.isCompleted).toList();
    case TodoListFilter.active :
      return todoList.where((element) => !element.isCompleted).toList();

  }
}) ;

final todoListProvider =
StateNotifierProvider<TodoListManager, List<TodoModel>>((ref) {
  return TodoListManager([
    TodoModel(id: Uuid().v4(), description: 'I will  go gym'),
    TodoModel(id: Uuid().v4(), description: 'I will  go shopping')
  ]);
});

final unCompletedTodoCountProvider = Provider((ref) {
  final allTodo = ref.watch(todoListProvider);
  final count = allTodo
      .where((element) => !element.isCompleted)
      .length;
  return count;
});

final currentTodoProvider = Provider<TodoModel>((ref) {
  throw UnimplementedError();
});
