import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/all_providers.dart';

class ToolbarWidget extends ConsumerWidget {
  ToolbarWidget({super.key});

  Color changeTextColor(TodoListFilter currentFilter, TodoListFilter filter) {
    return currentFilter == filter ? Colors.orange : Colors.black26;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unCompletedTodoCount = ref.watch(unCompletedTodoCountProvider);
    final currentFilter = ref.watch(todoListFilterProvider);

    print('Toolbar Widget was rebuilt');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(unCompletedTodoCount == 0
              ? 'You completed all tasks'
              : 'You have $unCompletedTodoCount tasks'),
        ),
        Tooltip(
          message: 'Your Tasks',
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: changeTextColor(
                currentFilter,
                TodoListFilter.all,
              ),
            ),
            onPressed: () {
              ref.read(todoListFilterProvider.notifier).state =
                  TodoListFilter.all;
            },
            child: const Text('All'),
          ),
        ),
        Tooltip(
          message: 'Uncompleted Tasks',
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: changeTextColor(
                currentFilter,
                TodoListFilter.active,
              ),
            ),
            onPressed: () {
              ref.read(todoListFilterProvider.notifier).state =
                  TodoListFilter.active;
            },
            child: const Text('Active'),
          ),
        ),
        Tooltip(
          message: 'Your Completed Tasks',
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: changeTextColor(
                currentFilter,
                TodoListFilter.completed,
              ),
            ),
            onPressed: () {
              ref.read(todoListFilterProvider.notifier).state =
                  TodoListFilter.completed;
            },
            child: const Text('Completed'),
          ),
        ),
      ],
    );
  }
}
