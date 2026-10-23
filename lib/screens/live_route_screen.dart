import 'package:flutter/material.dart';

import '../models/shipment.dart';
import '../models/route_summary.dart';
import '../theme/app_colors.dart';
import '../widgets/route_map_card.dart';

class LiveRouteScreen extends StatefulWidget {
  final List<Shipment> shipments;
  final double? courierLat;
  final double? courierLon;
  final RouteSummary? routeSummary;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Shipment shipment) onDelivered;

  const LiveRouteScreen({
    super.key,
    required this.shipments,
    required this.courierLat,
    required this.courierLon,
    required this.routeSummary,
    required this.onRefresh,
    required this.onDelivered,
  });

  @override
  State<LiveRouteScreen> createState() => _LiveRouteScreenState();
}

class _LiveRouteScreenState extends State<LiveRouteScreen> {
  double routeDistanceKm = 0;
  int routeDurationMinutes = 0;
  late List<Shipment> activeShipments;

  @override
  void initState() {
    super.initState();
    activeShipments = List<Shipment>.from(widget.shipments);
  }

  Future<void> completeActiveShipment(Shipment shipment) async {
    await widget.onDelivered(shipment);

    if (!mounted) return;

    setState(() {
      activeShipments.removeWhere((item) => item.id == shipment.id);
      routeDistanceKm = 0;
      routeDurationMinutes = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Shipment? activeShipment =
        activeShipments.isEmpty ? null : activeShipments.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: RouteMapCard(
              shipments: activeShipment == null ? [] : [activeShipment],
              courierLat: widget.courierLat,
              courierLon: widget.courierLon,
              fullScreen: true,
              onRouteLoaded: (result) {
                if (!mounted) return;

                setState(() {
                  routeDistanceKm = result.distanceKm;
                  routeDurationMinutes = result.durationMinutes;
                });
              },
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            top: 44,
            child: Row(
              children: [
                _CircleButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Canlı Rota Takibi',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _BottomRoutePanel(
              shipment: activeShipment,
              distanceKm: routeDistanceKm,
              durationMinutes: routeDurationMinutes,
              onDelivered: activeShipment == null
                  ? null
                  : () => completeActiveShipment(activeShipment),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomRoutePanel extends StatelessWidget {
  final Shipment? shipment;
  final double distanceKm;
  final int durationMinutes;
  final Future<void> Function()? onDelivered;

  const _BottomRoutePanel({
    required this.shipment,
    required this.distanceKm,
    required this.durationMinutes,
    required this.onDelivered,
  });

  @override
  Widget build(BuildContext context) {
    if (shipment == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: .95),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'Aktif teslimat bulunmuyor.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final stopNumber = shipment!.deliveryIndex ?? 1;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .35),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: .45),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '$stopNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sıradaki teslimat',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shipment!.receiverName.isEmpty
                          ? 'Alıcı bilgisi yok'
                          : shipment!.receiverName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shipment!.deliveryAddress.isEmpty
                          ? 'Adres bilgisi yok'
                          : shipment!.deliveryAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _InfoChip(
                  icon: Icons.route_rounded,
                  value: distanceKm <= 0
                      ? 'Hesaplanıyor'
                      : '${distanceKm.toStringAsFixed(1)} km',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoChip(
                  icon: Icons.schedule_rounded,
                  value: durationMinutes <= 0
                      ? 'Hesaplanıyor'
                      : '$durationMinutes dk',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onDelivered,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Teslim Edildi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 17,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}