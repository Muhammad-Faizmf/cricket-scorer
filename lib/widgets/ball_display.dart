import 'package:flutter/material.dart';
import '../models/ball.dart';
import '../core/app_colors.dart';

class BallDisplay extends StatelessWidget {
  final Ball ball;
  final double size;
  final double fontSize;
  final bool withBorder;

  const BallDisplay({
    super.key,
    required this.ball,
    this.size = 28,
    this.fontSize = 12,
    this.withBorder = false,
  });

  static Color ballColor(Ball b) {
    if (b.isWicket) return Colors.red;
    if (b.runs == 6) return Colors.green;
    if (b.runs == 4) return Colors.orange;
    if ([1, 2, 3, 5].contains(b.runs)) return AppColors.ball1to5;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ballColor(ball),
        shape: BoxShape.circle,
        border: withBorder ? Border.all(color: Colors.white54) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        ball.displaySymbol,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
