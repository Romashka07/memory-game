import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/widgets/custom_button.dart';

void main() {
  void printTestState(String message, {Map<String, dynamic>? state}) {
    print('\n=== $message ===');
    if (state != null) {
      state.forEach((key, value) {
        print('$key: $value');
      });
    }
    print('================\n');
  }

  testWidgets('CustomButton UI properties are correct', (WidgetTester tester) async {
    print('\nTesting CustomButton UI properties...');
    
    // Тестовий текст для кнопки
    const testText = 'Test Button';
    printTestState('Test configuration', state: {
      'Button text': testText
    });
    
    print('Building test widget tree...');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CustomButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    print('Widget tree built successfully');

    // Перевіряємо чи текст кнопки відображається
    print('\nVerifying button text...');
    expect(find.text(testText), findsOneWidget);
    print('Button text verified');

    // Знаходимо віджет кнопки
    print('\nLocating button widget...');
    final buttonFinder = find.byType(ElevatedButton);
    final button = tester.widget<ElevatedButton>(buttonFinder);
    print('Button widget located');

    // Перевіряємо властивості кнопки
    print('\nVerifying button properties...');
    
    // Перевірка мінімального розміру
    print('Checking minimum size...');
    final minimumSize = button.style?.minimumSize?.resolve({});
    printTestState('Size verification', state: {
      'Actual height': minimumSize?.height,
      'Expected height': 50.0
    });
    expect(minimumSize?.height, equals(50.0));
    print('Minimum size verified');
    
    // Перевірка відступів
    print('\nChecking padding...');
    final padding = button.style?.padding?.resolve({}) as EdgeInsets?;
    printTestState('Padding verification', state: {
      'Left padding': padding?.left,
      'Right padding': padding?.right,
      'Expected padding': 20.0
    });
    expect(padding?.left, equals(20.0));
    expect(padding?.right, equals(20.0));
    print('Padding verified');
    
    // Перевірка кольору фону
    print('\nChecking background color...');
    final backgroundColor = button.style?.backgroundColor?.resolve({});
    printTestState('Color verification', state: {
      'Actual color': backgroundColor,
      'Expected color': Colors.green
    });
    expect(backgroundColor, equals(Colors.green));
    print('Background color verified');
    
    // Перевірка форми кнопки
    print('\nChecking button shape...');
    printTestState('Shape verification', state: {
      'Shape type': button.style?.shape.runtimeType
    });
    expect(button.style?.shape, isA<MaterialStateProperty<OutlinedBorder>>());
    print('Button shape verified');

    // Перевірка стилю тексту
    print('\nVerifying text style...');
    final textFinder = find.text(testText);
    final textWidget = tester.widget<Text>(textFinder);
    printTestState('Text style verification', state: {
      'Font size': textWidget.style?.fontSize,
      'Expected font size': 18.0,
      'Font weight': textWidget.style?.fontWeight,
      'Expected font weight': FontWeight.bold
    });
    expect(textWidget.style?.fontSize, equals(18.0));
    expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    print('Text style verified');

    print('\nAll CustomButton properties verified successfully');
  });
} 