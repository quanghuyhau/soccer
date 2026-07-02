import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soccer/src/app/app.dart';
import 'package:soccer/src/app/models/app_models.dart';
import 'package:soccer/src/features/home/home_controller.dart';

void main() {
  testWidgets('App renders clean architecture home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeControllerProvider.overrideWith((ref) async {
            return const SampleItem(id: 1, title: 'Mock item', completed: true);
          }),
        ],
        child: const SoccerApp(),
      ),
    );

    expect(find.text('Soccer'), findsOneWidget);
    expect(find.text('Clean Architecture Base'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Mock item'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });
}
