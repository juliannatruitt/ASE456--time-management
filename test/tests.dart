import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_management_ase456/main.dart';

void main() {


  testWidgets('Widgets load on screen as expected', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('Time Management'), findsOneWidget);
    expect(find.textContaining('All Tasks'), findsOneWidget);
    expect(find.textContaining('REPORT'), findsOneWidget);
    expect(find.textContaining('PRIORITY'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('search button will redirect to a new page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining("Query Task"), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.textContaining("Query Task"), findsOneWidget);

  });

  testWidgets('Add button will redirect to a new page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining("Add Task"), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.textContaining("Add Task"), findsOneWidget);

  });

  testWidgets('Pressing report causes a pop up alert screen to display on the screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('REPORT'), findsOneWidget);
    expect(find.textContaining('REPORT DATES'), findsNothing);
    await tester.tap(find.textContaining('REPORT'));
    await tester.pumpAndSettle();
    expect(find.textContaining('REPORT DATES'), findsOneWidget);

  });

  testWidgets('Add a task with not all of the fields filled out will result in error alert box', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining("Add Task"), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.textContaining("Add Task"), findsOneWidget);
    expect(find.textContaining("Error"), findsNothing);
    expect(find.textContaining("submit"), findsOneWidget);
    await tester.tap(find.textContaining("submit"));
    await tester.pumpAndSettle();
    expect(find.textContaining("Error"), findsOneWidget);

  });

  testWidgets('ensure that you can select between date, description, and tag from the dropdown menu on the search page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining("Query Task"), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.textContaining("Query Task"), findsOneWidget);
    expect(find.textContaining("date"), findsOneWidget);

    await tester.tap(find.textContaining("date"));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining("description"));
    await tester.pumpAndSettle();
    expect(find.textContaining("date"), findsNothing);

    await tester.tap(find.textContaining("description"));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining("tag"));
    await tester.pumpAndSettle();
    expect(find.textContaining("description"), findsNothing);



  });


}



