import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/future_provider.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/models/todo_model.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/providers/all_providers.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/widgets/title_widget.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/widgets/todo_list_item_widget.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/widgets/toolbar_widget.dart';
import 'package:uuid/uuid.dart';

class TodoApp extends ConsumerWidget {
  TodoApp({super.key});

  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allModel = ref.watch(filteredTodoList);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          TitleWidget(),
          TextField(
            controller: newTodoController,
            decoration: InputDecoration(
              labelText: 'What will doing today?',
            ),
            onSubmitted: (newTodo) {
              ref.read(todoListProvider.notifier).addTodo(newTodo);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ToolbarWidget(),
          allModel.length == 0
              ? Center(child: Text('There is not any tasks'))
              : SizedBox(),
          for (int i = 0; i < allModel.length; i++)
            Dismissible(
                key: ValueKey(allModel[i].id),
                onDismissed: (_) {
                  ref.read(todoListProvider.notifier).remove(allModel[i]);
                },
                child: ProviderScope(overrides: [
                  currentTodoProvider.overrideWithValue(allModel[i]),
                ], child: TodoListItemWidget())),

          ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FutureProviderExample()));
          }, child: Text('Future Provider Example'))
        ],
      ),
    );
  }
}
