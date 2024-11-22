import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_management_ase456/main.dart';
import 'mocks.mocks.dart';

void main() {

 //late MockFirebaseFirestore mockFirestore;

 //setUp(() {
 //  mockFirestore = MockFirebaseFirestore();

 //  final mockCollection = MockCollectionReference<Map<String, dynamic>>();
 //  final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

 //  when(mockFirestore.collection('records')).thenReturn(mockCollection);

 //  when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

 //  when(mockQuerySnapshot.docs).thenReturn([]);
 //});

  testWidgets('Widgets load on screen as expected', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('All Tasks'), findsOneWidget);
    expect(find.textContaining('REPORT'), findsOneWidget);
    expect(find.textContaining('PRIORITY'), findsOneWidget);
    expect(find.textContaining('All Tasks'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('search button will redirect to a new page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.search), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    expect(find.textContaining("Query Task"), findsOneWidget);

  });
}
