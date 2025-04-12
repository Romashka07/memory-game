import 'package:flutter/material.dart';
import '../../base_use_case.dart';
import '../../../models/card_item.dart';
import '../../../widgets/custom_image_button.dart';
import '../../../widgets/game_over_dialog.dart';
import '../../../widgets/level_complete_dialog.dart';
import '../../../widgets/game_menu_dialog.dart';
import '../../../screens/game_screen.dart';

class BuildGameUIInput {
  final double screenWidth;
  final List<CardItem> cards;
  final Function(int) onCardTap;
  final Function() onMenuTap;
  final int diamonds;
  final int level;
  final String timeText;
  final bool isTimerFrozen;
  final String freezeTimeText;
  final Function() onPairHint;
  final Function() onFreezeHint;
  final Function() onShowAllHint;
  final bool canUsePairHint;
  final bool canUseFreezeHint;
  final bool canUseShowAllHint;

  BuildGameUIInput({
    required this.screenWidth,
    required this.cards,
    required this.onCardTap,
    required this.onMenuTap,
    required this.diamonds,
    required this.level,
    required this.timeText,
    required this.isTimerFrozen,
    required this.freezeTimeText,
    required this.onPairHint,
    required this.onFreezeHint,
    required this.onShowAllHint,
    required this.canUsePairHint,
    required this.canUseFreezeHint,
    required this.canUseShowAllHint,
  });
}

class BuildGameUIOutput {
  final Widget topPanel;
  final Widget gameField;
  final Widget freezeIndicator;
  final Widget hintsPanel;

  BuildGameUIOutput({
    required this.topPanel,
    required this.gameField,
    required this.freezeIndicator,
    required this.hintsPanel,
  });
}

class BuildGameUIUseCase implements BaseUseCase<BuildGameUIInput, BuildGameUIOutput> {
  @override
  Future<BuildGameUIOutput> execute(BuildGameUIInput input) async {
    return BuildGameUIOutput(
      topPanel: _buildTopPanel(input),
      gameField: _buildGameField(input),
      freezeIndicator: _buildFreezeIndicator(input),
      hintsPanel: _buildHintsPanel(input),
    );
  }

  Widget _buildTopPanel(BuildGameUIInput input) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.black, size: input.screenWidth * 0.12),
                    onPressed: input.onMenuTap,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.2),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        input.diamonds.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'IrishGrover',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.diamond,
                        color: Colors.orange,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/level_text.png',
                      height: 60,
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/number_${_getLevelNumberText(input.level)}.png',
                      height: 60,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 65,
                        alignment: Alignment.center,
                        child: Text(
                          input.timeText,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'IrishGrover',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameField(BuildGameUIInput input) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: input.cards.length,
          itemBuilder: (context, index) {
            return _buildCard(input, index);
          },
        ),
      ),
    );
  }

  Widget _buildFreezeIndicator(BuildGameUIInput input) {
    if (!input.isTimerFrozen) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.hourglass_top,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Frozen: ${input.freezeTimeText}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'IrishGrover',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintsPanel(BuildGameUIInput input) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildHintButton(Icons.filter_2, '5', input.canUsePairHint, input.onPairHint),
          _buildHintButton(Icons.hourglass_top, '10', input.canUseFreezeHint, input.onFreezeHint),
          _buildHintButton(Icons.remove_red_eye, '20', input.canUseShowAllHint, input.onShowAllHint),
        ],
      ),
    );
  }

  Widget _buildCard(BuildGameUIInput input, int index) {
    final card = input.cards[index];
    return GestureDetector(
      onTap: () => input.onCardTap(index),
      child: TweenAnimationBuilder(
        tween: Tween<double>(
          begin: 0,
          end: card.isFlipped || card.isMatched ? 180 : 0,
        ),
        duration: const Duration(milliseconds: 300),
        builder: (context, double rotation, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation * 3.1415927 / 180),
            alignment: Alignment.center,
            child: rotation < 90
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.question_mark, size: 40, color: Colors.white),
                  )
                : Transform(
                    transform: Matrix4.identity()..rotateY(3.1415927),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          card.imageAsset,
                          key: ValueKey<bool>(card.isFlipped),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildHintButton(IconData icon, String cost, bool canUse, Function() onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: canUse ? const Color(0xFF6FA1FF) : const Color(0xFF6FA1FF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: canUse ? onPressed : null,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 4),
            Row(
              children: [
                Text(
                  cost,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'IrishGrover',
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.diamond, color: Colors.yellow, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelNumberText(int level) {
    switch (level) {
      case 1:
        return 'one';
      case 2:
        return 'two';
      case 3:
        return 'three';
      case 4:
        return 'four';
      case 5:
        return 'five';
      case 6:
        return 'six';
      case 7:
        return 'seven';
      case 8:
        return 'eight';
      case 9:
        return 'nine';
      default:
        return 'one';
    }
  }
} 