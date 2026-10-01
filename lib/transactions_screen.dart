import 'package:flutter/material.dart';
import 'expense.dart';
import 'income.dart';

class TransactionsScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Income> incomes;

  final void Function(Expense) onDeleteExpense;
  final void Function(Income) onDeleteIncome;
  final Future<Expense?> Function(Expense) onEditExpense;

  const TransactionsScreen({
    super.key,
    required this.expenses,
    required this.incomes,
    required this.onDeleteExpense,
    required this.onDeleteIncome,
    required this.onEditExpense,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_outlined;

      case 'Travel':
        return Icons.directions_car_outlined;

      case 'Shopping':
        return Icons.shopping_bag_outlined;

      case 'Bills':
        return Icons.receipt_long_outlined;

      case 'Entertainment':
        return Icons.movie_outlined;

      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor =
        theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),

      body: (widget.expenses.isEmpty && widget.incomes.isEmpty)
          ? Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryTextColor,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // =========================
                // INCOME SECTION
                // =========================

                if (widget.incomes.isNotEmpty) ...[
                  Text(
                    'Income',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...widget.incomes.map(
                    (income) => Container(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? Colors.white12
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor:
                                Color(0xFFE8F5E9),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  income.source,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  income.description,
                                  style: TextStyle(
                                    color:
                                        secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                '+₹${income.amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  widget
                                      .onDeleteIncome(
                                    income,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // =========================
                // EXPENSE SECTION
                // =========================

                if (widget.expenses.isNotEmpty) ...[
                  const SizedBox(height: 10),

                  Text(
                    'Expenses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...widget.expenses.map(
                    (expense) => Container(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? Colors.white12
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                const Color(0xFFEFF6FF),
                            child: Icon(
                              getCategoryIcon(
                                expense.category,
                              ),
                              color:
                                  const Color(0xFF2563EB),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  expense.description,
                                  style: TextStyle(
                                    color:
                                        secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                '-₹${expense.amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  await widget
                                      .onEditExpense(
                                    expense,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  widget
                                      .onDeleteExpense(
                                    expense,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}