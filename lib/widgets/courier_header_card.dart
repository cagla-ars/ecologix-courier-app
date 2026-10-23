import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class CourierHeaderCard extends StatelessWidget {
  final String courierName;
  final String branchName;

  const CourierHeaderCard({
    super.key,
    required this.courierName,
    required this.branchName,
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
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primary.withValues(alpha: .26)),
            ),
            child: const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kurye hesabı', style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  courierName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.apartment_outlined, color: AppColors.primary, size: 14),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        branchName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const StatusBadge(text: 'AKTİF'),
        ],
      ),
    );
  }
}
