import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/onboarding_controller.dart';
import '../../../routes/app_routes.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with noise texture - solid blue
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF5B7EFA),
            ),
            child: CustomPaint(
              painter: NoisePainter(),
              child: Container(),
            ),
          ),
          
          SafeArea(
            child: Obx(() => Stack(
              children: [
                // Animated floating elements - only show on first 3 pages
                if (controller.currentPage.value < 3)
                  ..._buildFloatingElements(controller.currentPage.value),
                
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 40),
                    
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
                          _OnboardingPage(
                            illustration: _buildIllustration3(),
                            title: 'Multiple delivery options',
                            description: 'Enjoy best in the math and\nimprove your brain',
                          ),
                          _AgeSelectionPage(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Only show progress indicator and skip button on first 3 pages
                    if (controller.currentPage.value < 3) ...[
                      // Next button with circular progress
                      GestureDetector(
                        onTap: controller.nextPage,
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Progress circle
                              SizedBox(
                                width: 90,
                                height: 90,
                                child: CircularProgressIndicator(
                                  value: (controller.currentPage.value + 1) / 4,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              // Yellow circle button
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
                      
                      // Skip button below circle
                      TextButton(
                        onPressed: controller.skipOnboarding,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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

  Widget _buildDottedArrowLine() {
    return Obx(() {
      final page = controller.currentPage.value;
      
      // Positions for each page based on screenshots
      double? left, right, top, bottom;
      
      if (page == 0) {
        // Screen 1: Bottom left area
        left = 50;
        bottom = 200;
      } else if (page == 1) {
        // Screen 2: Top left area
        left = 50;
        top = 140;
      } else if (page == 2) {
        // Screen 3: Bottom right area
        right = 100;
        bottom = 280;
      } else {
        // Screen 4: Top right area
        right = 80;
        top = 150;
      }
      
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        child: CustomPaint(
          size: const Size(100, 80),
          painter: DottedArrowPainter(pageIndex: page),
        ),
      );
    });
  }

  List<Widget> _buildFloatingElements(int pageIndex) {
    return [
      // Dotted arrow line - appears on all first 3 pages only
      if (pageIndex < 3) _buildDottedArrowLine(),
      
      // Page 0 - Screen 1 elements
      if (pageIndex == 0) ...[
        // Top left yellow blob (rock shape)
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: -120,
          startLeft: -100,
          endTop: 60,
          endLeft: -50,
          child: CustomPaint(
            size: const Size(150, 130),
            painter: BlobPainter(color: const Color(0xFFFFC107)),
          ),
        ),
        // Top right orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 80,
          startRight: -80,
          endTop: 130,
          endRight: 5,
          delay: 0.1,
          child: Transform.rotate(
            angle: -0.2,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Middle right white circle outline
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 150,
          startRight: 80,
          endTop: 190,
          endRight: 35,
          delay: 0.15,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom middle white filled circle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 250,
          startLeft: 180,
          endBottom: 200,
          endLeft: 140,
          delay: 0.2,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom right green circle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 210,
          startRight: 50,
          endBottom: 160,
          endRight: 15,
          delay: 0.25,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom right small orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 120,
          startRight: -40,
          endBottom: 90,
          endRight: 5,
          delay: 0.3,
          child: Transform.rotate(
            angle: 0.8,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 50,
                height: 50,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
      ],
      
      // Page 1 - Screen 2 elements
      if (pageIndex == 1) ...[
        // Top left dashed circle outline
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 40,
          startLeft: -100,
          endTop: 90,
          endLeft: -55,
          child: CustomPaint(
            size: const Size(105, 105),
            painter: DashedCirclePainter(color: Colors.white.withOpacity(0.5)),
          ),
        ),
        // Top right green circle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 80,
          startRight: -70,
          endTop: 125,
          endRight: 5,
          delay: 0.1,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Top right orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 170,
          startRight: -50,
          endTop: 210,
          endRight: 10,
          delay: 0.15,
          child: Transform.rotate(
            angle: 0.5,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Middle left white circle outline
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 320,
          startLeft: -60,
          endTop: 360,
          endLeft: 5,
          delay: 0.2,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom left orange triangle (large)
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 230,
          startLeft: -80,
          endBottom: 190,
          endLeft: -20,
          delay: 0.25,
          child: Transform.rotate(
            angle: 0.3,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 75,
                height: 75,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Bottom right yellow blob
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 160,
          startRight: -120,
          endBottom: 100,
          endRight: -65,
          delay: 0.3,
          child: CustomPaint(
            size: const Size(165, 145),
            painter: BlobPainter(
              color: const Color(0xFFFFC107),
              rotation: math.pi / 2,
            ),
          ),
        ),
      ],
      
      // Page 2 - Screen 3 elements
      if (pageIndex == 2) ...[
        // Top left orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 40,
          startLeft: -70,
          endTop: 90,
          endLeft: -25,
          child: Transform.rotate(
            angle: 0.2,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 65,
                height: 65,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Top right yellow blob
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 20,
          startRight: -120,
          endTop: 50,
          endRight: -65,
          delay: 0.1,
          child: CustomPaint(
            size: const Size(170, 150),
            painter: BlobPainter(
              color: const Color(0xFFFFC107),
              rotation: math.pi,
            ),
          ),
        ),
        // Top right small orange triangle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startTop: 70,
          startRight: 60,
          endTop: 110,
          endRight: 30,
          delay: 0.15,
          child: Transform.rotate(
            angle: 0.5,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 48,
                height: 48,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Bottom left orange triangle (large)
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 370,
          startLeft: -80,
          endBottom: 330,
          endLeft: -30,
          delay: 0.2,
          child: Transform.rotate(
            angle: -0.3,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 75,
                height: 75,
                color: const Color(0xFFFF6B35),
              ),
            ),
          ),
        ),
        // Bottom middle white circle outline
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 220,
          startLeft: 180,
          endBottom: 180,
          endLeft: 130,
          delay: 0.25,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom right dashed circle
        _AnimatedFloatingElement(
          animation: controller.animationController,
          startBottom: 200,
          startRight: -100,
          endBottom: 160,
          endRight: -55,
          delay: 0.3,
          child: CustomPaint(
            size: const Size(115, 115),
            painter: DashedCirclePainter(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ],
    ];
  }

  Widget _buildIllustration1() {
    return Container(
      width: 280,
      height: 280,
      child: SvgPicture.asset(
        'assets/illustrations/screen1.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildIllustration2() {
    return Container(
      width: 280,
      height: 280,
      child: SvgPicture.asset(
        'assets/illustrations/screen2.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildIllustration3() {
    return Container(
      width: 280,
      height: 280,
      child: SvgPicture.asset(
        'assets/illustrations/screen3.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _AgeSelectionPage extends StatefulWidget {
  const _AgeSelectionPage();

  @override
  State<_AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<_AgeSelectionPage> {
  String? selectedAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Back button
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF2D3142),
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    final controller = Get.find<OnboardingController>();
                    controller.pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              // Title
              const Text(
                'Are you an?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 50),
              // Selection cards
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedAge = 'kid'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  // Illustration
                                  Container(
                                    width: 130,
                                    height: 130,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF9E6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Image.asset(
                                      'assets/illustrations/kid_illustration.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.child_care,
                                          size: 60,
                                          color: Color(0xFFFFB74D),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'KID',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Age less than 10+ years',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              // Checkmark in top right
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: selectedAge == 'kid'
                                        ? const Color(0xFF4CAF50)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: selectedAge != 'kid'
                                        ? Border.all(color: Colors.grey.shade300, width: 2)
                                        : null,
                                  ),
                                  child: selectedAge == 'kid'
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedAge = 'adult'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  // Illustration
                                  Container(
                                    width: 130,
                                    height: 130,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF9E6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Image.asset(
                                      'assets/illustrations/adult_illustration.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Color(0xFFFFB74D),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'ADULT',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Age more than 10+ years',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              // Checkmark in top right
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: selectedAge == 'adult'
                                        ? const Color(0xFF4CAF50)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: selectedAge != 'adult'
                                        ? Border.all(color: Colors.grey.shade300, width: 2)
                                        : null,
                                  ),
                                  child: selectedAge == 'adult'
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Yes button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedAge != null
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('user_age_category', selectedAge!);
                          await prefs.setBool('onboarding_completed', true);
                          Get.offAllNamed(Routes.LOGIN);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7EFA),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
        
        // Calculate movement from start to end position
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

// Noise painter for background texture
class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035);

    for (var i = 0; i < 6000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Blob painter for organic curved shapes (rock-type)
class BlobPainter extends CustomPainter {
  final Color color;
  final double rotation;

  BlobPainter({this.color = const Color(0xFFFFC107), this.rotation = 0});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    canvas.translate(-size.width / 2, -size.height / 2);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create organic blob shape with more irregular curves
    path.moveTo(size.width * 0.25, size.height * 0.35);
    path.cubicTo(
      size.width * 0.15, size.height * 0.15,
      size.width * 0.35, size.height * 0.08,
      size.width * 0.65, size.height * 0.18,
    );
    path.cubicTo(
      size.width * 0.92, size.height * 0.28,
      size.width * 0.98, size.height * 0.55,
      size.width * 0.82, size.height * 0.78,
    );
    path.cubicTo(
      size.width * 0.68, size.height * 0.98,
      size.width * 0.35, size.height * 0.92,
      size.width * 0.18, size.height * 0.72,
    );
    path.cubicTo(
      size.width * 0.05, size.height * 0.52,
      size.width * 0.12, size.height * 0.38,
      size.width * 0.25, size.height * 0.35,
    );
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dotted arrow painter
class DottedArrowPainter extends CustomPainter {
  final int pageIndex;
  
  DottedArrowPainter({this.pageIndex = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Different arrow paths for each page
    if (pageIndex == 0) {
      // Screen 1: Curved arrow pointing up-right
      path.moveTo(8, size.height - 5);
      path.quadraticBezierTo(
        size.width * 0.3, size.height * 0.65,
        size.width * 0.6, size.height * 0.3,
      );
      path.quadraticBezierTo(
        size.width * 0.8, 8,
        size.width - 5, 5,
      );
    } else if (pageIndex == 1) {
      // Screen 2: Curved arrow pointing down-left
      path.moveTo(size.width - 8, 8);
      path.quadraticBezierTo(
        size.width * 0.65, size.height * 0.35,
        size.width * 0.35, size.height * 0.65,
      );
      path.quadraticBezierTo(
        size.width * 0.15, size.height * 0.88,
        8, size.height - 5,
      );
    } else if (pageIndex == 2) {
      // Screen 3: Curved arrow pointing up-left
      path.moveTo(size.width - 8, size.height - 5);
      path.quadraticBezierTo(
        size.width * 0.6, size.height * 0.68,
        size.width * 0.3, size.height * 0.35,
      );
      path.quadraticBezierTo(
        size.width * 0.12, 12,
        8, 8,
      );
    } else {
      // Screen 4: Curved arrow pointing down-right
      path.moveTo(8, 8);
      path.quadraticBezierTo(
        size.width * 0.3, size.height * 0.3,
        size.width * 0.65, size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.85,
        size.width - 5, size.height - 5,
      );
    }

    // Draw dashed path
    final dashPath = _createDashedPath(path, 5, 5);
    canvas.drawPath(dashPath, paint);

    // Draw arrow head
    final arrowPaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    
    if (pageIndex == 0) {
      // Arrow pointing right-up
      arrowPath.moveTo(size.width - 5, 5);
      arrowPath.lineTo(size.width - 12, 2);
      arrowPath.lineTo(size.width - 8, 11);
      arrowPath.close();
    } else if (pageIndex == 1) {
      // Arrow pointing left-down
      arrowPath.moveTo(8, size.height - 5);
      arrowPath.lineTo(15, size.height - 2);
      arrowPath.lineTo(11, size.height - 11);
      arrowPath.close();
    } else if (pageIndex == 2) {
      // Arrow pointing left-up
      arrowPath.moveTo(8, 8);
      arrowPath.lineTo(15, 11);
      arrowPath.lineTo(11, 2);
      arrowPath.close();
    } else {
      // Arrow pointing right-down
      arrowPath.moveTo(size.width - 5, size.height - 5);
      arrowPath.lineTo(size.width - 12, size.height - 8);
      arrowPath.lineTo(size.width - 8, size.height - 14);
      arrowPath.close();
    }

    canvas.drawPath(arrowPath, arrowPaint);
  }

  Path _createDashedPath(Path source, double dashLength, double dashGap) {
    final path = Path();
    final metrics = source.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashLength : dashGap;
        final end = math.min(distance + length, metric.length);
        
        if (draw) {
          path.addPath(
            metric.extractPath(distance, end),
            Offset.zero,
          );
        }
        
        distance = end;
        draw = !draw;
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  
  DashedCirclePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    var startAngle = 0.0;
    const totalDashes = 24;
    const dashAngle = (2 * math.pi) / totalDashes;

    for (var i = 0; i < totalDashes; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          dashAngle,
          false,
          paint,
        );
      }
      startAngle += dashAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}