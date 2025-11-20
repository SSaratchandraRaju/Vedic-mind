// Detailed step-by-step examples for all 16 Vedic Sutras

class SutraExample {
  final String problem;
  final List<ExampleStep> steps;
  
  SutraExample({required this.problem, required this.steps});
}

class ExampleStep {
  final String display;
  final String description;
  final String audioText;
  
  ExampleStep({
    required this.display,
    required this.description,
    required this.audioText,
  });
}

class PracticeStep {
  final String instruction;
  final String expectedAnswer;
  final String hint;
  final String formula;
  
  PracticeStep({
    required this.instruction,
    required this.expectedAnswer,
    required this.hint,
    required this.formula,
  });
}

class VedicSutraExamples {
  static SutraExample getExample(int sutraId) {
    switch (sutraId) {
      case 1:
        return _getSutra1Example();
      case 2:
        return _getSutra2Example();
      case 3:
        return _getSutra3Example();
      case 4:
        return _getSutra4Example();
      case 5:
        return _getSutra5Example();
      case 6:
        return _getSutra6Example();
      case 7:
        return _getSutra7Example();
      case 8:
        return _getSutra8Example();
      case 9:
        return _getSutra9Example();
      case 10:
        return _getSutra10Example();
      case 11:
        return _getSutra11Example();
      case 12:
        return _getSutra12Example();
      case 13:
        return _getSutra13Example();
      case 14:
        return _getSutra14Example();
      case 15:
        return _getSutra15Example();
      case 16:
        return _getSutra16Example();
      default:
        return _getSutra1Example();
    }
  }
  
  static List<PracticeStep> getPracticeSteps(int sutraId, String problem) {
    switch (sutraId) {
      case 1:
        return _getSutra1PracticeSteps(problem);
      case 2:
        return _getSutra2PracticeSteps(problem);
      case 3:
        return _getSutra3PracticeSteps(problem);
      case 4:
        return _getSutra4PracticeSteps(problem);
      case 5:
        return _getSutra5PracticeSteps(problem);
      case 6:
        return _getSutra6PracticeSteps(problem);
      case 7:
        return _getSutra7PracticeSteps(problem);
      case 8:
        return _getSutra8PracticeSteps(problem);
      case 9:
        return _getSutra9PracticeSteps(problem);
      case 10:
        return _getSutra10PracticeSteps(problem);
      case 11:
        return _getSutra11PracticeSteps(problem);
      case 12:
        return _getSutra12PracticeSteps(problem);
      case 13:
        return _getSutra13PracticeSteps(problem);
      case 14:
        return _getSutra14PracticeSteps(problem);
      case 15:
        return _getSutra15PracticeSteps(problem);
      case 16:
        return _getSutra16PracticeSteps(problem);
      default:
        return [];
    }
  }

  // SUTRA 1: Ekadhikena Purvena (By One More Than The One Before)
  static SutraExample _getSutra1Example() {
    return SutraExample(
      problem: '25²',
      steps: [
        ExampleStep(
          display: '25²',
          description: 'Problem: Square 25',
          audioText: 'Let\'s calculate 25 squared using the sutra: By one more than the one before',
        ),
        ExampleStep(
          display: '2',
          description: 'Step 1: Take the first digit',
          audioText: 'First, take the first digit which is 2',
        ),
        ExampleStep(
          display: '2 × 3',
          description: 'Step 2: Multiply by one more',
          audioText: 'Multiply 2 by one more than itself. 2 times 3',
        ),
        ExampleStep(
          display: '6',
          description: 'Step 3: Calculate the result',
          audioText: '2 times 3 equals 6. This will be the first part',
        ),
        ExampleStep(
          display: '6 | 25',
          description: 'Step 4: Append 25',
          audioText: 'Now append 25 to get 6, 25',
        ),
        ExampleStep(
          display: '625',
          description: 'Final Answer',
          audioText: 'The final answer is 625. 25 squared equals 625',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra1PracticeSteps(String problem) {
    // Extract number from problem like "25²" or "25^2"
    final numStr = problem.replaceAll('²', '').replaceAll('^2', '').replaceAll(' ', '').trim();
    
    try {
      final num = int.parse(numStr);
      final firstDigit = num ~/ 10;
      final product = firstDigit * (firstDigit + 1);
      
      return [
        PracticeStep(
          instruction: 'Take the first digit',
          expectedAnswer: firstDigit.toString(),
          hint: 'The first digit of $numStr is $firstDigit',
          formula: 'First digit of $numStr',
        ),
        PracticeStep(
          instruction: 'Multiply by one more',
          expectedAnswer: product.toString(),
          hint: '$firstDigit × ${firstDigit + 1} = $product',
          formula: '$firstDigit × (${firstDigit + 1})',
        ),
        PracticeStep(
          instruction: 'Write the final answer',
          expectedAnswer: '${product}25',
          hint: 'Append 25 to $product',
          formula: '$product | 25',
        ),
      ];
    } catch (e) {
      // Fallback if parsing fails
      return [
        PracticeStep(
          instruction: 'Solve the problem',
          expectedAnswer: '625',
          hint: 'Use the Ekadhikena Purvena method',
          formula: 'n × (n+1) | 25',
        ),
      ];
    }
  }

  // SUTRA 2: Nikhilam Navatascharam Dasatah (All from 9 and last from 10)
  static SutraExample _getSutra2Example() {
    return SutraExample(
      problem: '97 × 98',
      steps: [
        ExampleStep(
          display: '97 × 98',
          description: 'Problem: Multiply 97 × 98',
          audioText: 'Let\'s multiply 97 times 98 using base 100 method',
        ),
        ExampleStep(
          display: 'Base: 100',
          description: 'Step 1: Choose base 100',
          audioText: 'Both numbers are close to 100, so our base is 100',
        ),
        ExampleStep(
          display: '97 → -3\n98 → -2',
          description: 'Step 2: Find deviations',
          audioText: '97 is 3 less than 100, and 98 is 2 less than 100',
        ),
        ExampleStep(
          display: '97 + (-2) = 95',
          description: 'Step 3: Cross-add',
          audioText: 'Cross add: 97 plus negative 2 equals 95',
        ),
        ExampleStep(
          display: '(-3) × (-2) = 6',
          description: 'Step 4: Multiply deviations',
          audioText: 'Multiply the deviations: negative 3 times negative 2 equals 6',
        ),
        ExampleStep(
          display: '95 | 06',
          description: 'Step 5: Combine results',
          audioText: 'Combine 95 and 06 to get 9506',
        ),
        ExampleStep(
          display: '9506',
          description: 'Final Answer',
          audioText: 'The answer is 9506. 97 times 98 equals 9506',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra2PracticeSteps(String problem) {
    try {
      // Parse "97×98" or "97 × 98"
      final parts = problem.replaceAll(' ', '').split('×');
      if (parts.length != 2) throw FormatException('Invalid format');
      
      final num1 = int.parse(parts[0]);
      final num2 = int.parse(parts[1]);
      final base = 100;
      final dev1 = num1 - base;
      final dev2 = num2 - base;
      final crossSum = num1 + dev2;
      final devProduct = dev1 * dev2;
      
      return [
        PracticeStep(
          instruction: 'Find deviation of first number from 100',
          expectedAnswer: dev1.toString(),
          hint: '$num1 - 100 = $dev1',
          formula: '$num1 - 100',
        ),
        PracticeStep(
          instruction: 'Find deviation of second number from 100',
          expectedAnswer: dev2.toString(),
          hint: '$num2 - 100 = $dev2',
          formula: '$num2 - 100',
        ),
        PracticeStep(
          instruction: 'Cross-add (first number + second deviation)',
          expectedAnswer: crossSum.toString(),
          hint: '$num1 + ($dev2) = $crossSum',
          formula: '$num1 + ($dev2)',
        ),
        PracticeStep(
          instruction: 'Multiply the deviations',
          expectedAnswer: devProduct.abs().toString(),
          hint: '($dev1) × ($dev2) = $devProduct',
          formula: '($dev1) × ($dev2)',
        ),
        PracticeStep(
          instruction: 'Write the final answer',
          expectedAnswer: '${crossSum}${devProduct.abs().toString().padLeft(2, '0')}',
          hint: 'Combine $crossSum and ${devProduct.abs().toString().padLeft(2, '0')}',
          formula: '$crossSum | ${devProduct.abs().toString().padLeft(2, '0')}',
        ),
      ];
    } catch (e) {
      // Fallback if parsing fails
      return [
        PracticeStep(
          instruction: 'Solve the problem',
          expectedAnswer: '9506',
          hint: 'Use the Nikhilam method: deviations and cross-addition',
          formula: 'Base method',
        ),
      ];
    }
  }

  // SUTRA 3: Urdhva-Tiryagbhyam (Vertically and Crosswise)
  static SutraExample _getSutra3Example() {
    return SutraExample(
      problem: '12 × 13',
      steps: [
        ExampleStep(
          display: '12 × 13',
          description: 'Problem: Multiply 12 × 13',
          audioText: 'Let\'s multiply 12 times 13 using vertical and crosswise method',
        ),
        ExampleStep(
          display: '1 × 1 = 1',
          description: 'Step 1: Multiply leftmost digits',
          audioText: 'Multiply the leftmost digits vertically: 1 times 1 equals 1',
        ),
        ExampleStep(
          display: '(1×3) + (2×1) = 5',
          description: 'Step 2: Cross multiply middle',
          audioText: 'Cross multiply: 1 times 3 plus 2 times 1 equals 5',
        ),
        ExampleStep(
          display: '2 × 3 = 6',
          description: 'Step 3: Multiply rightmost digits',
          audioText: 'Multiply rightmost digits: 2 times 3 equals 6',
        ),
        ExampleStep(
          display: '1 | 5 | 6',
          description: 'Step 4: Combine all results',
          audioText: 'Combine all parts: 1, 5, 6',
        ),
        ExampleStep(
          display: '156',
          description: 'Final Answer',
          audioText: 'The final answer is 156. 12 times 13 equals 156',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra3PracticeSteps(String problem) {
    try {
      final parts = problem.replaceAll(' ', '').split('×');
      if (parts.length != 2) throw FormatException('Invalid format');
      
      final num1 = int.parse(parts[0]);
      final num2 = int.parse(parts[1]);
      final a = num1 ~/ 10;
      final b = num1 % 10;
      final c = num2 ~/ 10;
      final d = num2 % 10;
      
      return [
        PracticeStep(
          instruction: 'Multiply leftmost digits',
          expectedAnswer: (a * c).toString(),
          hint: '$a × $c = ${a * c}',
          formula: '$a × $c',
        ),
        PracticeStep(
          instruction: 'Cross multiply and add',
          expectedAnswer: ((a * d) + (b * c)).toString(),
          hint: '($a × $d) + ($b × $c) = ${(a * d) + (b * c)}',
          formula: '($a × $d) + ($b × $c)',
        ),
        PracticeStep(
          instruction: 'Multiply rightmost digits',
          expectedAnswer: (b * d).toString(),
          hint: '$b × $d = ${b * d}',
          formula: '$b × $d',
        ),
        PracticeStep(
          instruction: 'Write the final answer',
          expectedAnswer: (num1 * num2).toString(),
          hint: 'Combine the results',
          formula: 'Combine all digits',
        ),
      ];
    } catch (e) {
      // Fallback if parsing fails
      return [
        PracticeStep(
          instruction: 'Solve the problem',
          expectedAnswer: '156',
          hint: 'Use Urdhva-Tiryagbhyam: vertical and crosswise multiplication',
          formula: 'Vertical × Crosswise method',
        ),
      ];
    }
  }

  // SUTRA 4: Paravartya Yojayet (Transpose and Apply)
  static SutraExample _getSutra4Example() {
    return SutraExample(
      problem: '144 ÷ 12',
      steps: [
        ExampleStep(
          display: '144 ÷ 12',
          description: 'Problem: Divide 144 by 12',
          audioText: 'Let\'s divide 144 by 12 using transpose and apply method',
        ),
        ExampleStep(
          display: '12 → -12',
          description: 'Step 1: Transpose divisor',
          audioText: 'Transpose the divisor 12 to negative 12',
        ),
        ExampleStep(
          display: '14 ÷ 12 = 1',
          description: 'Step 2: First quotient digit',
          audioText: '14 divided by 12 gives quotient 1',
        ),
        ExampleStep(
          display: '1 × 2 = 2',
          description: 'Step 3: Multiply and subtract',
          audioText: 'Multiply 1 by 2 equals 2. Subtract from 4',
        ),
        ExampleStep(
          display: '4 - 2 = 2',
          description: 'Step 4: Get remainder',
          audioText: '4 minus 2 equals 2. This is our next digit',
        ),
        ExampleStep(
          display: '12',
          description: 'Final Answer',
          audioText: 'The answer is 12. 144 divided by 12 equals 12',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra4PracticeSteps(String problem) {
    return [
      PracticeStep(
        instruction: 'Write the dividend',
        expectedAnswer: '144',
        hint: 'The number being divided',
        formula: 'Dividend',
      ),
      PracticeStep(
        instruction: 'Write the divisor',
        expectedAnswer: '12',
        hint: 'The number we divide by',
        formula: 'Divisor',
      ),
      PracticeStep(
        instruction: 'Calculate the quotient',
        expectedAnswer: '12',
        hint: '144 ÷ 12 = 12',
        formula: '144 ÷ 12',
      ),
    ];
  }

  // SUTRA 5: Shunyam Saamyasamuccaye (When the sum is the same, that sum is zero)
  static SutraExample _getSutra5Example() {
    return SutraExample(
      problem: 'x + 7 = 13',
      steps: [
        ExampleStep(
          display: 'x + 7 = 13',
          description: 'Problem: Solve for x',
          audioText: 'Let\'s solve x plus 7 equals 13',
        ),
        ExampleStep(
          display: 'x = 13 - 7',
          description: 'Step 1: Transpose',
          audioText: 'Move 7 to the right side: x equals 13 minus 7',
        ),
        ExampleStep(
          display: 'x = 6',
          description: 'Final Answer',
          audioText: 'x equals 6',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra5PracticeSteps(String problem) {
    return [
      PracticeStep(
        instruction: 'Identify the constant',
        expectedAnswer: '7',
        hint: 'The number being added',
        formula: 'Constant term',
      ),
      PracticeStep(
        instruction: 'Subtract from right side',
        expectedAnswer: '6',
        hint: '13 - 7 = 6',
        formula: '13 - 7',
      ),
    ];
  }

  // SUTRA 6: Anurupye Shunyamanyat (If one is in ratio, the other is zero)
  static SutraExample _getSutra6Example() {
    return SutraExample(
      problem: '2x = 10',
      steps: [
        ExampleStep(
          display: '2x = 10',
          description: 'Problem: Solve 2x = 10',
          audioText: 'Let\'s solve 2 x equals 10',
        ),
        ExampleStep(
          display: 'x = 10 ÷ 2',
          description: 'Step 1: Divide both sides',
          audioText: 'Divide both sides by 2',
        ),
        ExampleStep(
          display: 'x = 5',
          description: 'Final Answer',
          audioText: 'x equals 5',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra6PracticeSteps(String problem) {
    return [
      PracticeStep(
        instruction: 'Identify the coefficient',
        expectedAnswer: '2',
        hint: 'The number multiplying x',
        formula: 'Coefficient',
      ),
      PracticeStep(
        instruction: 'Divide to solve',
        expectedAnswer: '5',
        hint: '10 ÷ 2 = 5',
        formula: '10 ÷ 2',
      ),
    ];
  }

  // SUTRA 7: Sankalana-vyavakalanabhyam (By addition and subtraction)
  static SutraExample _getSutra7Example() {
    return SutraExample(
      problem: '51 × 49',
      steps: [
        ExampleStep(
          display: '51 × 49',
          description: 'Problem: Multiply 51 × 49',
          audioText: 'Let\'s multiply 51 times 49 using addition and subtraction',
        ),
        ExampleStep(
          display: '50² = 2500',
          description: 'Step 1: Find base square',
          audioText: '50 squared equals 2500',
        ),
        ExampleStep(
          display: '1² = 1',
          description: 'Step 2: Find difference square',
          audioText: '1 squared equals 1',
        ),
        ExampleStep(
          display: '2500 - 1 = 2499',
          description: 'Step 3: Subtract',
          audioText: '2500 minus 1 equals 2499',
        ),
        ExampleStep(
          display: '2499',
          description: 'Final Answer',
          audioText: 'The answer is 2499',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra7PracticeSteps(String problem) {
    return [
      PracticeStep(
        instruction: 'Find the base (average)',
        expectedAnswer: '50',
        hint: 'Average of 51 and 49',
        formula: '(51 + 49) ÷ 2',
      ),
      PracticeStep(
        instruction: 'Square the base',
        expectedAnswer: '2500',
        hint: '50 × 50 = 2500',
        formula: '50²',
      ),
      PracticeStep(
        instruction: 'Find difference from base',
        expectedAnswer: '1',
        hint: '51 - 50 = 1',
        formula: '51 - 50',
      ),
      PracticeStep(
        instruction: 'Calculate final answer',
        expectedAnswer: '2499',
        hint: '2500 - 1 = 2499',
        formula: '2500 - 1²',
      ),
    ];
  }

  // SUTRA 8-16: Similar implementations
  static SutraExample _getSutra8Example() {
    return SutraExample(
      problem: '46 × 44',
      steps: [
        ExampleStep(
          display: '46 × 44',
          description: 'Problem: Multiply 46 × 44',
          audioText: 'Let\'s multiply 46 times 44',
        ),
        ExampleStep(
          display: '4 × 4 = 16',
          description: 'Step 1: Multiply tens',
          audioText: '4 tens times 4 tens equals 16 hundreds',
        ),
        ExampleStep(
          display: '4 × (6+4) = 40',
          description: 'Step 2: Cross multiply',
          audioText: '4 times the sum of 6 and 4 equals 40 tens',
        ),
        ExampleStep(
          display: '6 × 4 = 24',
          description: 'Step 3: Multiply units',
          audioText: '6 times 4 equals 24',
        ),
        ExampleStep(
          display: '2024',
          description: 'Final Answer',
          audioText: 'The answer is 2024',
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra8PracticeSteps(String problem) {
    return [
      PracticeStep(
        instruction: 'Multiply tens digits',
        expectedAnswer: '16',
        hint: '4 × 4 = 16',
        formula: '4 × 4',
      ),
      PracticeStep(
        instruction: 'Multiply units digits',
        expectedAnswer: '24',
        hint: '6 × 4 = 24',
        formula: '6 × 4',
      ),
      PracticeStep(
        instruction: 'Write final answer',
        expectedAnswer: '2024',
        hint: 'Combine 16 and 24',
        formula: '1600 + 400 + 24',
      ),
    ];
  }

  // Sutras 9-16 with similar patterns
  static SutraExample _getSutra9Example() {
    // Sutra 9: Calana-Kalanābhyām - Differences and motion
    return SutraExample(
      problem: "Find sum: 1 + 2 + 3 + ... + 100",
      steps: [
        ExampleStep(
          display: "1 + 2 + 3 + ... + 100 = ?",
          description: "Find the sum of first 100 natural numbers using pattern recognition",
          audioText: "Let's find the sum of numbers from 1 to 100 using the pattern method.",
        ),
        ExampleStep(
          display: "Pair numbers: (1+100), (2+99), (3+98)...",
          description: "Notice each pair sums to 101",
          audioText: "Observe the pattern: first and last numbers sum to 101, second and second-last also sum to 101.",
        ),
        ExampleStep(
          display: "Total pairs = 100 ÷ 2 = 50 pairs",
          description: "We have 50 pairs of numbers",
          audioText: "We can make 50 pairs from 100 numbers.",
        ),
        ExampleStep(
          display: "Each pair sums to 101",
          description: "Every pair has the same sum",
          audioText: "Each pair equals 101.",
        ),
        ExampleStep(
          display: "50 pairs × 101 = 5050",
          description: "Total sum is 5050",
          audioText: "Multiply 50 pairs by 101 to get 5050. This is the sum of all numbers from 1 to 100.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra10Example() {
    // Sutra 10: Yāvadūnam - Whatever the deficiency
    return SutraExample(
      problem: "88 × 89",
      steps: [
        ExampleStep(
          display: "88 × 89",
          description: "Multiply numbers near base 100 using deficiency method",
          audioText: "Let's multiply 88 and 89 using the deficiency method with base 100.",
        ),
        ExampleStep(
          display: "Base = 100",
          description: "Both numbers are close to 100",
          audioText: "Choose 100 as our base since both numbers are near it.",
        ),
        ExampleStep(
          display: "Deficiency: 100-88=12, 100-89=11",
          description: "Find how much each number is below 100",
          audioText: "88 is 12 less than 100, and 89 is 11 less than 100.",
        ),
        ExampleStep(
          display: "Left part: 88 - 11 = 77 (or 89 - 12 = 77)",
          description: "Cross-subtract the deficiencies",
          audioText: "Subtract 11 from 88, or subtract 12 from 89. Both give 77.",
        ),
        ExampleStep(
          display: "Right part: 12 × 11 = 132",
          description: "Multiply the deficiencies",
          audioText: "Multiply the two deficiencies: 12 times 11 equals 132.",
        ),
        ExampleStep(
          display: "Combine: 77||32 = 7832 (carry 1 from 132)",
          description: "Answer is 7832",
          audioText: "Write 77, then add the carry from 132 to get 7832.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra11Example() {
    // Sutra 11: Vyastisamastih - Part and whole
    return SutraExample(
      problem: "(x + 2)(x + 4)",
      steps: [
        ExampleStep(
          display: "(x + 2)(x + 4)",
          description: "Expand using part and whole method",
          audioText: "Let's expand this expression by breaking it into parts.",
        ),
        ExampleStep(
          display: "First: x × x = x²",
          description: "Multiply first terms",
          audioText: "First, multiply x by x to get x squared.",
        ),
        ExampleStep(
          display: "Outer: x × 4 = 4x",
          description: "Multiply outer terms",
          audioText: "Then multiply x by 4 to get 4x.",
        ),
        ExampleStep(
          display: "Inner: 2 × x = 2x",
          description: "Multiply inner terms",
          audioText: "Next multiply 2 by x to get 2x.",
        ),
        ExampleStep(
          display: "Last: 2 × 4 = 8",
          description: "Multiply last terms",
          audioText: "Finally multiply 2 by 4 to get 8.",
        ),
        ExampleStep(
          display: "Combine: x² + 4x + 2x + 8 = x² + 6x + 8",
          description: "Sum all parts to get the whole",
          audioText: "Combine all parts: x squared plus 6x plus 8.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra12Example() {
    // Sutra 12: Śeṣanyankena Cāramena - The remainders by the last
    return SutraExample(
      problem: "Test if 7 divides 343",
      steps: [
        ExampleStep(
          display: "343 ÷ 7 = ?",
          description: "Check divisibility using remainder method",
          audioText: "Let's check if 343 is divisible by 7 using the remainder method.",
        ),
        ExampleStep(
          display: "Last digit = 3",
          description: "Identify the last digit",
          audioText: "The last digit of 343 is 3.",
        ),
        ExampleStep(
          display: "Remaining = 34",
          description: "Take the remaining digits",
          audioText: "The remaining number is 34.",
        ),
        ExampleStep(
          display: "Multiply last digit by 2: 3 × 2 = 6",
          description: "For divisibility by 7, multiply last digit by 2",
          audioText: "Multiply the last digit 3 by 2 to get 6.",
        ),
        ExampleStep(
          display: "Subtract: 34 - 6 = 28",
          description: "Subtract from remaining number",
          audioText: "Subtract 6 from 34 to get 28.",
        ),
        ExampleStep(
          display: "28 ÷ 7 = 4 ✓",
          description: "28 is divisible by 7, so 343 is too!",
          audioText: "Since 28 is divisible by 7, we know 343 is also divisible by 7.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra13Example() {
    // Sutra 13: Sopaantyadvayamantyam - Ultimate and twice penultimate
    return SutraExample(
      problem: "13 × 17",
      steps: [
        ExampleStep(
          display: "13 × 17",
          description: "Multiply numbers with pattern using ultimate and penultimate",
          audioText: "Let's multiply 13 and 17 using the special pattern method.",
        ),
        ExampleStep(
          display: "Both have same decade: 10",
          description: "Both numbers are in the tens",
          audioText: "Notice both numbers are in their tens: 13 and 17.",
        ),
        ExampleStep(
          display: "Ultimate digits: 3 and 7",
          description: "Last digits are 3 and 7",
          audioText: "The ultimate or last digits are 3 and 7.",
        ),
        ExampleStep(
          display: "Check: 3 + 7 = 10",
          description: "Last digits sum to 10",
          audioText: "Notice that 3 plus 7 equals 10.",
        ),
        ExampleStep(
          display: "Left part: 1 × (1 + 1) = 1 × 2 = 2",
          description: "Multiply first digit by one more than itself",
          audioText: "Take the first digit 1, multiply by one more: 1 times 2 equals 2.",
        ),
        ExampleStep(
          display: "Right part: 3 × 7 = 21",
          description: "Multiply the ultimate digits",
          audioText: "Multiply the last digits: 3 times 7 equals 21.",
        ),
        ExampleStep(
          display: "Answer: 2||21 = 221",
          description: "Combine parts to get 221",
          audioText: "Combine 2 and 21 to get 221.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra14Example() {
    // Sutra 14: Ekanyūnena Pūrvena - By one less than the previous
    return SutraExample(
      problem: "Convert 1/9 to decimal",
      steps: [
        ExampleStep(
          display: "1 ÷ 9 = ?",
          description: "Convert fraction to decimal using one-less pattern",
          audioText: "Let's convert 1 divided by 9 to a decimal using the one-less pattern.",
        ),
        ExampleStep(
          display: "Denominator = 9",
          description: "We're dividing by 9",
          audioText: "The denominator is 9.",
        ),
        ExampleStep(
          display: "One less than 9 = 8",
          description: "Take one less than denominator",
          audioText: "One less than 9 is 8.",
        ),
        ExampleStep(
          display: "Pattern: 8 ÷ 9 = 0.888...",
          description: "But we want 1÷9, not 8÷9",
          audioText: "If we had 8 divided by 9, it would be 0.888 repeating.",
        ),
        ExampleStep(
          display: "Since 1 is one-ninth of 9",
          description: "1/9 is the pattern divided by 8",
          audioText: "Since 1 is one part of 9.",
        ),
        ExampleStep(
          display: "Answer: 0.111... (repeating)",
          description: "1÷9 = 0.111 repeating",
          audioText: "The answer is 0.111 repeating. Each digit is 1.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra15Example() {
    // Sutra 15: Gunitasamuchyah - Product of sum
    return SutraExample(
      problem: "Find x, y where xy = x + y",
      steps: [
        ExampleStep(
          display: "xy = x + y",
          description: "Solve equation where product equals sum",
          audioText: "Let's find values where the product of two numbers equals their sum.",
        ),
        ExampleStep(
          display: "Rearrange: xy - x - y = 0",
          description: "Move all terms to one side",
          audioText: "Rearrange to get xy minus x minus y equals zero.",
        ),
        ExampleStep(
          display: "Add 1 to both sides: xy - x - y + 1 = 1",
          description: "Add 1 for factoring",
          audioText: "Add 1 to both sides.",
        ),
        ExampleStep(
          display: "Factor: (x-1)(y-1) = 1",
          description: "Factor the left side",
          audioText: "This factors as x minus 1 times y minus 1 equals 1.",
        ),
        ExampleStep(
          display: "Solutions: x-1=1, y-1=1",
          description: "Both factors equal 1",
          audioText: "For this to equal 1, both factors must be 1.",
        ),
        ExampleStep(
          display: "Answer: x = 2, y = 2",
          description: "Special case solution",
          audioText: "Therefore x equals 2 and y equals 2. Check: 2 times 2 equals 4, and 2 plus 2 equals 4.",
        ),
      ],
    );
  }
  
  static SutraExample _getSutra16Example() {
    // Sutra 16: Gunakasamuchyah - Factors of sum
    return SutraExample(
      problem: "Factor: x² + 7x + 12",
      steps: [
        ExampleStep(
          display: "x² + 7x + 12",
          description: "Factor using sum-product relationships",
          audioText: "Let's factor x squared plus 7x plus 12.",
        ),
        ExampleStep(
          display: "Need two numbers that:",
          description: "Find factors with special properties",
          audioText: "We need two numbers with special properties.",
        ),
        ExampleStep(
          display: "Multiply to give: 12",
          description: "Product equals constant term",
          audioText: "First, they must multiply to give 12.",
        ),
        ExampleStep(
          display: "Add to give: 7",
          description: "Sum equals coefficient of x",
          audioText: "Second, they must add to give 7.",
        ),
        ExampleStep(
          display: "Try factors of 12: 1×12, 2×6, 3×4",
          description: "List factor pairs",
          audioText: "The factor pairs of 12 are: 1 and 12, 2 and 6, 3 and 4.",
        ),
        ExampleStep(
          display: "Check: 3 + 4 = 7 ✓ and 3 × 4 = 12 ✓",
          description: "3 and 4 satisfy both conditions",
          audioText: "Perfect! 3 plus 4 equals 7, and 3 times 4 equals 12.",
        ),
        ExampleStep(
          display: "Answer: (x + 3)(x + 4)",
          description: "Final factored form",
          audioText: "The factored form is x plus 3, times x plus 4.",
        ),
      ],
    );
  }
  
  static List<PracticeStep> _getSutra9PracticeSteps(String problem) {
    // Sutra 9: Calana-Kalanābhyām - Pattern and sequence problems
    try {
      if (problem.contains('1-50')) {
        return [
          PracticeStep(
            instruction: "Identify the pattern: (1+50), (2+49), (3+48)...",
            expectedAnswer: "51",
            hint: "Each pair sums to 51",
            formula: "Pair sum method",
          ),
          PracticeStep(
            instruction: "How many pairs can we make from 50 numbers?",
            expectedAnswer: "25",
            hint: "50 ÷ 2 = 25 pairs",
            formula: "Total numbers / 2",
          ),
          PracticeStep(
            instruction: "What is 25 × 51?",
            expectedAnswer: "1275",
            hint: "Number of pairs × sum per pair",
            formula: "25 × 51 = 1275",
          ),
        ];
      }
    } catch (e) {
      print('Error parsing Sutra 9 practice: $e');
    }
    
    return [
      PracticeStep(
        instruction: "Find the sum using pair method",
        expectedAnswer: "1275",
        hint: "Make pairs that sum to same value",
        formula: "Sum = n(n+1)/2",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra10PracticeSteps(String problem) {
    // Sutra 10: Yāvadūnam - Deficiency method
    try {
      final parts = problem.split('×');
      if (parts.length == 2) {
        final num1 = int.parse(parts[0].trim());
        final num2 = int.parse(parts[1].trim());
        
        final base = 100;
        final def1 = base - num1;
        final def2 = base - num2;
        final leftPart = num1 - def2;
        final rightPart = def1 * def2;
        final answer = leftPart * 100 + rightPart;
        
        return [
          PracticeStep(
            instruction: "What is the base?",
            expectedAnswer: "$base",
            hint: "Both numbers are near 100",
            formula: "Base = 100",
          ),
          PracticeStep(
            instruction: "Deficiency from base: $base - $num1 = ?",
            expectedAnswer: "$def1",
            hint: "Subtract from base",
            formula: "$base - $num1",
          ),
          PracticeStep(
            instruction: "Cross-subtract: $num1 - $def2 = ?",
            expectedAnswer: "$leftPart",
            hint: "Subtract second deficiency from first number",
            formula: "$num1 - $def2",
          ),
          PracticeStep(
            instruction: "Multiply deficiencies: $def1 × $def2 = ?",
            expectedAnswer: "$rightPart",
            hint: "Multiply both deficiencies",
            formula: "$def1 × $def2",
          ),
          PracticeStep(
            instruction: "Combine to get final answer",
            expectedAnswer: "$answer",
            hint: "Left part || right part (with carry if needed)",
            formula: "$leftPart||$rightPart = $answer",
          ),
        ];
      }
    } catch (e) {
      print('Error parsing Sutra 10 practice: $e');
    }
    
    return [
      PracticeStep(
        instruction: "Solve using deficiency method",
        expectedAnswer: "result",
        hint: "Find base and deficiencies",
        formula: "Cross-subtract and multiply",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra11PracticeSteps(String problem) {
    // Sutra 11: Vyastisamastih - Part and whole (FOIL)
    try {
      if (problem.contains('(x+') || problem.contains('(x-')) {
        return [
          PracticeStep(
            instruction: "First: Multiply x × x = ?",
            expectedAnswer: "x²",
            hint: "x times x",
            formula: "x²",
          ),
          PracticeStep(
            instruction: "Identify the middle term coefficient",
            expectedAnswer: "varies",
            hint: "Sum of outer and inner products",
            formula: "Outer + Inner",
          ),
          PracticeStep(
            instruction: "Last: Multiply the constant terms",
            expectedAnswer: "varies",
            hint: "Last term × last term",
            formula: "Constant product",
          ),
        ];
      }
    } catch (e) {
      print('Error parsing Sutra 11 practice: $e');
    }
    
    return [
      PracticeStep(
        instruction: "Expand the expression using FOIL",
        expectedAnswer: "expanded",
        hint: "First, Outer, Inner, Last",
        formula: "Part by part expansion",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra12PracticeSteps(String problem) {
    // Sutra 12: Śeṣanyankena Cāramena - Remainder method
    return [
      PracticeStep(
        instruction: "Identify the last digit",
        expectedAnswer: "last",
        hint: "Take the rightmost digit",
        formula: "Last digit",
      ),
      PracticeStep(
        instruction: "Multiply last digit by 2",
        expectedAnswer: "double",
        hint: "For divisibility by 7, multiply by 2",
        formula: "Last × 2",
      ),
      PracticeStep(
        instruction: "Subtract from remaining number",
        expectedAnswer: "result",
        hint: "Remaining - (last × 2)",
        formula: "Check if result divisible",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra13PracticeSteps(String problem) {
    // Sutra 13: Sopaantyadvayamantyam - Ultimate and penultimate
    try {
      final parts = problem.split('×');
      if (parts.length == 2) {
        final num1 = int.parse(parts[0].trim());
        final num2 = int.parse(parts[1].trim());
        
        final tens1 = num1 ~/ 10;
        final ones1 = num1 % 10;
        final ones2 = num2 % 10;
        
        if (ones1 + ones2 == 10 && tens1 == num2 ~/ 10) {
          final leftPart = tens1 * (tens1 + 1);
          final rightPart = ones1 * ones2;
          
          return [
            PracticeStep(
              instruction: "Check: Do last digits sum to 10? ($ones1 + $ones2)",
              expectedAnswer: "10",
              hint: "$ones1 + $ones2 should equal 10",
              formula: "Ultimate sum check",
            ),
            PracticeStep(
              instruction: "Left part: $tens1 × ${tens1 + 1} = ?",
              expectedAnswer: "$leftPart",
              hint: "First digit × (first digit + 1)",
              formula: "$tens1 × ${tens1 + 1}",
            ),
            PracticeStep(
              instruction: "Right part: $ones1 × $ones2 = ?",
              expectedAnswer: "$rightPart",
              hint: "Multiply last digits",
              formula: "$ones1 × $ones2",
            ),
            PracticeStep(
              instruction: "Combine the parts",
              expectedAnswer: "${leftPart * 100 + rightPart}",
              hint: "Write left part, then right part",
              formula: "$leftPart||$rightPart",
            ),
          ];
        }
      }
    } catch (e) {
      print('Error parsing Sutra 13 practice: $e');
    }
    
    return [
      PracticeStep(
        instruction: "Solve using ultimate-penultimate pattern",
        expectedAnswer: "result",
        hint: "Check if last digits sum to 10",
        formula: "First×(First+1) || Last×Last",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra14PracticeSteps(String problem) {
    // Sutra 14: Ekanyūnena Pūrvena - One less pattern for fractions
    return [
      PracticeStep(
        instruction: "Identify the denominator",
        expectedAnswer: "9",
        hint: "Bottom number of fraction",
        formula: "1/9",
      ),
      PracticeStep(
        instruction: "One less than denominator",
        expectedAnswer: "8",
        hint: "9 - 1 = 8",
        formula: "Denominator - 1",
      ),
      PracticeStep(
        instruction: "For 1/9, the decimal repeats which digit?",
        expectedAnswer: "1",
        hint: "0.111... repeating",
        formula: "Reciprocal pattern",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra15PracticeSteps(String problem) {
    // Sutra 15: Gunitasamuchyah - Product equals sum
    return [
      PracticeStep(
        instruction: "Rearrange: xy - x - y = ?",
        expectedAnswer: "0",
        hint: "Move all terms to one side",
        formula: "xy - x - y = 0",
      ),
      PracticeStep(
        instruction: "Add 1 to both sides and factor: (x-1)(y-1) = ?",
        expectedAnswer: "1",
        hint: "Factor the expression",
        formula: "(x-1)(y-1) = 1",
      ),
      PracticeStep(
        instruction: "If x = 2, what is y?",
        expectedAnswer: "2",
        hint: "Substitute and solve",
        formula: "Special case: x=y=2",
      ),
    ];
  }
  
  static List<PracticeStep> _getSutra16PracticeSteps(String problem) {
    // Sutra 16: Gunakasamuchyah - Factorization
    try {
      if (problem.contains('x²')) {
        return [
          PracticeStep(
            instruction: "What two numbers multiply to give the constant term?",
            expectedAnswer: "factors",
            hint: "Find factor pairs",
            formula: "Product of factors",
          ),
          PracticeStep(
            instruction: "Which pair adds to give the x coefficient?",
            expectedAnswer: "sum",
            hint: "Check sum of each pair",
            formula: "Sum equals middle term",
          ),
          PracticeStep(
            instruction: "Write in factored form: (x + ?)(x + ?)",
            expectedAnswer: "factored",
            hint: "Use the two numbers found",
            formula: "Final factored form",
          ),
        ];
      }
    } catch (e) {
      print('Error parsing Sutra 16 practice: $e');
    }
    
    return [
      PracticeStep(
        instruction: "Factor the expression",
        expectedAnswer: "factored",
        hint: "Find numbers that multiply and add correctly",
        formula: "Sum-product relationship",
      ),
    ];
  }
}
