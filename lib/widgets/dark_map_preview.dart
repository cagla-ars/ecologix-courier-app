import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DarkMapPreview extends StatelessWidget {
  final int stopCount;

  const DarkMapPreview({
    super.key,
    required this.stopCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: BoxDecoration(
        color: const Color(0xFF101923),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: .70),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '$stopCount durak',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card.withValues(alpha: .92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.near_me_rounded, color: AppColors.primary, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Rota sırası teslimat listesine göre oluşturuldu',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: .045)
      ..strokeWidth = 1.2;

    for (double x = -40; x < size.width; x += 42) {
      canvas.drawLine(Offset(x, 0), Offset(x + 120, size.height), roadPaint);
    }

    for (double y = 20; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 40), roadPaint);
    }

    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * .20, size.height * .72)
      ..lineTo(size.width * .38, size.height * .54)
      ..lineTo(size.width * .56, size.height * .62)
      ..lineTo(size.width * .73, size.height * .35);

    canvas.drawPath(path, routePaint);

    final points = [
      Offset(size.width * .20, size.height * .72),
      Offset(size.width * .38, size.height * .54),
      Offset(size.width * .56, size.height * .62),
      Offset(size.width * .73, size.height * .35),
    ];

    final fill = Paint()..color = AppColors.primary;
    final border = Paint()
      ..color = const Color(0xFF101923)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 11, fill);
      canvas.drawCircle(points[i], 11, border);

      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, points[i] - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
