import 'models/vedic_method_models.dart';

List<VedicMethodCategory> getVedicMethodCategories() {
  return [
    // SUBTRACTION
    VedicMethodCategory(
      name: 'subtraction',
      icon: '➖',
      color: '0xFFFF6B6B',
      methods: [
        VedicMethod(
          id: 'sub_001',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'subtraction',
          difficulty: '2-digit',
          isCompleted: true,
          problem: '87 - 34',
          answer: '53',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Break second number into tens and ones',
              description: 'Separate 34 into 30 and 4',
              calculation: '34 = 30 + 4',
              breakdownLines: ['30', '4'],
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Subtract tens first',
              description: 'Subtract 30 from 87',
              calculation: '87 - 30 = 57',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Subtract ones',
              description: 'Subtract 4 from 57',
              calculation: '57 - 4 = 53',
            ),
          ],
        ),
      ],
    ),
    
    // ADDITION
    VedicMethodCategory(
      name: 'Addition',
      icon: '➕',
      color: '0xFF4CAF50',
      methods: [
        VedicMethod(
          id: 'add_001',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'addition',
          difficulty: '2-digit',
          isCompleted: true,
          problem: '52 + 19',
          answer: '71',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Break second number into tens and ones',
              description: 'Separate 19 into 10 and 9',
              calculation: '19 = 10 + 9',
              breakdownLines: ['10', '9'],
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Add tens first',
              description: 'Add 10 to 52',
              calculation: '52 + 10 = 62',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Add ones',
              description: 'Add 9 to 62',
              calculation: '62 + 9 = 71',
            ),
          ],
        ),
        VedicMethod(
          id: 'add_002',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'addition',
          difficulty: '2-digit',
          isOngoing: true,
          problem: '45 + 27',
          answer: '72',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Break second number into tens and ones',
              description: 'Separate 27 into 20 and 7',
              calculation: '27 = 20 + 7',
              breakdownLines: ['20', '7'],
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Add tens first',
              description: 'Add 20 to 45',
              calculation: '45 + 20 = 65',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Add ones',
              description: 'Add 7 to 65',
              calculation: '65 + 7 = 72',
            ),
          ],
        ),
        VedicMethod(
          id: 'add_003',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'addition',
          difficulty: '2-digit',
          isLocked: true,
          problem: '68 + 35',
          answer: '103',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Break second number into tens and ones',
              description: 'Separate 35 into 30 and 5',
              calculation: '35 = 30 + 5',
              breakdownLines: ['30', '5'],
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Add tens first',
              description: 'Add 30 to 68',
              calculation: '68 + 30 = 98',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Add ones',
              description: 'Add 5 to 98',
              calculation: '98 + 5 = 103',
            ),
          ],
        ),
      ],
    ),
    
    // MULTIPLICATION
    VedicMethodCategory(
      name: 'Multiplication',
      icon: '✖️',
      color: '0xFF2196F3',
      methods: [
        VedicMethod(
          id: 'mul_001',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'multiplication',
          difficulty: '2-digit',
          isCompleted: true,
          problem: '23 × 11',
          answer: '253',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Write the first number twice',
              description: 'For multiplying by 11, write 2 and 3',
              calculation: '2_3',
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Add the digits',
              description: 'Add 2 + 3 = 5',
              calculation: '2 + 3 = 5',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Place sum in middle',
              description: 'Place 5 between 2 and 3',
              calculation: '2 5 3 = 253',
            ),
          ],
        ),
        VedicMethod(
          id: 'mul_002',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'multiplication',
          difficulty: '2-digit',
          isLocked: true,
          problem: '34 × 11',
          answer: '374',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Write the first number twice',
              description: 'For multiplying by 11, write 3 and 4',
              calculation: '3_4',
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Add the digits',
              description: 'Add 3 + 4 = 7',
              calculation: '3 + 4 = 7',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Place sum in middle',
              description: 'Place 7 between 3 and 4',
              calculation: '3 7 4 = 374',
            ),
          ],
        ),
      ],
    ),
    
    // DIVISION
    VedicMethodCategory(
      name: 'Division',
      icon: '➗',
      color: '0xFF9C27B0',
      methods: [
        VedicMethod(
          id: 'div_001',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'division',
          difficulty: '2-digit',
          isCompleted: true,
          problem: '84 ÷ 4',
          answer: '21',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Divide tens',
              description: 'Divide 8 by 4',
              calculation: '8 ÷ 4 = 2',
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Divide ones',
              description: 'Divide 4 by 4',
              calculation: '4 ÷ 4 = 1',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Combine results',
              description: 'Combine 2 and 1',
              calculation: '21',
            ),
          ],
        ),
        VedicMethod(
          id: 'div_002',
          title: 'Addition of 2- digit number',
          description: 'You have to add separate numbers.',
          operation: 'division',
          difficulty: '2-digit',
          isLocked: true,
          problem: '96 ÷ 8',
          answer: '12',
          steps: [
            MethodStep(
              stepNumber: 1,
              title: 'Divide tens',
              description: 'Divide 9 by 8, remainder becomes 1',
              calculation: '9 ÷ 8 = 1 R1',
            ),
            MethodStep(
              stepNumber: 2,
              title: 'Bring down ones',
              description: 'Combine remainder 1 with 6 = 16',
              calculation: '16 ÷ 8 = 2',
            ),
            MethodStep(
              stepNumber: 3,
              title: 'Combine results',
              description: 'Result is 12',
              calculation: '12',
            ),
          ],
        ),
      ],
    ),
  ];
}
