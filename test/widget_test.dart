import 'package:flutter_test/flutter_test.dart';
import 'package:mbanking/app/mobile_banking_app.dart';

void main() {
  testWidgets('shows login page as the initial screen', (tester) async {
    await tester.pumpWidget(const MobileBankingApp());

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Enter User ID'), findsOneWidget);
  });
}
