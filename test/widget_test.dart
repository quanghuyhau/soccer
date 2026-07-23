import 'package:flutter_test/flutter_test.dart';
import 'package:soccer/presentation/application/application.dart';

void main() {
  testWidgets('App renders auth screen', (tester) async {
    await tester.pumpWidget(const SoccerApp());

    expect(find.text('Đăng nhập'), findsWidgets);
    expect(find.text('Tạo tài khoản mới'), findsOneWidget);
  });
}
