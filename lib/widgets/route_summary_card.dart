import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RouteSummaryCard extends StatelessWidget {
  final int activeDeliveryCount;
  final int todayDeliveredCount;
  final String branchCity;

  const RouteSummaryCard({
    super.key,
    required this.activeDeliveryCount,
    required this.todayDeliveredCount,
    required this.branchCity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetricCard(title: 'Aktif', value: '$activeDeliveryCount', icon: Icons.route_outlined, color: AppColors.primary)),
        const SizedBox(width: 8),
        Expanded(child: _MetricCard(title: 'Bugün', value: '$todayDeliveredCount', icon: Icons.check_circle_outline, color: AppColors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _MetricCard(title: 'Şube', value: branchCity.isEmpty ? '-' : branchCity, icon: Icons.apartment_outlined, color: AppColors.warning)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 17),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 16.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
