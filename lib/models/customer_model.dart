import 'package:hive/hive.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 3)
class Customer extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? email;

  @HiveField(4)
  double totalDue;

  Customer({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.totalDue = 0.0,
  });
}
