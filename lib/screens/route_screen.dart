import 'package:flutter/material.dart';

import '../models/shipment.dart';
import '../models/route_summary.dart';
import '../theme/app_colors.dart';

import '../widgets/active_delivery_card.dart';
import '../widgets/route_map_card.dart';
import '../widgets/empty_route_card.dart';
import '../widgets/error_info_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/mobile_top_bar.dart';
import '../widgets/task_card.dart';

import 'live_route_screen.dart';

class RouteScreen extends StatelessWidget {
  final List<Shipment> shipments;
  final double? courierLat;
  final double? courierLon;
  final RouteSummary? routeSummary;
  final bool loading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;
  final void Function(Shipment shipment) onShipmentTap;
  final Future<void> Function(Shipment shipment) onDelivered;
  final Future<RouteSummary?> Function() onCreateRoute;

  const RouteScreen({
    super.key,
    required this.shipments,
    required this.courierLat,
    required this.courierLon,
    required this.routeSummary,
    required this.loading,
    required this.errorMessage,
    required this.onRefresh,
    required this.onShipmentTap,
    required this.onDelivered,
    required this.onCreateRoute,
  });

  Future<void> openLiveRoute(BuildContext context) async {
    if (shipments.isEmpty) {
      final summary = await onCreateRoute();

      if (summary == null) return;

      await onRefresh();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rota oluşturuldu. Liste güncellendi.'),
          backgroundColor: AppColors.primary,
        ),
      );

      return;
    }

    final summary = routeSummary ?? await onCreateRoute();

    if (!context.mounted || summary == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveRouteScreen(
          shipments: shipments,
          courierLat: courierLat,
          courierLon: courierLon,
          routeSummary: summary,
          onRefresh: onRefresh,
          onDelivered: (shipment) async {
            await onDelivered(shipment);
            await onRefresh();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Shipment? nextShipment = shipments.isEmpty ? null : shipments.first;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: MobileTopBar(
                title: 'Rota',
                subtitle: 'Teslimat akış sırası',
                icon: Icons.route_outlined,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: ActiveDeliveryCard(
                shipment: nextShipment,
                onTap: nextShipment == null
                    ? null
                    : () => onShipmentTap(nextShipment),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : () => openLiveRoute(context),
                  icon: Icon(
                    shipments.isEmpty
                        ? Icons.auto_awesome_rounded
                        : Icons.navigation_rounded,
                  ),
                  label: Text(
                    shipments.isEmpty ? 'Rota Oluştur' : 'Rotayı Başlat',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: .35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: RouteMapCard(
                shipments: shipments,
                courierLat: courierLat,
                courierLon: courierLon,
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
                      'Rota Akışı',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${shipments.length} nokta',
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

          ..._routeSlivers(),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  List<Widget> _routeSlivers() {
    if (loading) {
      return const [
        SliverToBoxAdapter(
          child: LoadingWidget(
            text: 'Rota alınıyor...',
          ),
        ),
      ];
    }

    if (errorMessage != null) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ErrorInfoCard(
              message: errorMessage!,
            ),
          ),
        ),
      ];
    }

    if (shipments.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: EmptyRouteCard(
              message: 'Rota için atanmış teslimat bulunmuyor.',
            ),
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
              final stopNumber = shipment.deliveryIndex ?? index + 1;

              return TaskCard(
                shipment: shipment,
                index: index,
                badgeText: '$stopNumber. durak',
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