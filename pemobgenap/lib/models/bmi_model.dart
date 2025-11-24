import 'package:flutter/material.dart';

class BmiRecord {
  final double weight;
  final double height;
  final double bmi;
  final String category;
  final DateTime date;
  BmiRecord({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.date,
  });
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
class BmiCategory {
  static const String underweight = 'Underweight';
  static const String normal = 'Normal';
  static const String overweight = 'Overweight';

  static const String obese = 'Obese';
  static String getCategory(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25) return normal;
    if (bmi < 30) return overweight;
    return obese;
  }
  static String getDescription(String category) {
    switch (category) {
      case underweight:
        return 'Berat badan Anda kurang. Sebaiknya konsultasi dengan ahli gizi.';
      case normal:
        return 'Berat badan Anda ideal. Pertahankan pola hidup sehat!';
      case overweight:
        return 'Berat badan Anda berlebih. Mulai program diet dan olahraga.';
      case obese:
        return 'Obesitas. Sangat disarankan konsultasi dengan dokter.';
      default:
        return '';
    }
  }
  static Color getColor(String category) {
    switch (category) {
      case underweight:
        return Colors.blue;
      case normal:
        return Colors.green;
      case overweight:
        return Colors.orange;
      case obese:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}