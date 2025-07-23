import 'package:flutter/material.dart';
import 'package:house_price_prediction/homepage.dart';
import 'package:house_price_prediction/predictionpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Price Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Add your preferred font
      ),
      routes: {
        '/': (context) => HomePage(),
        '/predict': (context) => PredictionPage(),
      },
      initialRoute: '/',
    );
  }
}