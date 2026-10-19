import 'package:flutter/material.dart';
import '../rental_store.dart';
import '../models.dart';
import '../transaction.dart';
import '../exceptions.dart';
import '../utils.dart';

class TransactionScreen extends StatefulWidget {
  final RentalStore store;
  const TransactionScreen({super.key, required this.store});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  void _returnItem(RentalTransaction trx) {
    try {
      trx.returnEquipment(null);
      setState(() {});
    } on InvalidReturnException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.store.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada transaksi',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final trx = transactions[index];
                final isActive = trx.status == RentalStatus.active;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trx.transactionId,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Chip(
                              label: Text(trx.status.name),
                              backgroundColor: isActive
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200,
                              labelStyle: TextStyle(
                                color: isActive
                                    ? Colors.blue.shade800
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          trx.equipment.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('Penyewa: ${trx.customer.name}'),
                        Text(
                          '${trx.durationDays} hari × ${trx.quantity} unit'
                          ' = Rp ${formatRupiah(trx.calculateTotalCost())}',
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _returnItem(trx),
                              icon: const Icon(Icons.keyboard_return, size: 16),
                              label: const Text('Kembalikan'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}