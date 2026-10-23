import 'package:flutter/material.dart';
import '../models/shipment.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/mobile_scaffold.dart';
import '../widgets/mobile_top_bar.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback onDelivered;

  const DeliveryDetailScreen({
    super.key,
    required this.shipment,
    required this.onDelivered,
  });

  String getStatusText(String status) {
    switch (status) {
      case 'IN_TRANSIT':
        return 'Yolda';
      case 'PENDING':
        return 'Dağıtımda';
      case 'DELIVERED':
        return 'Teslim Edildi';
      case 'AT_BRANCH':
        return 'Şubede';
      default:
        return status.isEmpty ? 'Aktif' : status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stopNumber = shipment.deliveryIndex ?? 1;

    return MobileScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          MobileTopBar(
            title: 'Teslimat Detayı',
            subtitle: 'Durak $stopNumber',
            icon: Icons.inventory_2_outlined,
            onBack: () => Navigator.pop(context),
            trailing: _StatusPill(text: getStatusText(shipment.status)),
          ),
          const SizedBox(height: 20),
          _ReceiverCard(
            stopNumber: stopNumber,
            receiverName: shipment.receiverName,
            address: shipment.deliveryAddress,
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Paket Bilgileri',
            icon: Icons.inventory_2_outlined,
            children: [
              _InfoTile(label: 'Barkod', value: shipment.barcode, icon: Icons.qr_code_2_rounded),
              _InfoTile(label: 'Takip No', value: shipment.trackingNumber, icon: Icons.tag_outlined),
              _InfoTile(label: 'Gönderici', value: shipment.senderName, icon: Icons.person_outline_rounded),
              _InfoTile(label: 'Alıcı', value: shipment.receiverName, icon: Icons.person_pin_circle_outlined),
              _InfoTile(label: 'Kargo Türü', value: shipment.cargoType ?? '-', icon: Icons.category_outlined),
              _InfoTile(label: 'Ağırlık', value: shipment.weight == null ? '-' : '${shipment.weight} kg', icon: Icons.scale_outlined),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Teslimat Noktası',
            icon: Icons.location_on_outlined,
            children: [
              _AddressBox(
                address: shipment.deliveryAddress,
                lat: shipment.lat,
                lon: shipment.lon,
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppButton(
            text: 'Teslim Edildi',
            icon: Icons.check_circle_outline,
            onPressed: () {
              onDelivered();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            text: 'Sorun Bildir',
            icon: Icons.warning_amber_rounded,
            outlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sorun bildirimi sonraki aşamada eklenecek.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReceiverCard extends StatelessWidget {
  final int stopNumber;
  final String receiverName;
  final String address;

  const _ReceiverCard({
    required this.stopNumber,
    required this.receiverName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primary.withValues(alpha: .28)),
            ),
            child: Text(
              '$stopNumber',
              style: const TextStyle(
                color: AppColors.primary,
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
                  'Sıradaki Teslimat',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  receiverName.isEmpty ? 'Alıcı bilgisi yok' : receiverName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address.isEmpty ? 'Adres bilgisi yok' : address,
                  maxLines: 2,
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
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 4),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressBox extends StatelessWidget {
  final String address;
  final double? lat;
  final double? lon;

  const _AddressBox({
    required this.address,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context) {
    final coordinateText = lat == null || lon == null ? 'Koordinat bilgisi bulunmuyor' : '$lat, $lon';

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.isEmpty ? 'Adres bilgisi yok' : address,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: .70),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    coordinateText,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: .25)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
