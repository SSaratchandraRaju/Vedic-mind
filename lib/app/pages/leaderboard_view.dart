import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/bottom_nav_bar.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title:  Text('Leaderboard', style: AppTextStyles.h5),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Tab Selector with Grey Background
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              label: 'This Week',
                              isSelected: controller.selectedTab.value == 0,
                              onTap: () => controller.selectTab(0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _TabButton(
                              label: 'This Month',
                              isSelected: controller.selectedTab.value == 1,
                              onTap: () => controller.selectTab(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top 3 Podium
                  SizedBox(
                    height: 250,
                    child: Stack(
                      children: [
                        // Second place (left)
                        Positioned(
                          left: 20,
                          bottom: 0,
                          child: _PodiumCard(
                            rank: 2,
                            name: 'Bradley',
                            username: '@bradley',
                            score: '948',
                            height: 180,
                            color: AppColors.gray200,
                          ),
                        ),
                        // First place (center)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Center(
                            child: _PodiumCard(
                              rank: 1,
                              name: 'Brooklyn Simna',
                              username: '@brooklyn',
                              score: '1248',
                              height: 220,
                              color: AppColors.yellow,
                              hasCrown: true,
                            ),
                          ),
                        ),
                        // Third place (right)
                        Positioned(
                          right: 20,
                          bottom: 0,
                          child: _PodiumCard(
                            rank: 3,
                            name: 'Rustion',
                            username: '@rustion',
                            score: '848',
                            height: 160,
                            color: AppColors.gray300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Players Around You
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Players Around you', style: AppTextStyles.h5),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Player List
                  _PlayerListItem(
                    rank: 4,
                    name: 'Wade Warren',
                    score: '748',
                    isUp: true,
                  ),
                  _PlayerListItem(
                    rank: 5,
                    name: 'Jenny Wilson',
                    score: '648',
                    isUp: false,
                  ),
                  _PlayerListItem(
                    rank: 6,
                    name: 'You',
                    score: '648',
                    isUp: true,
                    isCurrentUser: true,
                  ),
                  _PlayerListItem(
                    rank: 7,
                    name: 'Marvin McKinney',
                    score: '548',
                    isUp: false,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Obx(
            () => BottomNavBar(
              currentIndex: controller.currentNavIndex.value,
              onTap: controller.onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final int rank;
  final String name;
  final String username;
  final String score;
  final double height;
  final Color color;
  final bool hasCrown;

  const _PodiumCard({
    required this.rank,
    required this.name,
    required this.username,
    required this.score,
    required this.height,
    required this.color,
    this.hasCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getCrownColor() {
      switch (rank) {
        case 1:
          return const Color(0xFFFFD700); // Gold
        case 2:
          return const Color(0xFFC0C0C0); // Silver
        case 3:
          return const Color(0xFFCD7F32); // Bronze
        default:
          return AppColors.yellow;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown above avatar
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Icon(
            Icons.emoji_events,
            color: getCrownColor(),
            size: rank == 1 ? 36 : 28,
          ),
        ),
        // Avatar with rank number
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 40 : 35,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: rank == 1 ? 45 : 40,
                color: Colors.grey,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getCrownColor(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.gray400,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.emoji_events,
                    color: AppColors.yellow,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerListItem extends StatelessWidget {
  final int rank;
  final String name;
  final String score;
  final bool isUp;
  final bool isCurrentUser;

  const _PlayerListItem({
    required this.rank,
    required this.name,
    required this.score,
    required this.isUp,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Text(
            rank.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCurrentUser ? Colors.white : AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: isCurrentUser
                ? Colors.white.withOpacity(0.2)
                : AppColors.gray100,
            child: Icon(
              Icons.person,
              size: 24,
              color: isCurrentUser ? Colors.white : AppColors.gray400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isCurrentUser ? Colors.white : AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Row(
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isCurrentUser ? Colors.white : AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.emoji_events,
                color: isCurrentUser ? Colors.white : AppColors.yellow,
                size: 16,
              ),
              const SizedBox(width: 8),
              Icon(
                isUp ? Icons.arrow_upward : Icons.arrow_downward,
                color: isCurrentUser
                    ? Colors.white
                    : (isUp ? AppColors.success : AppColors.error),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
