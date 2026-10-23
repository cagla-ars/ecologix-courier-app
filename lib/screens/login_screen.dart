import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/mobile_scaffold.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool loading = false;
  String? errorMessage;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Kullanıcı adı ve şifre zorunludur.');
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final user = await ApiService.login(
        username: username,
        password: password,
      );

      if (!mounted) return;

//homescreene geçiş
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: user),
        ),
      );
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
        padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
        children: [
          const SizedBox(height: 18),
          const Text('🌱', textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
          const SizedBox(height: 10),
          const Text(
            'EcoLogix',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'KURYE UYGULAMASI',
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 2,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 34),
          const Text(
            'Kurye hesabınızla giriş yapın.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 28),
          AppTextField(
            controller: usernameController,
            hintText: 'Kullanıcı Adı',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: passwordController,
            hintText: 'Şifre',
            icon: Icons.lock_outline,
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(
                hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
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
          const SizedBox(height: 20),
          AppButton(
            text: loading ? 'Giriş Yapılıyor...' : 'Giriş Yap',
            onPressed: loading ? null : login,
          ),
          const SizedBox(height: 34),
          const Text(
            'Kurye hesabı, yönetici panelinde oluşturulan kurye kaydına bağlı olmalıdır.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
