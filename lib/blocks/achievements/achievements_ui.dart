import 'package:flutter/material.dart';
import 'achievements_state.dart';

class AchievementsUI {
  static Widget buildAchievementItem(String title, String progress, double value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade200.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blue.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'IrishGrover',
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue.shade400,
                    width: 1,
                  ),
                ),
                child: Text(
                  progress,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'IrishGrover',
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildAchievementsList(AchievementsState state) {
    return RawScrollbar(
      thumbColor: Colors.orange.withOpacity(0.7),
      radius: const Radius.circular(20),
      thickness: 6,
      thumbVisibility: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          buildAchievementItem(
            'Complete the level\nwithout any mistakes',
            '${state.perfectLevelsCount}/1',
            state.perfectLevelsCount.toDouble(),
          ),
          buildAchievementItem(
            'Complete 3 levels\nwithout using hints',
            '${state.levelsWithoutHintsCount}/3',
            state.levelsWithoutHintsCount / 3,
          ),
          buildAchievementItem(
            'Complete all 9 levels',
            '${state.totalLevelsCompleted}/9',
            state.totalLevelsCompleted / 9,
          ),
          buildAchievementItem(
            'Use all hints in one level',
            '${state.strategistLevelsCount}/1',
            state.strategistLevelsCount.toDouble(),
          ),
          buildAchievementItem(
            'Use freeze timer when less than 10 seconds left',
            '${state.timingMasterLevelsCount}/1',
            state.timingMasterLevelsCount.toDouble(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
} 