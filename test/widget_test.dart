import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soccer/src/app/app.dart';

void main() {
  testWidgets('App renders auth screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SoccerApp()));

    expect(find.text('Pitch Manager'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Tạo tài khoản mới'), findsOneWidget);
  });
}
