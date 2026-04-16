import 'package:flutter/material.dart';

class ExpenseItem {
  final String name;
  final double amount;
  const ExpenseItem({required this.name, required this.amount});
}

class ExpenseCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<ExpenseItem> items;
  const ExpenseCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  double get total => items.fold(0, (s, i) => s + i.amount);
}

class SiteData {
  final String name;
  final String location;
  final List<ExpenseCategory> categories;
  const SiteData({
    required this.name,
    required this.location,
    required this.categories,
  });
  double get totalExpenses => categories.fold(0, (s, c) => s + c.total);
}
