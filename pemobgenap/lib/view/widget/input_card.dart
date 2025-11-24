import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController heightController;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onHeightChanged;

  const InputCard({
    Key? key,
    required this.weightController,
    required this.heightController,
    required this.onWeightChanged,
    required this.onHeightChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Input Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: weightController,
              onChanged: onWeightChanged,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Berat Badan (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: heightController,
              onChanged: onHeightChanged,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tinggi Badan (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
