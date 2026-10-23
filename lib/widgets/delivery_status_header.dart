import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class DeliveryStatusHeader extends StatelessWidget {
  final int stopNumber;
  final String receiverName;
  final String statusText;

  const DeliveryStatusHeader({
    super.key,
    required this.stopNumber,
    required this.receiverName,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: .32)),
            ),
            child: Text('$stopNumber', style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Teslimat noktası', style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  receiverName.isEmpty ? 'Alıcı bilgisi yok' : receiverName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          StatusBadge(text: statusText),
        ],
      ),
    );
  }
}
