import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MobileScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const MobileScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
  });

  static const double maxMobileWidth = 430;

  @override
  Widget build(BuildContext context) {
    final hasBottomNav = bottomNavigationBar != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.15,
            colors: [
              Color(0xFF07382F),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: maxMobileWidth,
                  height: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: hasBottomNav ? 92 : 0,
                    ),
                    child: body,
                  ),
                ),
              ),

              if (hasBottomNav)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      width: maxMobileWidth,
                      child: bottomNavigationBar!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}