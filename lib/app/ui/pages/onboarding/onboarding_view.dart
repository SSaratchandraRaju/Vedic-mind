import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with noise texture
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0062E0),
            ),
            child: Stack(
              children: [
                // Noise SVG background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.04,
                    child: SvgPicture.asset(
                      'assets/illustrations/noisesubtle.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SafeArea(
            child: Obx(() => Stack(
              children: [
                // Animated floating elements
                if (controller.currentPage.value < 2)
                  ..._buildFloatingElements(controller.currentPage.value),
                
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 150),
                    
                    // PageView
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        children: [
                          _OnboardingPage(
                            illustration: _buildIllustration1(),
                            title: 'Multiple delivery options',
                            description: 'Enjoy best in the math and\nimprove your brain',
                          ),
                          _OnboardingPage(
                            illustration: _buildIllustration2(),
                            title: 'Multiple delivery options',
                            description: 'Enjoy best in the math and\nimprove your brain',
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Progress and skip button
                    if (controller.currentPage.value < 2) ...[
                      GestureDetector(
                        onTap: controller.nextPage,
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 90,
                                height: 90,
                                child: CircularProgressIndicator(
                                  value: (controller.currentPage.value + 1) / 2,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFC107),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFC107).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: controller.skipOnboarding,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ] else ...[
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingElements(int pageIndex) {
    return [
      // Page 0 - Screen 1 elements
      if (pageIndex == 0) ...[
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: -10,
          startLeft: -10,
          endTop: 0,
          endLeft: -50,
          child: Transform.rotate(
        angle: -0.01,
        child: SvgPicture.asset(
          'assets/illustrations/Vector.svg',
          width: 160,
          height: 160,
        ),
          ),
        ),
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 40,
          startRight: -60,
          endTop: 40,
          endRight: 10,
          delay: 0.1,
          child: SvgPicture.asset(
            'assets/illustrations/triangle1.svg',
            width: 65,
            height: 65,
          ),
        ),
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 110,
          startRight: 40,
          endTop: 100,
          endRight: 170,
          delay: 0.15,
          child: SvgPicture.asset(
            'assets/illustrations/circle.svg',
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 240,
          startLeft: -50,
          endBottom: 50,
          endLeft: 5,
          delay: 0.2,
          child: Transform.rotate(
            angle: -0.001, 
            child: SvgPicture.asset(
              'assets/illustrations/dottedarrow.svg',
              width: 220,
              height: 200,
            ),
            ),
        ),
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 190,
          startRight: 40,
          endBottom: 120,
          endRight: 105,
          delay: 0.25,
          child: SvgPicture.asset(
            'assets/illustrations/shadedcircle.svg',
            width: 25,
            height: 25,
          ),
        ),
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 800,
          startRight: -10,
          endBottom: 350,
          endRight: 35,
          delay: 0.3,
          child: SvgPicture.asset(
            'assets/illustrations/triangle.svg',
            width: 30,
            height: 30,
          ),
        ),
      ],
      
      // Page 1 - Screen 2 elements
      if (pageIndex == 1) ...[
        // Top left dashed circle outline
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: -10,
          startLeft: -80,
          endTop: 0,
          endLeft: -50,
          child: SvgPicture.asset(
            'assets/illustrations/circle.svg',
            width: 85,
            height: 85,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        // Top left to middle - dotted arrow
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 80,
          startLeft: -50,
          endTop: 80,
          endLeft: 5,
          delay: 0.1,
          child: Transform.rotate(
            angle: math.pi,
            child: SvgPicture.asset(
              'assets/illustrations/dottedarrow.svg',
              width: 220,
              height: 200,
            ),
          ),
        ),
        // Top right green circle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 60,
          startRight: -60,
          endTop: 60,
          endRight: 105,
          delay: 0.15,
          child: SvgPicture.asset(
            'assets/illustrations/shadedcircle.svg',
            width: 25,
            height: 25,
          ),
        ),
        // Top right orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 140,
          startRight: -50,
          endTop: 140,
          endRight: 35,
          delay: 0.2,
          child: SvgPicture.asset(
            'assets/illustrations/triangle1.svg',
            width: 60,
            height: 60,
          ),
        ),
        // Bottom left large triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 220,
          startLeft: -70,
          endBottom: 220,
          endLeft: -20,
          delay: 0.25,
          child: Transform.rotate(
            angle: 0.3,
            child: SvgPicture.asset(
              'assets/illustrations/triangle1.svg',
              width: 70,
              height: 70,
            ),
          ),
        ),
        // Bottom right yellow blob
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 140,
          startRight: -100,
          endBottom: 0,
          endRight: -50,
          delay: 0.3,
          child: Transform.rotate(
            angle: math.pi,
            child: SvgPicture.asset(
              'assets/illustrations/Vector.svg',
              width: 160,
              height: 160,
            ),
          ),
        ),
      ],
    ];
  }

  Widget _buildIllustration1() {
    return SizedBox(
      width: 280,
      height: 280,
      child: SvgPicture.asset(
        'assets/illustrations/screen1.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildIllustration2() {
    return SizedBox(
      width: 280,
      height: 280,
      child: SvgPicture.asset(
        'assets/illustrations/screen2.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.illustration,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 50),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.3,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnimatedFloatingElement extends StatelessWidget {
  final Animation<double> animation;
  final double? startTop;
  final double? startBottom;
  final double? startLeft;
  final double? startRight;
  final double? endTop;
  final double? endBottom;
  final double? endLeft;
  final double? endRight;
  final Widget child;
  final double delay;

  const _AnimatedFloatingElement({
    required this.animation,
    this.startTop,
    this.startBottom,
    this.startLeft,
    this.startRight,
    this.endTop,
    this.endBottom,
    this.endLeft,
    this.endRight,
    required this.child,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final delayedValue = ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0);
        final curvedValue = Curves.easeOutCubic.transform(delayedValue);
        
        final currentTop = startTop != null && endTop != null
            ? startTop! + ((endTop! - startTop!) * curvedValue)
            : (startTop ?? endTop);
        final currentBottom = startBottom != null && endBottom != null
            ? startBottom! + ((endBottom! - startBottom!) * curvedValue)
            : (startBottom ?? endBottom);
        final currentLeft = startLeft != null && endLeft != null
            ? startLeft! + ((endLeft! - startLeft!) * curvedValue)
            : (startLeft ?? endLeft);
        final currentRight = startRight != null && endRight != null
            ? startRight! + ((endRight! - startRight!) * curvedValue)
            : (startRight ?? endRight);
        
        return Positioned(
          top: currentTop,
          bottom: currentBottom,
          left: currentLeft,
          right: currentRight,
          child: Opacity(
            opacity: curvedValue,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
