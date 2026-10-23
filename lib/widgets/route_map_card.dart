import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/shipment.dart';
import '../services/route_direction_service.dart';
import '../theme/app_colors.dart';

class RouteMapCard extends StatelessWidget {
  final List<Shipment> shipments;
  final double? courierLat;
  final double? courierLon;
  final bool fullScreen;
  final ValueChanged<RouteDirectionResult>? onRouteLoaded;

  const RouteMapCard({
    super.key,
    required this.shipments,
    required this.courierLat,
    required this.courierLon,
    this.fullScreen = false,
    this.onRouteLoaded,
  });

  bool get hasCourierLocation => courierLat != null && courierLon != null;

  @override
  Widget build(BuildContext context) {
    final validShipments = shipments
        .where((s) => s.lat != null && s.lon != null)
        .toList();

    final courierPoint =
        hasCourierLocation ? LatLng(courierLat!, courierLon!) : null;

    if (validShipments.isEmpty && courierPoint == null) {
      return Container(
        height: fullScreen ? double.infinity : 260,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: fullScreen ? BorderRadius.zero : BorderRadius.circular(24),
          border: fullScreen ? null : Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Rota veya kurye koordinatı bulunamadı',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final shipmentPoints =
        validShipments.map((s) => LatLng(s.lat!, s.lon!)).toList();

    final basePoints = [
      if (courierPoint != null) courierPoint,
      ...shipmentPoints,
    ];

    final initialCenter = courierPoint ?? shipmentPoints.first;

    return SizedBox(
      height: fullScreen ? double.infinity : 300,
      child: FutureBuilder<RouteDirectionResult>(
        future: RouteDirectionService.getRoute(points: basePoints),
        builder: (context, snapshot) {
          final routeResult =
              snapshot.data ?? RouteDirectionResult.fallback(basePoints);

          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onRouteLoaded?.call(routeResult);
            });
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  fullScreen ? BorderRadius.zero : BorderRadius.circular(24),
              border: fullScreen ? null : Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: fullScreen ? 16.5 : 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.cagla.ecologix',
                    ),

                    if (routeResult.points.length >= 2)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routeResult.points,
                            strokeWidth: fullScreen ? 8 : 5,
                            color: AppColors.primary,
                          ),
                        ],
                      ),

                    MarkerLayer(
                      markers: [
                        if (courierPoint != null)
                          Marker(
                            point: courierPoint,
                            width: fullScreen ? 56 : 48,
                            height: fullScreen ? 56 : 48,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blue.withValues(alpha: .35),
                                    blurRadius: 18,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.local_shipping_rounded,
                                color: Colors.white,
                                size: fullScreen ? 28 : 24,
                              ),
                            ),
                          ),

                        ...List.generate(
                          validShipments.length,
                          (index) {
                            final shipment = validShipments[index];
                            final stopNumber =
                                shipment.deliveryIndex ?? index + 1;

                            return Marker(
                              point: LatLng(
                                shipment.lat!,
                                shipment.lon!,
                              ),
                              width: fullScreen ? 50 : 42,
                              height: fullScreen ? 50 : 42,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: .28,
                                      ),
                                      blurRadius: 14,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$stopNumber',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fullScreen ? 16 : 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}