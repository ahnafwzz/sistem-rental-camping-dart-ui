import 'models.dart';
import 'exceptions.dart';

mixin Discountable {
  double applyDiscount(double basePrice, double discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) return basePrice;
    return basePrice * (1 - discountPercentage / 100);
  }
}

class RentalTransaction with Discountable {
  final String transactionId;
  final Customer customer;
  final Equipment equipment;
  final int durationDays;
  final int quantity;
  RentalStatus status;
  String? returnNote;

  RentalTransaction({
    required this.transactionId,
    required this.customer,
    required this.equipment,
    required this.durationDays,
    required this.quantity,
  }) : status = RentalStatus.active {
    if (durationDays <= 0) throw ArgumentError('durationDays harus lebih dari 0');
    if (quantity <= 0) throw ArgumentError('quantity harus lebih dari 0');
    equipment.reduceStock(quantity);
  }

  double calculateTotalCost({double discountPercentage = 0}) {
    final rawCost = equipment.pricePerDay * durationDays * quantity;
    return applyDiscount(rawCost, discountPercentage);
  }

  void returnEquipment(String? note) {
    if (status != RentalStatus.active) {
      throw InvalidReturnException(
        'Transaksi $transactionId tidak bisa dikembalikan: status saat ini ${status.name}',
      );
    }
    status = RentalStatus.returned;
    returnNote = note;
    equipment.restoreStock(quantity);
  }
}