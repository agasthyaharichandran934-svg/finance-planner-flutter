import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'expense.dart';
import 'transactions_screen.dart';
import 'goal.dart';
import 'goals_screen.dart';
import 'analytics_screen.dart';
import 'income.dart';
import 'add_income_screen.dart';
import 'budget.dart';
import 'budget_screen.dart';
import 'add_goal_screen.dart';

void main() {
  runApp(const FinancePlannerApp());
}

// =====================================================
// APP
// =====================================================

class FinancePlannerApp extends StatefulWidget {
  const FinancePlannerApp({super.key});

  @override
  State<FinancePlannerApp> createState() =>
      _FinancePlannerAppState();
}

class _FinancePlannerAppState extends State<FinancePlannerApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDarkMode = !isDarkMode;
    });

    await prefs.setBool('darkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Planner',

      themeMode:
          isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF60A5FA),
          brightness: Brightness.dark,
        ),
      ),

      home: DashboardScreen(
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

// =====================================================
// DASHBOARD
// =====================================================

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({
    super.key,
    required this.onToggleTheme,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Expense> expenses = [];
  final List<Income> incomes = [];

  Budget budget = Budget(
    monthlyLimit: 20000,
  );

  int selectedIndex = 0;

  final List<Goal> goals = [
    Goal(
      name: 'Dream Home',
      targetAmount: 7000000,
      currentAmount: 120000,
      deadline: '2034',
    ),
  ];

  // ===================================================
  // LOAD DATA
  // ===================================================

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedExpenses =
        prefs.getStringList('expenses') ?? [];

    final savedIncomes =
        prefs.getStringList('incomes') ?? [];

    final savedBudget =
        prefs.getString('budget');

    final savedGoals =
        prefs.getStringList('goals');

    if (!mounted) return;

    setState(() {
      expenses.clear();
      incomes.clear();

      for (final data in savedExpenses) {
        expenses.add(
          Expense.fromStorageString(data),
        );
      }

      for (final data in savedIncomes) {
        incomes.add(
          Income.fromStorageString(data),
        );
      }

      if (savedBudget != null) {
        budget =
            Budget.fromStorageString(savedBudget);
      }

      if (savedGoals != null) {
        goals.clear();

        for (final data in savedGoals) {
          goals.add(
            Goal.fromStorageString(data),
          );
        }
      }
    });
  }

  // ===================================================
  // SAVE DATA
  // ===================================================

  Future<void> saveData() async {
    final prefs =
        await SharedPreferences.getInstance();

    final expenseData = expenses
        .map(
          (expense) =>
              expense.toStorageString(),
        )
        .toList();

    final incomeData = incomes
        .map(
          (income) =>
              income.toStorageString(),
        )
        .toList();

    final goalData = goals
        .map(
          (goal) =>
              goal.toStorageString(),
        )
        .toList();

    await prefs.setStringList(
      'expenses',
      expenseData,
    );

    await prefs.setStringList(
      'incomes',
      incomeData,
    );

    await prefs.setString(
      'budget',
      budget.toStorageString(),
    );

    await prefs.setStringList(
      'goals',
      goalData,
    );
  }

  // ===================================================
  // INIT
  // ===================================================

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ===================================================
  // TOTAL EXPENSES
  // ===================================================

  double get totalExpenses {
    double total = 0;

    for (final expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  // ===================================================
  // TOTAL INCOME
  // ===================================================

  double get totalIncome {
    double total = 0;

    for (final income in incomes) {
      total += income.amount;
    }

    return total;
  }

  // ===================================================
  // ADD EXPENSE
  // ===================================================

  Future<void> addExpense() async {
    final expense =
        await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddExpenseScreen(),
      ),
    );

    if (expense != null) {
      setState(() {
        expenses.add(expense);
      });

      await saveData();
    }
  }

  // ===================================================
  // ADD INCOME
  // ===================================================

  Future<void> addIncome() async {
    final income =
        await Navigator.push<Income>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddIncomeScreen(),
      ),
    );

    if (income != null) {
      setState(() {
        incomes.add(income);
      });

      await saveData();
    }
  }

  // ===================================================
  // ADD GOAL
  // ===================================================

  Future<void> addGoal() async {
    final goal =
        await Navigator.push<Goal>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddGoalScreen(),
      ),
    );

    if (goal != null) {
      setState(() {
        goals.add(goal);
      });

      await saveData();
    }
  }

  // ===================================================
  // SET BUDGET
  // ===================================================

  Future<void> setBudget() async {
    final newBudget =
        await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BudgetScreen(
          currentBudget:
              budget.monthlyLimit,
        ),
      ),
    );

    if (newBudget != null) {
      setState(() {
        budget = Budget(
          monthlyLimit: newBudget,
        );
      });

      await saveData();
    }
  }

  // ===================================================
  // DASHBOARD
  // ===================================================

  Widget buildDashboard() {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    final cardColor =
        theme.colorScheme.surface;

    final textColor =
        theme.colorScheme.onSurface;

    final secondaryTextColor =
        theme.colorScheme.onSurfaceVariant;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =================================================
          // BALANCE CARD
          // =================================================

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  const Color(0xFF172554),
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '₹${(totalIncome - totalExpenses).toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    FinanceSummary(
                      title: 'Income',
                      amount:
                          '₹${totalIncome.toStringAsFixed(0)}',
                      icon:
                          Icons.arrow_downward,
                    ),

                    FinanceSummary(
                      title: 'Expenses',
                      amount:
                          '₹${totalExpenses.toStringAsFixed(0)}',
                      icon:
                          Icons.arrow_upward,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child:
                      OutlinedButton.icon(
                    onPressed:
                        addIncome,
                    icon:
                        const Icon(Icons.add),
                    label: const Text(
                      'Add Income',
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child:
                      OutlinedButton.icon(
                    onPressed:
                        setBudget,
                    icon: const Icon(
                      Icons
                          .account_balance_wallet_outlined,
                    ),
                    label: const Text(
                      'Set Monthly Budget',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =================================================
          // MONTHLY BUDGET
          // =================================================

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white12
                    : Colors.transparent,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Budget: ₹${budget.monthlyLimit.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    Text(
                      'Spent: ₹${totalExpenses.toStringAsFixed(0)}',
                      style:
                          const TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                LinearProgressIndicator(
                  value:
                      budget.monthlyLimit > 0
                          ? (totalExpenses /
                                  budget.monthlyLimit)
                              .clamp(0.0, 1.0)
                          : 0,
                  minHeight: 9,
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                const SizedBox(height: 12),

                Text(
                  totalExpenses <=
                          budget.monthlyLimit
                      ? 'Remaining: ₹${(budget.monthlyLimit - totalExpenses).toStringAsFixed(0)}'
                      : 'Over budget by: ₹${(totalExpenses - budget.monthlyLimit).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        totalExpenses <=
                                budget.monthlyLimit
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =================================================
          // ADD GOAL
          // =================================================

          SizedBox(
            width: double.infinity,
            child:
                OutlinedButton.icon(
              onPressed: addGoal,
              icon: const Icon(
                Icons.flag_outlined,
              ),
              label: const Text(
                'Add New Goal',
              ),
            ),
          ),

          const SizedBox(height: 14),

          // =================================================
          // GOALS TITLE
          // =================================================

          Text(
            'Your Goals',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 14),

          // =================================================
          // DYNAMIC GOALS
          // =================================================

          if (goals.isEmpty)
            Text(
              'No goals added yet.',
              style: TextStyle(
                color:
                    secondaryTextColor,
              ),
            ),

          ...goals.map(
            (goal) {
              return Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                padding:
                    const EdgeInsets.all(20),
                decoration:
                    BoxDecoration(
                  color: cardColor,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              Color(0xFFE0E7FF),
                          child: Icon(
                            Icons.flag_outlined,
                            color:
                                Color(0xFF3730A3),
                          ),
                        ),

                        const SizedBox(
                            width: 12),

                        Expanded(
                          child: Text(
                            goal.name,
                            style:
                                TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  textColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 18),

                    Text(
                      '₹${goal.currentAmount.toStringAsFixed(0)} / ₹${goal.targetAmount.toStringAsFixed(0)}',
                      style:
                          TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            textColor,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      child:
                          LinearProgressIndicator(
                        value:
                            goal.progress.clamp(
                          0.0,
                          1.0,
                        ),
                        minHeight: 9,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      '${(goal.progress * 100).toStringAsFixed(1)}% completed',
                      style:
                          TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(
                        height: 6),

                    Text(
                      'Deadline: ${goal.deadline}',
                      style:
                          TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // =================================================
          // THIS MONTH
          // =================================================

          Text(
            'This Month',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 14),

          if (expenses.isEmpty)
            Text(
              'No expenses added yet.',
              style: TextStyle(
                color:
                    secondaryTextColor,
              ),
            ),

          ...expenses.map(
            (expense) {
              IconData icon;

              switch (expense.category) {
                case 'Food':
                  icon =
                      Icons.restaurant_outlined;
                  break;

                case 'Travel':
                  icon =
                      Icons.directions_car_outlined;
                  break;

                case 'Shopping':
                  icon =
                      Icons.shopping_bag_outlined;
                  break;

                case 'Bills':
                  icon =
                      Icons.receipt_long_outlined;
                  break;

                case 'Entertainment':
                  icon =
                      Icons.movie_outlined;
                  break;

                default:
                  icon =
                      Icons.category_outlined;
              }

              return SpendingItem(
                icon: icon,
                title:
                    expense.category,
                amount:
                    '₹${expense.amount.toStringAsFixed(0)}',
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    if (selectedIndex == 0) {
      currentScreen =
          buildDashboard();
    } else if (selectedIndex == 1) {
      currentScreen =
          TransactionsScreen(
        expenses: expenses,
        incomes: incomes,

        onDeleteExpense:
            (expense) async {
          setState(() {
            expenses.remove(expense);
          });

          await saveData();
        },

        onEditExpense:
            (expense) async {
          final updatedExpense =
              await Navigator.push<Expense>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditExpenseScreen(
                expense: expense,
              ),
            ),
          );

          if (updatedExpense != null) {
            setState(() {
              final index =
                  expenses.indexOf(
                expense,
              );

              if (index != -1) {
                expenses[index] =
                    updatedExpense;
              }
            });

            await saveData();
          }

          return updatedExpense;
        },

        onDeleteIncome:
            (income) async {
          setState(() {
            incomes.remove(income);
          });

          await saveData();
        },
      );
    } else if (selectedIndex == 2) {
      currentScreen =
          GoalsScreen(
        goals: goals,
        onDeleteGoal:
            (goal) async {
          setState(() {
            goals.remove(goal);
          });

          await saveData();
        },
      );
    } else {
      currentScreen =
          AnalyticsScreen(
        expenses: expenses,
      );
    }

    final isDark =
        Theme.of(context)
            .brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,

        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Good evening 👋',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),

            Text(
              'Agasthya',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed:
                widget.onToggleTheme,
            icon: Icon(
              isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
            ),
          ),
        ],
      ),

      body: currentScreen,

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            selectedIndex,

        onDestinationSelected:
            (index) {
          setState(() {
            selectedIndex =
                index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            selectedIcon: Icon(
              Icons.receipt_long,
            ),
            label: 'Transactions',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.flag_outlined,
            ),
            selectedIcon: Icon(
              Icons.flag,
            ),
            label: 'Goals',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
            ),
            selectedIcon: Icon(
              Icons.bar_chart,
            ),
            label: 'Analytics',
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

// =====================================================
// FINANCE SUMMARY
// =====================================================

class FinanceSummary extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;

  const FinanceSummary({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),

        const SizedBox(width: 6),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(
                color:
                    Colors.white70,
                fontSize: 12,
              ),
            ),

            Text(
              amount,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =====================================================
// SPENDING ITEM
// =====================================================

class SpendingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;

  const SpendingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color:
            theme.colorScheme.surface,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              theme.brightness ==
                      Brightness.dark
                  ? Colors.white12
                  : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                const Color(
              0xFFEFF6FF,
            ),
            child: Icon(
              icon,
              color: const Color(
                0xFF2563EB,
              ),
            ),
          ),

          const SizedBox(
              width: 14),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
                color: theme
                    .colorScheme
                    .onSurface,
              ),
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color: theme
                  .colorScheme
                  .onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
