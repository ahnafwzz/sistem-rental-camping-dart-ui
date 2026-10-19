import 'package:flutter/material.dart';
import 'rental_store.dart';
import 'screens/home_screen.dart';

void main() {
  final store = RentalStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final RentalStore store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Camping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(store: store),
    );
  }
}