import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _FaceFiltersAppState createState() => _FaceFiltersAppState();
}

class _FaceFiltersAppState extends State<Home> {
  late DeepArController _deeparController;
  bool _isInitialized = false;
  int _currentFilterIndex = 0;
  List<String> _filterPaths = [
    'assets/glasses1.deepar',
    'assets/glasses2.deepar',
    'assets/glasses3.deepar',
    'assets/glasses4.deepar',
    'assets/glasses5.deepar',
    'assets/glasses6.deepar',
    'assets/glasses7.deepar',
    'assets/glasses8.deepar',
  ];

  @override
  void initState() {
    super.initState();
    initializeDeepAR();
  }

  Future<void> initializeDeepAR() async {
    _deeparController = DeepArController();
    await _deeparController.initialize(
      androidLicenseKey: "d7b6875bcf3750b0714bf6820ed029430629763005be8a68ad3423c6291798c02e99a2e118097116",
      iosLicenseKey: "22d6f32635962333a8a5fb653f1e5baff3e5eb74f0defe1557955045f0f995271f57d00dedc5ec52",
      resolution: Resolution.high,
    );
    setState(() {
      _isInitialized = true;
    });
  }

  void switchToPreviousFilter() {
    if (_isInitialized) {
      setState(() {
        _currentFilterIndex = (_currentFilterIndex - 1).clamp(0, _filterPaths.length - 1);
      });
      switchFilter();
    }
  }

  void switchToNextFilter() {
    if (_isInitialized) {
      setState(() {
        _currentFilterIndex = (_currentFilterIndex + 1) % _filterPaths.length;
      });
      switchFilter();
    }
  }

  void switchFilter() {
    _deeparController.switchEffect(_filterPaths[_currentFilterIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Face Filters App'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isInitialized
                    ? DeepArPreview(_deeparController)
                    : const Center(
                  child: Text("Loading Preview"),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: switchToPreviousFilter,
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: switchToNextFilter,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
