import 'package:flutter_test/flutter_test.dart';
import 'package:interval/app/app.dart';
import 'package:interval/src/home/views/pages/home_page.dart';

void main() {
  group('App', () {
    testWidgets('renders HomeView', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
