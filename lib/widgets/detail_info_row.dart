import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const DetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primary, size: 17),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 82,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.25),
            ),
          ),
        ],
      ),
    );
  }
}
