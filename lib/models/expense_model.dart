import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 5)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String category;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? note;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
  });
}
