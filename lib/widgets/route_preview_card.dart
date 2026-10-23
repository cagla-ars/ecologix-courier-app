import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RoutePreviewCard extends StatelessWidget {
  final int stopCount;

  const RoutePreviewCard({
    super.key,
    required this.stopCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RoutePainter(),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Rota Önizleme',
              style: TextStyle(
                color: AppColors.textPrimary.withValues(alpha: .95),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '$stopCount teslimat noktası',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, color: AppColors.primary, size: 17),
                  SizedBox(width: 6),
                  Text(
                    'Harita',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: .35)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * .18, size.height * .72)
      ..lineTo(size.width * .38, size.height * .48)
      ..lineTo(size.width * .58, size.height * .62)
      ..lineTo(size.width * .78, size.height * .30);

    canvas.drawPath(path, routePaint);

    final pointPaint = Paint()..color = AppColors.primary;
    final borderPaint = Paint()
      ..color = AppColors.background
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(size.width * .18, size.height * .72),
      Offset(size.width * .38, size.height * .48),
      Offset(size.width * .58, size.height * .62),
      Offset(size.width * .78, size.height * .30),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 8, pointPaint);
      canvas.drawCircle(point, 8, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
