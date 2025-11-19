class VedicMethod {
  final String id;
  final String title;
  final String description;
  final String operation; // 'addition', 'subtraction', 'multiplication', 'division'
  final String difficulty; // '2-digit', '3-digit', etc.
  final bool isCompleted;
  final bool isOngoing;
  final bool isLocked;
  final List<MethodStep> steps;
  final String problem;
  final String answer;

  VedicMethod({
    required this.id,
    required this.title,
    required this.description,
    required this.operation,
    required this.difficulty,
    this.isCompleted = false,
    this.isOngoing = false,
    this.isLocked = false,
    required this.steps,
    required this.problem,
    required this.answer,
  });
}

class MethodStep {
  final int stepNumber;
  final String title;
  final String description;
  final String? calculation; // e.g., "52 = 50 + 2"
  final List<String>? breakdownLines; // For showing multiple lines like "50" and "2"

  MethodStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.calculation,
    this.breakdownLines,
  });
}

class VedicMethodCategory {
  final String name;
  final String icon;
  final String color;
  final List<VedicMethod> methods;

  VedicMethodCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.methods,
  });
}
