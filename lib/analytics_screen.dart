import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const AnalyticsScreen({
    super.key,
    required this.expenses,
  });

  double get totalExpenses {
    double total = 0;

    for (final expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  double getCategoryTotal(String category) {
    double total = 0;

    for (final expense in expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }

    return total;
  }

  double getCategoryPercentage(String category) {
    if (totalExpenses == 0) {
      return 0;
    }

    return (getCategoryTotal(category) / totalExpenses) * 100;
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

    final categories = [
      'Food',
      'Travel',
      'Shopping',
      'Bills',
      'Entertainment',
      'Other',
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // TOTAL SPENDING
            // =========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF172554),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Spending',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${totalExpenses.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'This month',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =========================
            // CATEGORY TITLE
            // =========================

            Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            // =========================
            // PIE CHART
            // =========================

            if (expenses.isNotEmpty) ...[
              const SizedBox(height: 20),

              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (getCategoryTotal('Food') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal('Food'),
                          title: 'Food',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                      if (getCategoryTotal('Travel') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal('Travel'),
                          title: 'Travel',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                      if (getCategoryTotal('Shopping') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal('Shopping'),
                          title: 'Shopping',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                      if (getCategoryTotal('Bills') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal('Bills'),
                          title: 'Bills',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                      if (getCategoryTotal('Entertainment') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal(
                            'Entertainment',
                          ),
                          title: 'Entertainment',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                      if (getCategoryTotal('Other') > 0)
                        PieChartSectionData(
                          value: getCategoryTotal('Other'),
                          title: 'Other',
                          radius: 80,
                          titleStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                    ],
                    centerSpaceRadius: 45,
                    sectionsSpace: 3,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // =========================
            // CATEGORY DETAILS
            // =========================

            ...categories.map((category) {
              final amount =
                  getCategoryTotal(category);

              if (amount == 0) {
                return const SizedBox.shrink();
              }

              return Container(
                margin:
                    const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          '${getCategoryPercentage(category).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            // =========================
            // EMPTY STATE
            // =========================

            if (expenses.isEmpty)
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30),
                  child: Text(
                    'Add some expenses to see your analytics.',
                    style: TextStyle(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}