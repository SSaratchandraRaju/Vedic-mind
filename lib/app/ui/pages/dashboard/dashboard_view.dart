import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../routes/app_routes.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final operations = ['+', '-', '×', '÷'];
    final operationLabels = ['Add', 'Subtract', 'Multiply', 'Divide'];
    final selectedOperation = 0.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.calculate_outlined, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'VedicMind',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Master Vedic mathematics with interactive learning',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.LESSONS),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start Learning',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Operation Selector Section
              const Text(
                'Select Operation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(operations.length, (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < operations.length - 1 ? 12.0 : 0,
                    ),
                    child: Obx(() => GestureDetector(
                      onTap: () => selectedOperation.value = i,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: selectedOperation.value == i
                              ? const Color(0xFF6366F1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedOperation.value == i
                                ? const Color(0xFF6366F1)
                                : const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                          boxShadow: selectedOperation.value == i
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Text(
                              operations[i],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: selectedOperation.value == i
                                    ? Colors.white
                                    : const Color(0xFF6366F1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              operationLabels[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selectedOperation.value == i
                                    ? Colors.white.withOpacity(0.9)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                )),
              ),
              const SizedBox(height: 32),
              
              // Tables Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Practice Tables',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    '1 - 100',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Tables
              SizedBox(
                height: 440,
                child: Obx(() {
                  final currentOp = selectedOperation.value;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 100,
                    itemBuilder: (context, tableIdx) {
                      final n = tableIdx + 1;
                      return _TableCard(
                        number: n,
                        operation: operations[currentOp],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  final int number;
  final String operation;

  const _TableCard({
    required this.number,
    required this.operation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Color(0xFF6366F1),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, i) {
                  final operand = i + 1;
                  String expr;
                  num result;
                  
                  switch (operation) {
                    case '+':
                      result = number + operand;
                      expr = '$number + $operand = $result';
                      break;
                    case '-':
                      result = number - operand;
                      expr = '$number - $operand = $result';
                      break;
                    case '×':
                      result = number * operand;
                      expr = '$number × $operand = $result';
                      break;
                    case '÷':
                      result = (operand == 0) ? 0 : (number / operand);
                      expr = '$number ÷ $operand = ${result.toStringAsFixed(2)}';
                      break;
                    default:
                      result = number * operand;
                      expr = '$number × $operand = $result';
                  }
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: i % 2 == 0
                          ? const Color(0xFFF9FAFB)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      expr,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}