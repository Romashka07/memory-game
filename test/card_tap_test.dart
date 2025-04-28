import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:memory_game/models/card_item.dart';
import 'package:memory_game/use_cases/game/cards/handle_card_tap.dart';
import 'package:memory_game/utils/sound_manager.dart';

import 'card_tap_test.mocks.dart';

@GenerateMocks([SoundManager])
void main() {
  late HandleCardTapUseCase handleCardTapUseCase;
  late List<CardItem> cards;
  late MockSoundManager mockSoundManager;
  late int updateCallCount;
  late int scoreUpdateCount;
  late bool mistakeUpdateCalled;
  late bool levelCompleteCalled;

  void printCardState(List<CardItem> cards, String message) {
    print('\n=== $message ===');
    for (var i = 0; i < cards.length; i++) {
      print('Card $i: ${cards[i].imageAsset} - Flipped: ${cards[i].isFlipped}');
    }
    print('================\n');
  }

  setUp(() {
    print('\nSetting up new test...');
    handleCardTapUseCase = HandleCardTapUseCase();
    mockSoundManager = MockSoundManager();
    updateCallCount = 0;
    scoreUpdateCount = 0;
    mistakeUpdateCalled = false;
    levelCompleteCalled = false;

    // Створюємо тестові картки
    cards = [
      CardItem(id: 0, imageAsset: 'assets/images/game/heart_icon.png'),
      CardItem(id: 1, imageAsset: 'assets/images/game/heart_icon.png'),
      CardItem(id: 2, imageAsset: 'assets/images/game/star_icon.png'),
      CardItem(id: 3, imageAsset: 'assets/images/game/star_icon.png'),
    ];

    when(mockSoundManager.playClickSound()).thenAnswer((_) => Future.value());
    printCardState(cards, 'Initial Card State');
  });

  group('Card Tap Handling Tests', () {
    test('Tapping an unflipped card should flip it and set it as first card', () async {
      print('\nTesting first card flip...');
      final input = HandleCardTapInput(
        cards: cards,
        index: 0,
        firstCard: null,
        secondCard: null,
        isProcessing: false,
        onCardsUpdate: (updatedCards) {
          updateCallCount++;
          expect(updatedCards[0].isFlipped, true);
          print('Card update callback triggered');
          printCardState(updatedCards, 'Cards after update');
        },
        onScoreUpdate: (score) {
          scoreUpdateCount++;
          print('Score update triggered: $score');
        },
        onMistakeUpdate: (mistake) {
          mistakeUpdateCalled = true;
          print('Mistake update triggered');
        },
        onLevelComplete: () {
          levelCompleteCalled = true;
          print('Level complete triggered');
        },
        soundManager: mockSoundManager,
      );

      final result = await handleCardTapUseCase.execute(input);

      print('\nTest Results:');
      print('- First card flipped: ${result.updatedCards[0].isFlipped}');
      print('- Update calls: $updateCallCount');
      print('- Score updates: $scoreUpdateCount');
      print('- Mistakes recorded: $mistakeUpdateCalled');
      print('- Level completed: $levelCompleteCalled\n');

      expect(result.updatedCards[0].isFlipped, true);
      expect(result.newFirstCard, equals(cards[0]));
      expect(result.newSecondCard, isNull);
      expect(result.newIsProcessing, false);
      expect(updateCallCount, 1);
      expect(scoreUpdateCount, 0);
      expect(mistakeUpdateCalled, false);
      expect(levelCompleteCalled, false);
      verify(mockSoundManager.playClickSound()).called(1);
    });

    test('Card should not flip when game is processing', () async {
      print('\nTesting card flip during processing state...');
      final input = HandleCardTapInput(
        cards: cards,
        index: 0,
        firstCard: null,
        secondCard: null,
        isProcessing: true,
        onCardsUpdate: (updatedCards) {
          updateCallCount++;
          print('WARNING: Unexpected card update during processing');
        },
        onScoreUpdate: (score) {
          scoreUpdateCount++;
          print('WARNING: Unexpected score update during processing');
        },
        onMistakeUpdate: (mistake) {
          mistakeUpdateCalled = true;
          print('WARNING: Unexpected mistake update during processing');
        },
        onLevelComplete: () {
          levelCompleteCalled = true;
          print('WARNING: Unexpected level complete during processing');
        },
        soundManager: mockSoundManager,
      );

      final result = await handleCardTapUseCase.execute(input);

      print('\nTest Results:');
      print('- Card remained unflipped: ${!result.updatedCards[0].isFlipped}');
      print('- Processing state maintained: ${result.newIsProcessing}');
      print('- No callbacks triggered: ${updateCallCount == 0}\n');

      expect(result.updatedCards[0].isFlipped, false);
      expect(result.newFirstCard, isNull);
      expect(result.newSecondCard, isNull);
      expect(result.newIsProcessing, true);
      expect(updateCallCount, 0);
      expect(scoreUpdateCount, 0);
      expect(mistakeUpdateCalled, false);
      expect(levelCompleteCalled, false);
      verifyNever(mockSoundManager.playClickSound());
    });

    test('Already flipped card should not flip again', () async {
      print('\nTesting tap on already flipped card...');
      cards[0].isFlipped = true;
      printCardState(cards, 'Initial state with flipped card');
      
      final input = HandleCardTapInput(
        cards: cards,
        index: 0,
        firstCard: cards[0],
        secondCard: null,
        isProcessing: false,
        onCardsUpdate: (updatedCards) {
          updateCallCount++;
          print('WARNING: Unexpected card update for already flipped card');
        },
        onScoreUpdate: (score) {
          scoreUpdateCount++;
          print('WARNING: Unexpected score update for already flipped card');
        },
        onMistakeUpdate: (mistake) {
          mistakeUpdateCalled = true;
          print('WARNING: Unexpected mistake update for already flipped card');
        },
        onLevelComplete: () {
          levelCompleteCalled = true;
          print('WARNING: Unexpected level complete for already flipped card');
        },
        soundManager: mockSoundManager,
      );

      final result = await handleCardTapUseCase.execute(input);

      print('\nTest Results:');
      print('- Card remained flipped: ${result.updatedCards[0].isFlipped}');
      print('- No callbacks triggered: ${updateCallCount == 0}');
      print('- State remained unchanged\n');

      expect(result.updatedCards[0].isFlipped, true);
      expect(result.newFirstCard, equals(cards[0]));
      expect(result.newSecondCard, isNull);
      expect(result.newIsProcessing, false);
      expect(updateCallCount, 0);
      expect(scoreUpdateCount, 0);
      expect(mistakeUpdateCalled, false);
      expect(levelCompleteCalled, false);
      verifyNever(mockSoundManager.playClickSound());
    });
  });
} 