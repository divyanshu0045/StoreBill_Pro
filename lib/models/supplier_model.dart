import 'package:hive/hive.dart';

part 'supplier_model.g.dart';

@HiveType(typeId: 6)
class Supplier extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? address;

  @HiveField(5)
  double totalPayable;

  Supplier({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.address,
    this.totalPayable = 0.0,
  });
}
