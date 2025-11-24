import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemobgenap/controller/bmi_controller.dart';
import 'package:pemobgenap/models/bmi_model.dart';

class DetailHistoryPage extends StatelessWidget {
  const DetailHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BmiController controller = Get.find<BmiController>();
    final int index = int.parse(Get.parameters['index']!);
    final BmiRecord record = controller.history[index];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Detail History'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${record.bmi.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: BmiCategory.getColor(record.category),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  record.category,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: BmiCategory.getColor(record.category),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                _buildDetailRow('Weight', '${record.weight} kg'),
                const SizedBox(height: 10),
                _buildDetailRow('Height', '${record.height} cm'),
                const SizedBox(height: 10),
                _buildDetailRow('Date', record.formattedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
