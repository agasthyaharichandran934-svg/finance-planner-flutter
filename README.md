# 💰 Finance Planner

A personal finance and goal planning mobile application built with **Flutter**. The app helps users track income and expenses, manage monthly budgets, set financial goals, and visualize their spending.

## 📱 Features

* 💵 **Income Management**

  * Add and track income
  * Edit and manage income records
  * Persistent local storage

* 💸 **Expense Management**

  * Add, edit, and delete expenses
  * Categorize expenses
  * View transaction history
  * Persistent local storage

* 🎯 **Financial Goals**

  * Create personal financial goals
  * Set target amounts
  * Track goal progress
  * Delete completed/unwanted goals

* 📊 **Analytics**

  * Visualize expenses using charts
  * Understand spending distribution by category

* 💰 **Monthly Budget**

  * Set a monthly spending budget
  * Track budget usage

* 🌓 **Light & Dark Mode**

  * Switch between light and dark themes
  * Theme preference is saved locally

* 💾 **Local Data Persistence**

  * User data is stored locally using `shared_preferences`
  * Data remains available after closing and reopening the app

* 📱 **Android Release**

  * Release APK generated for Android devices

## 🛠️ Technologies Used

| Technology        | Purpose                          |
| ----------------- | -------------------------------- |
| Flutter           | Mobile application framework     |
| Dart              | Application programming language |
| SharedPreferences | Local data persistence           |
| fl_chart          | Data visualization               |
| Material Design   | User interface                   |
| Git & GitHub      | Version control                  |

## 📂 Project Structure

```text
lib/
├── main.dart
├── add_expense_screen.dart
├── add_income_screen.dart
├── add_goal_screen.dart
├── edit_expense_screen.dart
├── transactions_screen.dart
├── goals_screen.dart
├── budget_screen.dart
├── analytics_screen.dart
├── expense.dart
├── income.dart
├── goal.dart
└── budget.dart

assets/
└── icon/
    └── app_icon.png
```

## 🚀 Getting Started

### Prerequisites

Make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* Android SDK

### Clone the repository

```bash
git clone https://github.com/agasthyaharichandran934-svg/finance-planner-flutter.git
```

### Open the project

```bash
cd finance-planner-flutter
```

### Install dependencies

```bash
flutter pub get
```

### Run the application

Connect an Android device or start an Android emulator and run:

```bash
flutter run
```

## 📦 Build APK

To generate a release APK:

```bash
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 🎯 Project Objective

The objective of this project was to build a practical mobile application that combines **financial tracking, budgeting, goal planning, local data persistence, and data visualization** in a single Flutter application.

The project also provided hands-on experience with Flutter application development, Dart, UI design, state management, local storage, Android builds, and Git/GitHub.

## 🔮 Future Improvements

Possible future enhancements include:

* Cloud synchronization
* User authentication
* Database integration
* Recurring transactions
* Notifications and reminders
* Export transactions to CSV/PDF
* More detailed financial reports
* Goal progress updates based on savings

## 👨‍💻 Developer

**Agasthya Harichandran**

B.Tech Computer Science and Design

GitHub:
https://github.com/agasthyaharichandran934-svg

---

⭐ If you find this project useful, feel free to explore the repository.
