import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';

class ErrorInfoCard extends StatelessWidget {
  final String message;

  const ErrorInfoCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.danger,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
