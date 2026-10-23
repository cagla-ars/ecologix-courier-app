import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/mobile_top_bar.dart';
import '../widgets/profile_action_tile.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String branchName;
  final String branchCity;
  final int activeDeliveryCount;
  final int todayDeliveredCount;
  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.branchName,
    required this.branchCity,
    required this.activeDeliveryCount,
    required this.todayDeliveredCount,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: MobileTopBar(
              title: 'Profil',
              subtitle: 'Kurye hesabı',
              icon: Icons.person_outline_rounded,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .14),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: .28)),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    branchName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _ProfileMetric(title: 'Aktif', value: '$activeDeliveryCount')),
                      const SizedBox(width: 10),
                      Expanded(child: _ProfileMetric(title: 'Bugün', value: '$todayDeliveredCount')),
                      const SizedBox(width: 10),
                      Expanded(child: _ProfileMetric(title: 'Şehir', value: branchCity)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ProfileActionTile(
              icon: Icons.lock_reset_outlined,
              title: 'Şifre Değiştir',
              subtitle: 'Hesap güvenliği',
              onTap: onChangePassword,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ProfileActionTile(
              icon: Icons.notifications_none_rounded,
              title: 'Bildirimler',
              subtitle: 'Teslimat uyarıları',
              onTap: () {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ProfileActionTile(
              icon: Icons.help_outline_rounded,
              title: 'Yardım ve Destek',
              subtitle: 'Destek merkezi',
              onTap: () {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ProfileActionTile(
              icon: Icons.logout_rounded,
              title: 'Çıkış Yap',
              subtitle: 'Oturumu sonlandır',
              danger: true,
              onTap: onLogout,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileMetric({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
