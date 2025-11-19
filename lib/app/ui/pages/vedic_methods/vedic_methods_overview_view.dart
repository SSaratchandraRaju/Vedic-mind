import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/vedic_method_models.dart';
import '../../../data/vedic_methods_data.dart';
import '../../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class VedicMethodsOverviewView extends StatelessWidget {
  const VedicMethodsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = getVedicMethodCategories();
    
    // Calculate overall progress
    int totalMethods = 0;
    int completedMethods = 0;
    
    for (var category in categories) {
      totalMethods += category.methods.length;
      completedMethods += category.methods.where((m) => m.isCompleted).length;
    }
    
    final progressPercentage = totalMethods > 0 
        ? ((completedMethods / totalMethods) * 100).toInt() 
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Vedic Methods',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          value: progressPercentage / 100,
                          strokeWidth: 3,
                          backgroundColor: AppColors.gray200,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$progressPercentage%',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategorySection(categories[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(VedicMethodCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(int.parse(category.color)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                category.name,
                style: AppTextStyles.h5.copyWith(
                  color: Color(int.parse(category.color)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Methods List
          ...category.methods.map((method) => _buildMethodCard(method)),
        ],
      ),
    );
  }

  Widget _buildMethodCard(VedicMethod method) {
    Widget statusIcon;
    String statusText;
    
    if (method.isCompleted) {
      statusIcon = const Icon(Icons.check_circle, color: AppColors.success, size: 20);
      statusText = '';
    } else if (method.isOngoing) {
      statusIcon = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Ongoing',
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      statusText = 'Ongoing';
    } else {
      statusIcon = const Icon(Icons.lock, color: AppColors.gray400, size: 20);
      statusText = '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: method.isLocked ? null : () {
          Get.toNamed(Routes.METHOD_DETAIL, arguments: method);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: method.isLocked 
                ? AppColors.gray50 
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: method.isLocked 
                  ? AppColors.gray200 
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              statusIcon,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: method.isLocked 
                            ? AppColors.gray400 
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (statusText.isNotEmpty && !method.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
