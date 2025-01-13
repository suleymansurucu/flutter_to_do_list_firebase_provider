import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/providers/all_providers.dart';

import '../models/todo_model.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {

  TodoListItemWidget({super.key});

  @override
  ConsumerState<TodoListItemWidget> createState() => _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textEditingController;

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTodoItem = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: (isFocus) {
        if (!isFocus) {
          setState(() {
            _hasFocus = false;
          });
          ref.read(todoListProvider.notifier).edit(id: currentTodoItem.id, newDescription: _textEditingController.text);
        }
      },
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
          });
          _textFocusNode.requestFocus();
          _textEditingController.text = currentTodoItem.description;

        },
        leading: Checkbox(
            value: currentTodoItem.isCompleted,
            onChanged: (value) {
              ref.read(todoListProvider.notifier).toggle(currentTodoItem.id);
            }),
        title: _hasFocus
            ? TextField(
                controller: _textEditingController,
                focusNode: _textFocusNode,
              )
            : Text(currentTodoItem.description),
      ),
    );
  }
}
