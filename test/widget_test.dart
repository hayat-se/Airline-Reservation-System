import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:airline_reservation_system/main.dart';

void main() {
  testWidgets('Displays login screen when showHome is false', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(showHome: false));

    // Replace 'Login' with actual text or widget you expect on your login screen
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Displays flight search screen when showHome is true', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(showHome: true));

    // Replace 'Flight Search' or any widget/text you expect in your FlightSearchScreen
    expect(find.text('Flight Search'), findsOneWidget);
  });
}
