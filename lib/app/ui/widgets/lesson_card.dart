import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.title,
    this.subtitle = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: AppTextStyles.title),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        onTap: onTap,
      ),
    );
  }
}
