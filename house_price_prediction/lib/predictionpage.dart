import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:house_price_prediction/api_sevices.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'longitude': null,
    'latitude': null,
    'housing_median_age': null,
    'total_rooms': null,
    'total_bedrooms': null,
    'population': null,
    'households': null,
    'median_income': null,
    'ocean_proximity': 'INLAND',
  };

  bool _isLoading = false;
  String? _prediction;
  bool _showValidationErrors = false;

  final List<String> _oceanProximityOptions = [
    'INLAND',
    'NEAR BAY',
    'NEAR OCEAN',
    '<1H OCEAN',
    'ISLAND'
  ];

  Future<void> _predictPrice() async {
    setState(() => _showValidationErrors = true);
    
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please fix all validation errors',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _prediction = null;
    });

    try {
      final response = await ApiService.predictPrice(_formData);
      setState(() {
        _prediction = '\$${response['prediction']?.toStringAsFixed(2)}';
        _showValidationErrors = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Prediction failed: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House Price Prediction'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _showValidationErrors 
              ? AutovalidateMode.always 
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Enter Property Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildNumberField('Longitude', 'longitude', -180, 180),
                      _buildNumberField('Latitude', 'latitude', -90, 90),
                      _buildNumberField('House Median Age (years)', 'housing_median_age', 0, 100),
                      _buildNumberField('Total Rooms', 'total_rooms', 1, double.infinity),
                      _buildNumberField('Total Bedrooms', 'total_bedrooms', 1, double.infinity),
                      _buildNumberField('Population', 'population', 1, double.infinity),
                      _buildNumberField('Households', 'households', 1, double.infinity),
                      _buildNumberField('Median Income (tens of thousands)', 'median_income', 0, double.infinity),
                      _buildDropdownField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _predictPrice,
                      child: const Text(
                        'Predict Price',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
              if (_prediction != null) ...[
                const SizedBox(height: 25),
                Card(
                  color: Colors.green.shade50,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Predicted Price:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _prediction!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, String field, double min, double max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required field';
          final numValue = double.tryParse(value);
          if (numValue == null) return 'Enter a valid number';
          if (numValue < min) return 'Minimum value: $min';
          if (numValue > max) return 'Maximum value: $max';
          return null;
        },
        onSaved: (value) => _formData[field] = double.parse(value!),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _formData['ocean_proximity'],
      decoration: InputDecoration(
        labelText: 'Ocean Proximity',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _oceanProximityOptions
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (value) => _formData['ocean_proximity'] = value,
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }
}