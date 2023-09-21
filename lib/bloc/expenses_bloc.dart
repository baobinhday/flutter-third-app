import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:third_app/bloc/expenses_state.dart';
import 'package:third_app/models/expense.dart';

final List<Expense> initExpensesValue = [
  Expense(
    title: 'Flutter Course',
    amount: 19.99,
    date: DateTime.now(),
    category: Category.work,
  ),
  Expense(
    title: 'Cinema',
    amount: 15.69,
    date: DateTime.now(),
    category: Category.leisure,
  ),
];

class ExpensesBloc extends Cubit<ExpensesState> {
  ExpensesBloc()
      : super(
          ExpensesState([]),
        );

  void initExpenses() {
    emit(ExpensesState(initExpensesValue));
  }

  void addExpense(Expense expense) {
    List<Expense> newExpenses = [...state.expenses, expense];
    emit(ExpensesState(newExpenses));
  }

  void removeExpense(Expense expense) {
    List<Expense> newExpenses = [...state.expenses]..remove(expense);
    emit(ExpensesState(newExpenses));
  }

  void insertExpense(Expense expense, int index) {
    List<Expense> newExpenses = [...state.expenses]..insert(index, expense);
    emit(ExpensesState(newExpenses));
  }
}
