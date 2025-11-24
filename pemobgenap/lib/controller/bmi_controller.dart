import 'package:flutter/material.dart';
import 'package:pemobgenap/models/bmi_model.dart';
import 'package:get/get.dart';

class BmiController extends GetxController {
// Observable variables
  var weight = 0.0.obs;
  var height = 0.0.obs;
  var bmi = 0.0.obs;
  var previousBmi = 0.0.obs;
  var category =
      ''
          .obs;
  var history = <BmiRecord>[].obs;
// Text controllers for input fields
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  bool get canCalculate => weight.value > 0 && height.value > 0;
  void setWeight(String value) {
    weight.value = double.tryParse(value) ?? 0.0;
  }
  void setHeight(String value) {
    height.value = double.tryParse(value) ?? 0.0;
  }
  void calculateBmi() {
    if (!canCalculate) {
      Get.snackbar(
        'Error',
        'Masukkan berat dan tinggi badan yang valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (history.isNotEmpty) {
      previousBmi.value = history.first.bmi;
    } else {
      previousBmi.value = 0.0;
    }

// Konversi tinggi dari cm ke meter
    double heightInMeter = height.value / 100;
// Hitung BMI = berat (kg) / tinggi^2 (m)
    bmi.value = weight.value / (heightInMeter * heightInMeter);
    category.value = BmiCategory.getCategory(bmi.value);
    addToHistory();

    Get.snackbar(
      'Berhasil',
      'BMI berhasil dihitung!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  void addToHistory() {
    history.insert(
      0,
      BmiRecord(
        weight: weight.value,
        height: height.value,
        bmi: bmi.value,
        category: category.value,
        date: DateTime.now(),
      ),
    );
    if (history.length > 10) {
      history.removeLast();
    }
  }
// Method untuk reset
  void reset() {
    weight.value = 0.0;
    height.value = 0.0;
    bmi.value = 0.0;
    previousBmi.value = 0.0;
    category.value =
    '';
    weightController.clear();
    heightController.clear();
    Get.snackbar(
      'Reset',
      'Semua nilai telah direset',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  void clearHistory() {
    history.clear();
    Get.snackbar(
      'Hapus History',
      'Semua history telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  @override
  void onClose() {
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }
}
