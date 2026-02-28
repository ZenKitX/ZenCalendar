import 'package:flutter_test/flutter_test.dart';
import 'package:zen_calendar/main.dart';

void main() {
  testWidgets('ZenCalendar smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZenCalendarApp());

    expect(find.text('ZenCalendar'), findsOneWidget);
  });
}
