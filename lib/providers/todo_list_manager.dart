import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/models/todo_model.dart';
import 'package:uuid/uuid.dart';



class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    var addTodo = TodoModel(id: Uuid().v4(), description: description);
    state = [...state, addTodo];
  }

  void toggle(String id) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: todo.description,
              isCompleted: !todo.isCompleted)
        else
          todo
    ];
  }

  void edit({required String id, required String newDescription}) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: newDescription,
              isCompleted: todo.isCompleted)
        else
          todo
    ];
  }

  void remove(TodoModel removeTodoModel) {
    state = state.where((element) => element.id != removeTodoModel.id).toList();
  }
  int onCompletedCount(){
    return state.where((element)=> !element.isCompleted).length;
  }
}
