import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p03_rental_camping/main.dart';
import 'package:p03_rental_camping/rental_store.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(store: RentalStore()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}