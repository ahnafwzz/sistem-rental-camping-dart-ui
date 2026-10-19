import 'models.dart';
import 'transaction.dart';

class RentalStore {
  final List<Equipment> equipments = [
    Equipment(id: 'E01', name: 'Tenda Dome 4 Orang', pricePerDay: 50000, stock: 3),
    Equipment(id: 'E02', name: 'Sleeping Bag', pricePerDay: 20000, stock: 5),
    Equipment(id: 'E03', name: 'Kompor Portable', pricePerDay: 15000, stock: 4),
    Equipment(id: 'E04', name: 'Matras Lipat', pricePerDay: 10000, stock: 6),
  ];

  final List<RentalTransaction> transactions = [];

  void addTransaction(RentalTransaction trx) {
    transactions.add(trx);
  }
}