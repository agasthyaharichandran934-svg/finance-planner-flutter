import 'package:flutter/material.dart';
import 'goal.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final currentController = TextEditingController();
  final deadlineController = TextEditingController();

  void saveGoal() {
    final name = nameController.text.trim();
    final target = double.tryParse(targetController.text);
    final current = double.tryParse(currentController.text) ?? 0;
    final deadline = deadlineController.text.trim();

    if (name.isEmpty || target == null || target <= 0 || deadline.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid goal details'),
        ),
      );
      return;
    }

    if (current < 0 || current > target) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current amount must be between ₹0 and the target'),
        ),
      );
      return;
    }

    final goal = Goal(
      name: name,
      targetAmount: target,
      currentAmount: current,
      deadline: deadline,
    );

    Navigator.pop(context, goal);
  }

  @override
  void dispose() {
    nameController.dispose();
    targetController.dispose();
    currentController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Example: New Laptop',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Target Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: 'Enter target amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Current Savings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: currentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₹ ',
                hintText: 'Enter current savings',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deadline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                hintText: 'Example: 2028',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveGoal,
                child: const Text(
                  'Save Goal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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