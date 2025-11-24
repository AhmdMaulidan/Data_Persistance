import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemobgenap/controller/bmi_controller.dart';
import 'package:pemobgenap/view/widget/button_custom.dart';
import 'package:pemobgenap/view/widget/history_list.dart';
import 'package:pemobgenap/view/widget/input_card.dart';
import 'package:pemobgenap/view/widget/result_card.dart';

class BmiHomePage extends StatelessWidget {
  final BmiController controller = Get.put(BmiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Get.toNamed('/history'),
            tooltip: 'History',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputCard(
              weightController: controller.weightController,
              heightController: controller.heightController,
              onWeightChanged: controller.setWeight,
              onHeightChanged: controller.setHeight,
            ),
            SizedBox(height: 20),
            ButtonCustom(
              onPressed: controller.calculateBmi,
              label: 'HITUNG BMI',
            ),
            SizedBox(height: 20),
            ResultCard(
                bmi: controller.bmi.value,
                category: controller.category.value,
                previousBmi: controller.previousBmi.value,
              ),
            SizedBox(height: 20),
            HistoryList(
                history: controller.history,
                onClearHistory: controller.clearHistory,
              ),
          ],
        ),
      )),
    );
  }
}
