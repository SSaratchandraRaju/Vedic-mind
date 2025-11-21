import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';

class PracticeGamesView extends StatelessWidget {
  const PracticeGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'id': 1,
        'name': 'Ekadhikena Purvena',
        'description': 'By one more than the previous one',
        'route': Routes.SUTRA1_GAME,
        'icon': Icons.looks_one,
      },
      {
        'id': 2,
        'name': 'Nikhilam Navatashcaramam Dashatah',
        'description': 'All from 9 and last from 10',
        'route': Routes.SUTRA2_GAME,
        'icon': Icons.looks_two,
      },
      {
        'id': 3,
        'name': 'Urdhva-Tiryagbhyam',
        'description': 'Vertically and crosswise',
        'route': Routes.SUTRA3_GAME,
        'icon': Icons.looks_3,
      },
      {
        'id': 4,
        'name': 'Paravartya Yojayet',
        'description': 'Transpose and adjust',
        'route': Routes.SUTRA4_GAME,
        'icon': Icons.looks_4,
      },
      {
        'id': 5,
        'name': 'Shunyam Saamyasamuccaye',
        'description': 'When the sum is the same that sum is zero',
        'route': Routes.SUTRA5_GAME,
        'icon': Icons.looks_5,
      },
      {
        'id': 6,
        'name': 'Anurupye Shunyamanyat',
        'description': 'If one is in ratio, the other is zero',
        'route': Routes.SUTRA6_GAME,
        'icon': Icons.looks_6,
      },
      {
        'id': 7,
        'name': 'Sankalana-vyavakalanabhyam',
        'description': 'By addition and by subtraction',
        'route': Routes.SUTRA7_GAME,
        'icon': Icons.filter_7,
      },
      {
        'id': 8,
        'name': 'Puranapuranabhyam',
        'description': 'By the completion or non-completion',
        'route': Routes.SUTRA8_GAME,
        'icon': Icons.filter_8,
      },
      {
        'id': 9,
        'name': 'Chalana-Kalanabhyam',
        'description': 'Differences and Similarities',
        'route': Routes.SUTRA9_GAME,
        'icon': Icons.filter_9,
      },
      {
        'id': 10,
        'name': 'Yaavadunam',
        'description': 'Whatever the extent of its deficiency',
        'route': Routes.SUTRA10_GAME,
        'icon': Icons.exposure_plus_1,
      },
      {
        'id': 11,
        'name': 'Vyashtisamanstih',
        'description': 'Part and Whole',
        'route': Routes.SUTRA11_GAME,
        'icon': Icons.filter_1,
      },
      {
        'id': 12,
        'name': 'Shesanyankena Charamena',
        'description': 'The remainders by the last digit',
        'route': Routes.SUTRA12_GAME,
        'icon': Icons.filter_2,
      },
      {
        'id': 13,
        'name': 'Sopaantyadvayamantyam',
        'description': 'The ultimate and twice the penultimate',
        'route': Routes.SUTRA13_GAME,
        'icon': Icons.filter_3,
      },
      {
        'id': 14,
        'name': 'Ekanyunena Purvena',
        'description': 'By one less than the previous one',
        'route': Routes.SUTRA14_GAME,
        'icon': Icons.filter_4,
      },
      {
        'id': 15,
        'name': 'Gunitasamuchyah',
        'description': 'The product of the sum is equal to the sum of the product',
        'route': Routes.SUTRA15_GAME,
        'icon': Icons.filter_5,
      },
      {
        'id': 16,
        'name': 'Gunakasamuchyah',
        'description': 'The factors of the sum is equal to the sum of the factors',
        'route': Routes.SUTRA16_GAME,
        'icon': Icons.filter_6,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title:  Text('Sutra Games', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _buildGameCard(
            id: game['id'] as int,
            name: game['name'] as String,
            description: game['description'] as String,
            route: game['route'] as String,
            icon: game['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildGameCard({
    required int id,
    required String name,
    required String description,
    required String route,
    required IconData icon,
  }) {
    // Color gradient based on sutra number
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFF9B59B6),
      const Color(0xFF3498DB),
    ];
    final color = colors[(id - 1) % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(route),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sutra $id',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Play Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
