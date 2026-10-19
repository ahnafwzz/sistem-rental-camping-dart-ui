import 'exceptions.dart';

enum RentalStatus { active, returned, cancelled }

class Customer {
  final String id;
  final String name;
  final String? phoneNumber;

  Customer({required this.id, required this.name, this.phoneNumber});
}

class Equipment {
  final String id;
  final String name;
  final double pricePerDay;
  int stock;

  Equipment({
    required this.id,
    required this.name,
    required this.pricePerDay,
    required this.stock,
  });

  void reduceStock(int quantity) {
    if (stock < quantity) {
      throw OutOfStockException(
        'Stok $name tidak cukup: tersisa $stock unit, diminta $quantity unit',
      );
    }
    stock -= quantity;
  }

  void restoreStock(int quantity) {
    stock += quantity;
  }
}