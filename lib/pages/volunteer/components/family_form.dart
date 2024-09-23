import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FamilyData {
  TextEditingController namaController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController posisiController = TextEditingController();
}

class FamilyForm extends StatelessWidget {
  final int index;
  final FamilyData data;
  final VoidCallback onRemove;

  const FamilyForm({
    super.key,
    required this.index,
    required this.data,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Anggota Keluarga ${index + 1}'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
            TextField(
              controller: data.namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: data.ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(labelText: 'Umur'),
            ),
            TextField(
              controller: data.posisiController,
              decoration: const InputDecoration(labelText: 'Posisi'),
            ),
          ],
        ),
      ),
    );
  }
}
