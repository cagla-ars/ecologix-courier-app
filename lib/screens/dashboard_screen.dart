import 'package:flutter/material.dart';
import '../models/shipment.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_route_card.dart';
import '../widgets/error_info_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/mini_stat_card.dart';
import '../widgets/mobile_top_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/today_task_banner.dart';

class DashboardScreen extends StatelessWidget {
  final String courierName;
  final String branchName;
  final String branchCity;
  final int todayDeliveredCount;
  final List<Shipment> shipments;
  final bool loading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;
  final void Function(Shipment shipment) onShipmentTap;

  const DashboardScreen({
    super.key,
    required this.courierName,
    required this.branchName,
    required this.branchCity,
    required this.todayDeliveredCount,
    required this.shipments,
    required this.loading,
    required this.errorMessage,
    required this.onRefresh,
    required this.onShipmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = shipments.length;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: MobileTopBar(
                title: 'Merhaba,',
                subtitle: courierName,
                icon: Icons.person_rounded,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Aktif',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: TodayTaskBanner(
                activeCount: activeCount,
                deliveredCount: todayDeliveredCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      title: 'Aktif',
                      value: '$activeCount',
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      title: 'Bugün',
                      value: '$todayDeliveredCount',
                      icon: Icons.check_circle_outline,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Sıradaki Görevler',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '$activeCount görev',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._taskSlivers(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  List<Widget> _taskSlivers() {
    if (loading) {
      return const [
        SliverToBoxAdapter(child: LoadingWidget(text: 'Aktif görevler alınıyor...')),
      ];
    }

    if (errorMessage != null) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ErrorInfoCard(message: errorMessage!),
          ),
        ),
      ];
    }

    if (shipments.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: EmptyRouteCard(message: 'Şu anda atanmış teslimat bulunmuyor.'),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final shipment = shipments[index];

              return TaskCard(
                shipment: shipment,
                index: index,
                onTap: () => onShipmentTap(shipment),
              );
            },
            childCount: shipments.length,
          ),
        ),
      ),
    ];
  }
}
