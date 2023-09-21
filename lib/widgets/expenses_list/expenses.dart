
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:third_app/bloc/expenses_bloc.dart';
import 'package:third_app/bloc/expenses_state.dart';
import 'package:third_app/widgets/chart/chart.dart';
import 'package:third_app/widgets/expenses_list/expenses_list.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/expenses_list/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  late ExpensesBloc _expensesBloc;

  @override
  void initState() {
    super.initState();
    _expensesBloc = BlocProvider.of<ExpensesBloc>(context);
    _expensesBloc.initExpenses();
  }

  void _saveNewExpense(Expense newExpense) {
    _expensesBloc.addExpense(newExpense);
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _expensesBloc.state.expenses.indexOf(expense);
    _expensesBloc.removeExpense(expense);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          _expensesBloc.insertExpense(expense, expenseIndex);
        },
      ),
    ));
  }

  void _openExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _saveNewExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Expense Tracker'),
          actions: [
            IconButton(
              onPressed: _openExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocBuilder<ExpensesBloc, ExpensesState>(builder: (ctx, state) {
          Widget mainContent = const Center(
            child: Text('No expensed found. Start adding some!'),
          );
          if (state.expenses.isNotEmpty) {
            mainContent = ExpensesList(
              expenses: state.expenses,
              onRemoveItem: _removeExpense,
            );
          }

          return width < 600
              ? Column(
                  children: [
                    Chart(expenses: state.expenses),
                    Expanded(
                      child: mainContent,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Chart(
                        expenses: state.expenses,
                      ),
                    ),
                    Expanded(
                      child: mainContent,
                    ),
                  ],
                );
        }));
  }
}
