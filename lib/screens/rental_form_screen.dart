import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../rental_store.dart';
import '../models.dart';
import '../transaction.dart';
import '../exceptions.dart';
import '../utils.dart';
import '../widgets/equipment_card.dart';

class RentalFormScreen extends StatefulWidget {
  final RentalStore store;
  final Equipment equipment;

  const RentalFormScreen({
    super.key,
    required this.store,
    required this.equipment,
  });

  @override
  State<RentalFormScreen> createState() => _RentalFormScreenState();
}

class _RentalFormScreenState extends State<RentalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  int _quantity = 1;
  double _totalCost = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _recalculate() {
    final days = int.tryParse(_durationController.text) ?? 0;
    setState(() {
      _totalCost = widget.equipment.pricePerDay * days * _quantity;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final customer = Customer(
      id: 'C${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
    );

    try {
      final trx = RentalTransaction(
        transactionId: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
        customer: customer,
        equipment: widget.equipment,
        durationDays: int.parse(_durationController.text),
        quantity: _quantity,
      );
      widget.store.addTransaction(trx);
      if (mounted) Navigator.pop(context);
    } on OutOfStockException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Sewa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EquipmentCard(equipment: widget.equipment),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Penyewa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi Sewa (hari)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _recalculate(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Durasi tidak boleh kosong';
                  if ((int.tryParse(v) ?? 0) <= 0) return 'Durasi harus lebih dari 0 hari';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _quantity,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Unit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                items: List.generate(
                  widget.equipment.stock,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text('${i + 1} unit'),
                  ),
                ),
                onChanged: (v) {
                  if (v != null) {
                    _quantity = v;
                    _recalculate();
                  }
                },
                validator: (v) => v == null ? 'Pilih jumlah unit' : null,
              ),
              const SizedBox(height: 20),
              if (_totalCost > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimasi Total'),
                      Text(
                        'Rp ${formatRupiah(_totalCost)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Konfirmasi Sewa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}