import 'package:flutter/material.dart';

import '../models/shipment.dart';
import '../models/route_summary.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../theme/app_colors.dart';
import '../widgets/courier_bottom_nav.dart';
import '../widgets/mobile_scaffold.dart';

import 'change_password_screen.dart';
import 'dashboard_screen.dart';
import 'delivery_detail_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'route_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService locationService = LocationService();

  List<Shipment> shipments = [];
  bool loading = true;
  String? errorMessage;
  int selectedIndex = 0;
  int todayDeliveredCount = 0;

  double? courierLat;
  double? courierLon;
  RouteSummary? routeSummary;

  int get courierId => widget.user['courierId'];
  String get courierName => widget.user['username'] ?? 'Kurye';
  String get branchName => widget.user['branchName'] ?? '-';
  String get branchCity => widget.user['branchCity'] ?? '-';

  List<Shipment> get sortedShipments {
    final list = [...shipments];

    list.sort((a, b) {
      final aIndex = a.deliveryIndex ?? 999;
      final bIndex = b.deliveryIndex ?? 999;
      return aIndex.compareTo(bIndex);
    });

    return list;
  }

  @override
  void initState() {
    super.initState();

    refreshData();

    locationService.startTracking(
      courierId: courierId,
      onLocationChanged: (position) {
        if (!mounted) return;

        setState(() {
          courierLat = position.latitude;
          courierLon = position.longitude;
        });
      },
    );
  }

  @override
  void dispose() {
    locationService.stopTracking();
    super.dispose();
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchActiveRoute(),
      fetchTodayDeliveredCount(),
    ]);
  }

  Future<void> fetchActiveRoute() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getActiveRoute(courierId);

      if (!mounted) return;

      setState(() {
        shipments = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> fetchTodayDeliveredCount() async {
    try {
      final count = await ApiService.getTodayDeliveredCount(courierId);

      if (!mounted) return;

      setState(() {
        todayDeliveredCount = count;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        todayDeliveredCount = 0;
      });
    }
  }

  Future<RouteSummary?> createOptimizedRoute() async {
    try {
      final summary = await ApiService.getOptimizedRoute(courierId);
      await refreshData();

      if (!mounted) return summary;

      setState(() {
        routeSummary = summary;
      });

      return summary;
    } catch (e) {
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.danger,
        ),
      );

      return null;
    }
  }

  Future<void> completeDelivery(Shipment shipment) async {
    try {
      await ApiService.deliverShipment(shipment.id);
      await refreshData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teslimat tamamlandı.'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void openShipmentDetail(Shipment shipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryDetailScreen(
          shipment: shipment,
          onDelivered: () => completeDelivery(shipment),
        ),
      ),
    );
  }

  void openChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangePasswordScreen(username: courierName),
      ),
    );
  }

  void logout() {
    locationService.stopTracking();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderedShipments = sortedShipments;

    final pages = <Widget>[
      DashboardScreen(
        courierName: courierName,
        branchName: branchName,
        branchCity: branchCity,
        todayDeliveredCount: todayDeliveredCount,
        shipments: orderedShipments,
        loading: loading,
        errorMessage: errorMessage,
        onRefresh: refreshData,
        onShipmentTap: openShipmentDetail,
      ),
      RouteScreen(
        shipments: orderedShipments,
        courierLat: courierLat,
        courierLon: courierLon,
        routeSummary: routeSummary,
        loading: loading,
        errorMessage: errorMessage,
        onRefresh: refreshData,
        onShipmentTap: openShipmentDetail,
        onDelivered: completeDelivery,
        onCreateRoute: createOptimizedRoute,
      ),
      ProfileScreen(
        username: courierName,
        branchName: branchName,
        branchCity: branchCity,
        activeDeliveryCount: orderedShipments.length,
        todayDeliveredCount: todayDeliveredCount,
        onChangePassword: openChangePassword,
        onLogout: logout,
      ),
    ];

    return MobileScaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CourierBottomNav(
        selectedIndex: selectedIndex,
        onChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}