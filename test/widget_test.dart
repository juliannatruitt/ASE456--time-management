import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_management_ase456/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());


    expect(find.textContaining('Add Tasks'), findsOneWidget);

    //await tester.tap(find.textContaining('PRIORITY'));
    //await tester.pump();
//
    //expect(find.textContaining('Priority'), findsOneWidget);
    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byIcon(Icons.add));
    //await tester.pump();
//
    //// Verify that our counter has incremented.
    //expect(find.text('0'), findsNothing);
    //expect(find.text('1'), findsOneWidget);
  });
}
