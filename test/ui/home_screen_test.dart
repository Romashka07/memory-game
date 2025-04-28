import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/screens/home_screen.dart';
import 'package:memory_game/utils/sound_manager.dart';
import 'package:memory_game/blocks/home/home_state.dart';
import 'package:memory_game/widgets/custom_image_button.dart';
import 'package:mockito/mockito.dart';
import 'home_screen_test.mocks.dart';

void main() {
  late MockSoundManager mockSoundManager;
  late MockHomeState mockHomeState;

  void printTestState(String message, {Map<String, dynamic>? state}) {
    print('\n=== $message ===');
    if (state != null) {
      state.forEach((key, value) {
        print('$key: $value');
      });
    }
    print('================\n');
  }

  setUp(() {
    print('\nSetting up HomeScreen test environment...');
    mockSoundManager = MockSoundManager();
    mockHomeState = MockHomeState();
    
    // Setup default behavior for mocks
    when(mockHomeState.initializeAudio()).thenAnswer((_) async {});
    when(mockSoundManager.playSound(any)).thenAnswer((_) async {});
    print('Mock objects initialized and configured');
  });

  testWidgets('HomeScreen UI elements are correctly displayed', (WidgetTester tester) async {
    print('\nTesting HomeScreen UI elements...');
    
    // Set a fixed screen size
    tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    printTestState('Screen configuration', state: {
      'Width': 800,
      'Height': 1200,
      'Pixel ratio': 1.0
    });

    // Build our app and trigger a frame
    print('Building HomeScreen widget...');
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          key: const Key('home_screen'),
        ),
      ),
    );

    // Allow the layout to settle
    print('Waiting for layout to settle...');
    await tester.pumpAndSettle();

    print('\nVerifying UI elements...');
    // Verify the welcome text images are present
    print('Checking welcome text images...');
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/welcome_text.png"
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/welcome_text_2.png"
      ),
      findsOneWidget,
    );
    print('Welcome text images verified');

    // Verify the main buttons are present
    print('\nChecking main buttons...');
    printTestState('Button verification', state: {
      'Start button': 'Checking...',
      'Settings button': 'Checking...',
      'Achievements button': 'Checking...',
      'Exit button': 'Checking...',
      'Profile button': 'Checking...'
    });

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/start_button.png"
      ),
      findsOneWidget,
    );
    print('Start button found');

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/settings_button.png"
      ),
      findsOneWidget,
    );
    print('Settings button found');

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/achievements_button.png"
      ),
      findsOneWidget,
    );
    print('Achievements button found');

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && 
          (widget.image as AssetImage).assetName == "assets/images/exit_button.png"
      ),
      findsOneWidget,
    );
    print('Exit button found');

    expect(find.byIcon(Icons.person), findsOneWidget);
    print('Profile button found');

    // Verify the layout structure
    print('\nVerifying layout structure...');
    final welcomeTextFinder = find.byWidgetPredicate(
      (widget) => widget is Image && 
        (widget.image as AssetImage).assetName == "assets/images/welcome_text.png"
    );
    final startButtonFinder = find.byWidgetPredicate(
      (widget) => widget is Image && 
        (widget.image as AssetImage).assetName == "assets/images/start_button.png"
    );
    
    // Check if welcome text is at the top
    final welcomeTextPosition = tester.getTopLeft(welcomeTextFinder).dy;
    final startButtonPosition = tester.getTopLeft(startButtonFinder).dy;
    
    printTestState('Layout verification', state: {
      'Welcome text position': welcomeTextPosition,
      'Start button position': startButtonPosition,
      'Welcome text above start button': welcomeTextPosition < startButtonPosition
    });
    
    expect(
      welcomeTextPosition,
      lessThan(startButtonPosition),
    );
    print('Layout structure verified');

    // Reset the window to its original size
    print('\nResetting test environment...');
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    print('Test completed successfully');
  });
} 