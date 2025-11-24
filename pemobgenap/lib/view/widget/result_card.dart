import 'package:flutter/material.dart';
import 'package:pemobgenap/models/bmi_model.dart';

class ResultCard extends StatelessWidget {
  final double bmi;
  final String category;
  final double? previousBmi;

  const ResultCard({
    Key? key,
    required this.bmi,
    required this.category,
    this.previousBmi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bmi <= 0 || category.isEmpty) {
      return const SizedBox.shrink();
    }

    final Color color = BmiCategory.getColor(category);
    final String description = BmiCategory.getDescription(category);
    final double bmiChange = previousBmi != null ? bmi - previousBmi! : 0;

    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hasil BMI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (bmiChange != 0)
                  Icon(
                    bmiChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: bmiChange > 0 ? Colors.red : Colors.green,
                  ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
