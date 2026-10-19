import 'package:flutter/material.dart';
import '../rental_store.dart';
import '../widgets/equipment_card.dart';
import 'rental_form_screen.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  final RentalStore store;
  const HomeScreen({super.key, required this.store});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Alat Camping'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Riwayat Transaksi',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionScreen(store: widget.store),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.store.equipments.length,
        itemBuilder: (context, index) {
          final equipment = widget.store.equipments[index];
          return EquipmentCard(
            equipment: equipment,
            onTap: equipment.stock > 0
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RentalFormScreen(
                          store: widget.store,
                          equipment: equipment,
                        ),
                      ),
                    );
                    setState(() {});
                  }
                : null,
          );
        },
      ),
    );
  }
}