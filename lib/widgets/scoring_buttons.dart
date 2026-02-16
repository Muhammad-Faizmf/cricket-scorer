import 'package:flutter/material.dart';
import '../models/ball.dart';
import '../core/app_colors.dart';

class ScoringButtons extends StatelessWidget {
  final bool isMatchOver;
  final ValueChanged<Ball> onAddBall;
  final VoidCallback onWicket;
  final VoidCallback onWide;
  final VoidCallback onNoBall;
  final VoidCallback onUndo;
  final VoidCallback onSwipe;
  final VoidCallback onStats;

  const ScoringButtons({
    super.key,
    required this.isMatchOver,
    required this.onAddBall,
    required this.onWicket,
    required this.onWide,
    required this.onNoBall,
    required this.onUndo,
    required this.onSwipe,
    required this.onStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black26,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [0, 1, 2, 3, 4, 5, 6]
                .map(
                  (r) => _RunButton(
                    runs: r,
                    disabled: isMatchOver,
                    onTap: () => onAddBall(Ball(runs: r, batsmanRuns: r)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                label: 'Wicket',
                icon: Icons.block,
                color: Colors.red,
                onTap: isMatchOver ? () {} : onWicket,
              ),
              _ActionButton(
                label: 'Wide',
                icon: Icons.remove_circle_outline,
                color: Colors.orange,
                onTap: isMatchOver ? () {} : onWide,
              ),
              _ActionButton(
                label: 'NB',
                icon: Icons.add_circle_outline,
                color: Colors.amber,
                onTap: isMatchOver ? () {} : onNoBall,
              ),
              _ActionButton(
                label: 'Undo',
                icon: Icons.undo,
                color: Colors.blue,
                onTap: isMatchOver ? () {} : onUndo,
              ),
              _ActionButton(
                label: 'Swipe',
                icon: Icons.swap_horiz,
                color: Colors.teal,
                onTap: isMatchOver ? () {} : onSwipe,
              ),
              _StatsButton(onTap: onStats),
            ],
          ),
        ],
      ),
    );
  }
}

class _RunButton extends StatelessWidget {
  final int runs;
  final bool disabled;
  final VoidCallback onTap;

  const _RunButton({
    required this.runs,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = runs == 0
        ? Colors.grey
        : runs == 4
            ? Colors.orange
            : runs == 6
                ? Colors.green
                : AppColors.ball1to5;
    return Material(
      color: color.withValues(alpha: disabled ? 0.5 : 1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 44,
          child: Center(
            child: Text(
              '$runs',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: color),
        ),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}

class _StatsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StatsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.query_stats, color: Colors.white),
        ),
        Text('Stats', style: TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
