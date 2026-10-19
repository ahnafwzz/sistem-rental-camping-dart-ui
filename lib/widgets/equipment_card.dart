import 'package:flutter/material.dart';
import '../models.dart';
import '../utils.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback? onTap;

  const EquipmentCard({super.key, required this.equipment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.backpack),
        title: Text(equipment.name),
        subtitle: Text('Rp ${formatRupiah(equipment.pricePerDay)}/hari'),
        trailing: Chip(
          label: Text('${equipment.stock} unit'),
          backgroundColor:
              equipment.stock > 0 ? Colors.green.shade100 : Colors.red.shade100,
        ),
        onTap: onTap,
      ),
    );
  }
}