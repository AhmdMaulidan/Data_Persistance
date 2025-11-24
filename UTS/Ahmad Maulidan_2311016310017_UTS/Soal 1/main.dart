import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BMICalculatorScreen()
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _bmiResult = '';
  String _bmiStatus = '';
  String _imageAsset = '';
  final List<String> _history = [];

  void _calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double height = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      final double heightInMeters = height / 100;
      final double bmi = weight / (heightInMeters * heightInMeters);

      setState(() {
        _bmiResult = bmi.toStringAsFixed(1);
        if (bmi < 18.5) {
          _bmiStatus = 'Underweight';
          _imageAsset = 'assets/images/underweight.png';
        } else if (bmi >= 18.5 && bmi <= 22.9) {
          _bmiStatus = 'Normal/Ideal';
          _imageAsset = 'assets/images/normal.png';
        } else if (bmi >= 23.0 && bmi <= 24.9) {
          _bmiStatus = 'Overweight';
          _imageAsset = 'assets/images/overweight.png';
        } else if (bmi >= 25.0 && bmi <= 29.9) {
          _bmiStatus = 'Obesitas 1';
          _imageAsset = 'assets/images/obesitas1.png';
        } else {
          _bmiStatus = 'Obesitas 2';
          _imageAsset = 'assets/images/obesitas2.png';
        }
        _history.add('BMI: $_bmiResult ($_bmiStatus)');
      });
    } else {
      setState(() {
        _bmiResult = '';
        _bmiStatus = '';
        _imageAsset = '';
      });
    }
  }

  void _clearAll() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = '';
      _bmiStatus = '';
      _imageAsset = '';
      _history.clear();
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Berat Badan (kg)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tinggi Badan (cm)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: _imageAsset.isNotEmpty
                      ? Image.asset(_imageAsset)
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    child: const Text('Hitung'),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearAll,
                  child: const Text('Bersihkan'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(_history[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
