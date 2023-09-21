import 'package:flutter/material.dart';
import 'package:third_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  NewExpense({super.key, required this.onAddExpense});

  void Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onChangeCategory(value) {
    if (value == null) {
      return;
    }
    setState(() {
      _selectedCategory = value;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('CLose'),
            )
          ],
        ),
      );
      return;
    }

    final Expense newExpense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );
    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Form(
                child: Column(
                  children: [
                    if (width >= 1600)
                      Row(
                        children: [
                          TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Amount'), prefixText: '\$ '),
                            ),
                          )
                        ],
                      )
                    else
                      TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text('Amount'), prefixText: '\$ '),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.date_range),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _onChangeCategory,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: _submitExpenseData,
                            child: const Text('Save Expense'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }
}