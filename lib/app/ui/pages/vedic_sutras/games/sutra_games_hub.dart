import 'package:flutter/material.dart';
import '../../../theme/app_text_styles.dart';

/// Hub for all 16 Sutra mini-games
class SutraGamesHub {
  static final Map<int, Map<String, dynamic>> gamesList = {
    1: {
      'title': 'Square Dash',
      'description': 'Fast squaring of numbers ending in 5',
      'icon': Icons.flash_on,
      'color': Color(0xFFFF6B6B),
      'route': '/sutra1-game',
    },
    2: {
      'title': 'Near-Base Rush',
      'description': 'Multiply numbers near bases quickly',
      'icon': Icons.speed,
      'color': Color(0xFF4ECDC4),
      'route': '/sutra2-game',
    },
    3: {
      'title': 'Crosswise Matrix',
      'description': 'Master crosswise multiplication patterns',
      'icon': Icons.grid_on,
      'color': Color(0xFFFFBE0B),
      'route': '/sutra3-game',
    },
    4: {
      'title': 'Division Dash',
      'description': 'Transpose and conquer division',
      'icon': Icons.calculate,
      'color': Color(0xFF8338EC),
      'route': '/sutra4-game',
    },
    5: {
      'title': 'Zero Sum Solver',
      'description': 'Find solutions when sums are equal',
      'icon': Icons.exposure_zero,
      'color': Color(0xFFFF006E),
      'route': '/sutra5-game',
    },
    6: {
      'title': 'Ratio Racer',
      'description': 'Solve proportions at lightning speed',
      'icon': Icons.percent,
      'color': Color(0xFF06FFA5),
      'route': '/sutra6-game',
    },
    7: {
      'title': 'Equation Eliminator',
      'description': 'Add and subtract to solve equations',
      'icon': Icons.functions,
      'color': Color(0xFF3A86FF),
      'route': '/sutra7-game',
    },
    8: {
      'title': 'Complete & Adjust',
      'description': 'Complete to round numbers',
      'icon': Icons.adjust,
      'color': Color(0xFFFF9F1C),
      'route': '/sutra8-game',
    },
    9: {
      'title': 'Pattern Predictor',
      'description': 'Spot sequences and patterns',
      'icon': Icons.insights,
      'color': Color(0xFF7209B7),
      'route': '/sutra9-game',
    },
    10: {
      'title': 'Deficiency Detector',
      'description': 'Find and use deficiencies from base',
      'icon': Icons.remove_circle_outline,
      'color': Color(0xFFE63946),
      'route': '/sutra10-game',
    },
    11: {
      'title': 'Part-Whole Puzzles',
      'description': 'Break problems into manageable parts',
      'icon': Icons.extension,
      'color': Color(0xFF06FFC8),
      'route': '/sutra11-game',
    },
    12: {
      'title': 'Remainder Race',
      'description': 'Master modular arithmetic',
      'icon': Icons.repeat,
      'color': Color(0xFFFFBE0B),
      'route': '/sutra12-game',
    },
    13: {
      'title': 'Penultimate Puzzles',
      'description': 'Ultimate and penultimate digit magic',
      'icon': Icons.looks_two,
      'color': Color(0xFF560BAD),
      'route': '/sutra13-game',
    },
    14: {
      'title': 'Decimal Dash',
      'description': 'Convert fractions to decimals',
      'icon': Icons.filter_9_plus,
      'color': Color(0xFFEF476F),
      'route': '/sutra14-game',
    },
    15: {
      'title': 'Product-Sum Spotter',
      'description': 'Find product-sum equalities',
      'icon': Icons.compare_arrows,
      'color': Color(0xFF118AB2),
      'route': '/sutra15-game',
    },
    16: {
      'title': 'Factorization Finale',
      'description': 'Master factorization patterns',
      'icon': Icons.auto_awesome,
      'color': Color(0xFFFFD60A),
      'route': '/sutra16-game',
    },
  };
  
  static Widget buildGameCard(int sutraId, VoidCallback onTap) {
    final game = gamesList[sutraId];
    if (game == null) return const SizedBox.shrink();
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (game['color'] as Color).withOpacity(0.1),
              (game['color'] as Color).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (game['color'] as Color).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: game['color'] as Color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (game['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                game['icon'] as IconData,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game['title'] as String,
                    style: AppTextStyles.h5.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game['description'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (game['color'] as Color).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: game['color'] as Color,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  static String? getGameRoute(int sutraId) {
    return gamesList[sutraId]?['route'] as String?;
  }
  
  static String getGameTitle(int sutraId) {
    return gamesList[sutraId]?['title'] as String? ?? 'Mini Game';
  }
}
