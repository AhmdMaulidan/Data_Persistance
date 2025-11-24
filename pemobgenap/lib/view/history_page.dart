import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemobgenap/controller/bmi_controller.dart';
import 'package:pemobgenap/models/bmi_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BmiController controller = Get.find<BmiController>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text('No history yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            final BmiRecord record = controller.history[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: CircleAvatar(
                  backgroundColor: BmiCategory.getColor(record.category),
                  child: const Icon(Icons.monitor_weight, color: Colors.white),
                ),
                title: Text(
                  'BMI: ${record.bmi.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Category: ${record.category}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Text(record.formattedDate),
                onTap: () => Get.toNamed('/history/${index}'),
              ),
            );
          },
        );
      }),
    );
  }
}
