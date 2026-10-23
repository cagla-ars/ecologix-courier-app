import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/mobile_scaffold.dart';
import '../widgets/mobile_top_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String username;

  const ChangePasswordScreen({
    super.key,
    required this.username,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;
  String? errorMessage;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> savePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => errorMessage = 'Tüm alanlar zorunludur.');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => errorMessage = 'Yeni şifreler eşleşmiyor.');
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      await ApiService.changePassword(
        username: widget.username,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifre başarıyla güncellendi.'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          MobileTopBar(
            title: 'Şifre Değiştir',
            subtitle: 'Hesap güvenliği',
            icon: Icons.lock_reset_outlined,
            onBack: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: oldPasswordController,
            hintText: 'Mevcut Şifre',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: newPasswordController,
            hintText: 'Yeni Şifre',
            icon: Icons.lock_reset_outlined,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: confirmPasswordController,
            hintText: 'Yeni Şifre Tekrar',
            icon: Icons.verified_user_outlined,
            obscureText: true,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.danger.withValues(alpha: .25)),
              ),
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 22),
          AppButton(
            text: loading ? 'Güncelleniyor...' : 'Şifreyi Güncelle',
            onPressed: loading ? null : savePassword,
            icon: Icons.save_outlined,
          ),
        ],
      ),
    );
  }
}
