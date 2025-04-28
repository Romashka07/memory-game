import 'package:flutter/material.dart';
import '../utils/sound_manager.dart';

class CustomHintButton extends StatefulWidget {
  final IconData icon;
  final String cost;
  final bool canUse;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;

  const CustomHintButton({
    super.key,
    required this.icon,
    required this.cost,
    required this.canUse,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF6FA1FF),
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  _CustomHintButtonState createState() => _CustomHintButtonState();
}

class _CustomHintButtonState extends State<CustomHintButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _darkeningAnimation;
  final _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _darkeningAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.3),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutQuad),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleTapDown(TapDownDetails details) async {
    if (widget.canUse) {
      _animationController.forward();
    }
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    if (widget.canUse) {
      _animationController.reverse();
      await _soundManager.playClickSound();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    if (widget.canUse) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.canUse ? widget.backgroundColor : widget.backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.borderColor,
                  width: widget.borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 24),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            widget.cost,
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
                  if (widget.canUse)
                    AnimatedBuilder(
                      animation: _darkeningAnimation,
                      builder: (context, child) {
                        return Container(
                          color: Colors.black.withOpacity(_darkeningAnimation.value),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 