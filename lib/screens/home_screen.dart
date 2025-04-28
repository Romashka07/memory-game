import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/sound_manager.dart';
import '../blocks/home/home_state.dart';
import '../blocks/home/home_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _soundManager = SoundManager();
  final _homeState = HomeState();

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  @override
  void dispose() {
    _homeState.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    await _homeState.initializeAudio();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.12;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              HomeUI.buildTopBar(context, screenWidth, iconSize, _soundManager),
              Expanded(
                child: HomeUI.buildMainContent(context, _soundManager),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
