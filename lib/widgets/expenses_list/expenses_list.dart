import 'package:flutter/material.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveItem,
  });

  final List<Expense> expenses;

  final void Function(Expense expense) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index].id),
        background: Container(
          margin: Theme.of(context).cardTheme.margin,
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onRemoveItem(expenses[index]);
          }
        },
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
