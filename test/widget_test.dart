import 'package:bipolaris/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('offers to create a private expense reflection journal', (tester) async {
    await tester.pumpWidget(const BipolarisApp());
    await tester.pumpAndSettle();

    expect(find.text('Bipolaris'), findsOneWidget);
    expect(find.text('Criar diário protegido'), findsOneWidget);
    expect(find.textContaining('somente neste dispositivo'), findsOneWidget);
    expect(find.textContaining('sem diagnóstico'), findsOneWidget);
  });
}
