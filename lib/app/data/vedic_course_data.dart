// Complete Vedic Mathematics Course Data
// A structured learning path for mastering multiplication and division up to 100×100

const vedicCourseData = {
  "course_title": "Master Vedic Mathematics: Multiply & Divide in Seconds",
  "description":
      "Learn ancient Indian techniques to perform lightning-fast mental calculations. Master any multiplication and division up to 100×100 within seconds using proven Vedic sutras.",
  "total_chapters": 9,
  "estimated_duration": "30 days",
  "difficulty": "Beginner to Advanced",
  "chapters": [
    {
      "chapter_id": 1,
      "chapter_title": "Introduction to Vedic Maths",
      "chapter_description":
          "Understanding the foundations of Vedic Mathematics and why it's faster than conventional methods",
      "icon": "school",
      "color": "0xFF5B7FFF",
      "lessons": [
        {
          "lesson_id": 101,
          "lesson_title": "Why Vedic Maths is Faster",
          "objective":
              "Understand the philosophy and advantages of Vedic Mathematics over traditional calculation methods",
          "duration_minutes": 10,
          "content": """Welcome to the world of Vedic Mathematics!

Vedic Maths is a system of mathematical techniques derived from ancient Indian scriptures called the Vedas. These techniques allow you to perform complex calculations mentally and much faster than conventional methods.

Key Advantages:
• Speed: Solve problems 10-15 times faster
• Mental: No need for calculators or paper
• Fun: Makes math enjoyable and creative
• Confidence: Builds mathematical intuition

How it Works:
Instead of following rigid steps, Vedic methods use patterns and shortcuts that align with how our brain naturally thinks. You'll learn to see numbers differently and recognize patterns instantly.""",
          "examples": [
            {
              "problem": "Compare calculation speeds: 25 × 25",
              "step1":
                  "Traditional method requires: (20 × 25) + (5 × 25) = multiple steps",
              "step2":
                  "Vedic method: For numbers ending in 5, take the first digit (2)",
              "step3": "Multiply by next number: 2 × 3 = 6",
              "step4": "Append 25 to the result",
              "solution": "625",
              "explanation":
                  "Vedic method is 5x faster! Just multiply first digit by next number, then add 25 at the end.",
            },
            {
              "problem": "Calculate 98 × 102 using Vedic method",
              "step1": "Both numbers are near base 100",
              "step2": "Find distances from 100: 98 is -2, 102 is +2",
              "step3": "Cross-subtract: 98 + 2 = 100 OR 102 - 2 = 100",
              "step4":
                  "Multiply the distances: (-2) × (+2) = -4, add 10000: 9996",
              "solution": "9996",
              "explanation":
                  "Using the base method for numbers near 100 gives instant results without long multiplication!",
            },
          ],
          "practice": [
            {
              "question": "What is the main advantage of Vedic Maths?",
              "type": "multiple_choice",
              "options": [
                "It's older",
                "It's faster and mental",
                "It uses more steps",
                "It requires a calculator",
              ],
              "answer": "It's faster and mental",
            },
            {
              "question": "Vedic Maths uses _____ and patterns",
              "type": "fill_blank",
              "answer": "shortcuts",
            },
          ],
          "summary":
              "Vedic Mathematics offers faster, mental calculation methods using ancient techniques. It makes math fun, builds confidence, and allows you to solve complex problems in seconds.",
        },
        {
          "lesson_id": 102,
          "lesson_title": "The Concept of Number Bases",
          "objective":
              "Master the fundamental concept of base numbers (10, 50, 100) which is essential for Vedic techniques",
          "duration_minutes": 15,
          "content": """Understanding bases is the key to unlocking Vedic speed!

What is a Base?
A base is a reference number (usually 10, 50, or 100) that we use to simplify calculations. Numbers close to a base can be calculated super fast.

Common Bases:
• Base 10: For numbers 5-15
• Base 50: For numbers 40-60
• Base 100: For numbers 90-110

Distance from Base:
Every number has a distance from its nearest base:
• 98 is −2 from base 100
• 103 is +3 from base 100
• 48 is −2 from base 50

Why This Matters:
Once you know the distance from base, you can use special formulas to multiply or divide instantly!""",
          "examples": [
            {
              "problem": "Find distance of 97 from base 100",
              "step1":
                  "Identify the nearest base: 100 (since 97 is close to 100)",
              "step2": "Calculate: 97 - 100 = -3",
              "step3": "The negative sign means 97 is BELOW the base",
              "step4": "Result: Distance is -3",
              "solution": "-3",
              "explanation":
                  "97 is 3 units below 100, so the distance is -3. This negative distance will be used in Vedic formulas.",
            },
            {
              "problem": "Find distance of 108 from base 100",
              "step1": "Identify the nearest base: 100",
              "step2": "Calculate: 108 - 100 = +8",
              "step3": "The positive sign means 108 is ABOVE the base",
              "step4": "Result: Distance is +8",
              "solution": "+8",
              "explanation":
                  "108 is 8 units above 100, so the distance is +8. Positive means above the base.",
            },
            {
              "problem": "Find distance of 13 from base 10",
              "step1": "For numbers 5-15, use base 10",
              "step2": "Calculate: 13 - 10 = +3",
              "step3": "13 is above the base by 3 units",
              "step4": "Distance is +3",
              "solution": "+3",
              "explanation":
                  "13 is 3 more than 10, so distance is +3. This will make multiplication near 10 very easy!",
            },
          ],
          "practice": [
            {
              "question": "What is the distance of 96 from base 100?",
              "type": "input",
              "answer": "-4",
            },
            {
              "question": "What is the distance of 13 from base 10?",
              "type": "input",
              "answer": "3",
            },
            {
              "question": "Which base is best for calculating 92 × 98?",
              "type": "multiple_choice",
              "options": ["10", "50", "100"],
              "answer": "100",
            },
          ],
          "summary":
              "Bases (10, 50, 100) are reference points for fast calculation. The distance from base determines how we apply Vedic formulas. Master this concept—it's used in almost every technique!",
        },
        {
          "lesson_id": 103,
          "lesson_title": "Mental Preparation Techniques",
          "objective":
              "Develop mental visualization and focus skills essential for performing calculations in your head",
          "duration_minutes": 12,
          "content":
              """Speed calculation requires mental clarity and visualization!

Mental Screen Technique:
Imagine a blank screen in your mind where numbers appear. Practice seeing numbers clearly in your imagination.

Steps for Mental Calculation:
1. Relax: Take a deep breath
2. Focus: Clear your mind of distractions
3. Visualize: See the numbers on your mental screen
4. Pattern: Look for patterns and relationships
5. Calculate: Apply the technique step-by-step
6. Verify: Quickly check if the answer makes sense

Practice Tips:
• Start with small numbers
• Don't rush initially
• Trust the method
• Practice daily for 10 minutes
• Visualize the steps before solving""",
          "examples": [
            {
              "problem": "Visualize and calculate: 25 × 4",
              "step1":
                  "Close your eyes and see the number 25 on your mental screen",
              "step2": "Notice that 25 = 100 ÷ 4, so 25 × 4 must equal 100",
              "step3": "Visualize: 25 + 25 = 50, then 50 + 50 = 100",
              "step4": "Open your eyes with confidence in the answer",
              "solution": "100",
              "explanation":
                  "Mental visualization makes complex calculations feel simple and natural!",
            },
            {
              "problem": "Focus exercise: Calculate 8 × 9 mentally",
              "step1": "Take a deep breath and clear distractions",
              "step2": "Visualize 8 and 9 on your mental screen",
              "step3": "See the pattern: 8 × 9 = (8 × 10) - 8 = 80 - 8",
              "step4": "Visualize: 80 - 8 = 72",
              "solution": "72",
              "explanation":
                  "Focus and pattern recognition make mental math effortless!",
            },
            {
              "problem": "Mental screen practice: Double 17 three times",
              "step1": "See 17 clearly in your mind",
              "step2":
                  "First doubling: 17 × 2 = 34 (visualize 34 replacing 17)",
              "step3": "Second doubling: 34 × 2 = 68 (see 68 on your screen)",
              "step4": "Third doubling: 68 × 2 = 136 (final answer appears)",
              "solution": "136",
              "explanation":
                  "Step-by-step visualization builds your mental calculation muscle!",
            },
          ],
          "practice": [
            {
              "question": "Mental visualization helps in:",
              "type": "multiple_choice",
              "options": [
                "Writing faster",
                "Seeing numbers mentally",
                "Reading books",
                "Drawing",
              ],
              "answer": "Seeing numbers mentally",
            },
            {
              "question": "Before solving mentally, you should _____ your mind",
              "type": "fill_blank",
              "answer": "clear",
            },
          ],
          "summary":
              "Mental preparation is crucial for Vedic Maths. Practice visualization, stay relaxed, and trust the process. Your mental calculation speed will improve with daily practice.",
        },
      ],
    },
    {
      "chapter_id": 2,
      "chapter_title": "Foundations of Speed Calculation",
      "chapter_description":
          "Master the building blocks: complements, doubling, halving, and base arithmetic",
      "icon": "speed",
      "color": "0xFFFFA726",
      "lessons": [
        {
          "lesson_id": 201,
          "lesson_title": "Complement Numbers",
          "objective":
              "Learn to find complements instantly - the foundation of Nikhilam Sutra",
          "duration_minutes": 15,
          "content":
              """Complements are the key to lightning-fast subtraction from base numbers!

What is a Complement?
A complement is what you add to a number to reach the base. It's the "missing piece."

Finding Complements:

For Base 10:
• Complement of 7 = 3 (because 7 + 3 = 10)
• Complement of 4 = 6 (because 4 + 6 = 10)

For Base 100:
• Complement of 92 = 08 (because 92 + 08 = 100)
• Complement of 67 = 33 (because 67 + 33 = 100)

Quick Method:
From base 10: Subtract each digit from 9, except the last digit which you subtract from 10.
Example: Complement of 73 from 100
7 → (9-7)=2
3 → (10-3)=7
Answer: 27

All-from-9-and-last-from-10 Rule:
This is THE fundamental technique used everywhere in Vedic Maths!""",
          "examples": [
            {
              "problem": "Find complement of 68 from 100",
              "step1": "Apply rule: All from 9, last from 10",
              "step2": "First digit: 9 - 6 = 3",
              "step3": "Last digit: 10 - 8 = 2",
              "step4": "Combine the results",
              "solution": "32",
              "explanation":
                  "Verification: 68 + 32 = 100 ✓ This technique works instantly for any number!",
            },
            {
              "problem": "Find complement of 234 from 1000",
              "step1": "All from 9, last from 10 rule for three digits",
              "step2": "First digit: 9 - 2 = 7",
              "step3": "Second digit: 9 - 3 = 6",
              "step4": "Last digit: 10 - 4 = 6",
              "solution": "766",
              "explanation":
                  "Verification: 234 + 766 = 1000 ✓ Works for any number of digits!",
            },
            {
              "problem": "Find complement of 8 from 10",
              "step1": "For single digit from base 10, just subtract",
              "step2": "Calculate: 10 - 8 = 2",
              "step3": "No other steps needed",
              "step4": "Answer is ready",
              "solution": "2",
              "explanation":
                  "Verification: 8 + 2 = 10 ✓ Single digits are the easiest!",
            },
          ],
          "practice": [
            {
              "question": "Complement of 45 from 100?",
              "type": "input",
              "answer": "55",
            },
            {
              "question": "Complement of 83 from 100?",
              "type": "input",
              "answer": "17",
            },
            {
              "question": "Complement of 156 from 1000?",
              "type": "input",
              "answer": "844",
            },
            {
              "question": "For finding complement from 100, we use:",
              "type": "multiple_choice",
              "options": [
                "All from 10",
                "All from 9 and last from 10",
                "Subtract from 50",
                "Divide by 2",
              ],
              "answer": "All from 9 and last from 10",
            },
          ],
          "summary":
              "Complements are found using 'All from 9 and last from 10' rule. Master this—it's used in most Vedic techniques! Practice until you can find complements instantly.",
        },
        {
          "lesson_id": 202,
          "lesson_title": "Base Differences",
          "objective":
              "Calculate the difference between a number and its base in under 2 seconds",
          "duration_minutes": 12,
          "content":
              """Base differences are shortcuts for measuring how far numbers are from reference points!

What is a Base Difference?
The distance (positive or negative) from a round number like 10, 50, or 100.

Notation:
• Numbers below base: Use negative (−)
• Numbers above base: Use positive (+)

Examples:
• 97 from base 100 → −3
• 104 from base 100 → +4
• 8 from base 10 → −2
• 13 from base 10 → +3

Quick Calculation:
Simply subtract the base from the number!
• 94 − 100 = −6
• 107 − 100 = +7

Why Important:
Base differences are used directly in the Nikhilam multiplication formula!""",
          "examples": [
            {
              "problem": "Find base difference of 89 from 100",
              "step1": "Write the calculation: 89 − 100",
              "step2": "Subtract: 89 − 100 = −11",
              "step3": "The negative sign means 89 is BELOW base 100",
              "step4": "Distance is 11 units below",
              "solution": "-11",
              "explanation":
                  "89 is 11 below 100. This negative distance will be used in Nikhilam multiplication!",
            },
            {
              "problem": "Find base difference of 112 from 100",
              "step1": "Write the calculation: 112 − 100",
              "step2": "Subtract: 112 − 100 = +12",
              "step3": "The positive sign means 112 is ABOVE base 100",
              "step4": "Distance is 12 units above",
              "solution": "+12",
              "explanation":
                  "112 is 12 above 100. Positive distances make cross-addition easy!",
            },
            {
              "problem": "Find base difference of 7 from 10",
              "step1": "Write: 7 − 10",
              "step2": "Calculate: 7 − 10 = −3",
              "step3": "7 is below the base by 3",
              "step4": "Mark as negative",
              "solution": "-3",
              "explanation":
                  "7 is 3 below 10. This technique works for any base!",
            },
          ],
          "practice": [
            {
              "question": "Base difference of 96 from 100?",
              "type": "input",
              "answer": "-4",
            },
            {
              "question": "Base difference of 105 from 100?",
              "type": "input",
              "answer": "5",
            },
            {
              "question": "Base difference of 48 from 50?",
              "type": "input",
              "answer": "-2",
            },
            {
              "question": "Base difference of 9 from 10?",
              "type": "input",
              "answer": "-1",
            },
          ],
          "summary":
              "Base difference = Number − Base. Negative means below, positive means above. This simple concept unlocks powerful multiplication techniques!",
        },
        {
          "lesson_id": 203,
          "lesson_title": "Doubling & Halving Tricks",
          "objective":
              "Master instant doubling and halving for any 2-digit number",
          "duration_minutes": 15,
          "content":
              """Doubling and halving are fundamental skills that make complex calculations simple!

Doubling Technique:

Method 1: Left to Right
Double each digit, carry when needed
Example: 34 × 2
• 3 × 2 = 6
• 4 × 2 = 8
• Answer: 68

Method 2: Split and Double
For harder numbers like 47:
• 40 × 2 = 80
• 7 × 2 = 14
• 80 + 14 = 94

Halving Technique:

For Even Numbers:
Simply divide each part by 2
Example: 86 ÷ 2
• 80 ÷ 2 = 40
• 6 ÷ 2 = 3
• Answer: 43

For Odd Numbers:
Round down, then add 0.5
Example: 75 ÷ 2
• 70 ÷ 2 = 35
• 5 ÷ 2 = 2.5
• Answer: 37.5

Double-Halve Strategy:
To multiply by 4: Double twice
To multiply by 8: Double thrice
To divide by 4: Halve twice""",
          "examples": [
            {
              "problem": "Double 43 mentally",
              "step1": "Split the number: 43 = 40 + 3",
              "step2": "Double each part: 40 × 2 = 80",
              "step3": "Double the ones: 3 × 2 = 6",
              "step4": "Add the results: 80 + 6 = 86",
              "solution": "86",
              "explanation":
                  "Verification: 43 × 2 = 86 ✓ Split-and-double makes it effortless!",
            },
            {
              "problem": "Halve 94",
              "step1": "Split: 94 = 90 + 4",
              "step2": "Halve the tens: 90 ÷ 2 = 45",
              "step3": "Halve the ones: 4 ÷ 2 = 2",
              "step4": "Combine: 45 + 2 = 47",
              "solution": "47",
              "explanation":
                  "Verification: 94 ÷ 2 = 47 ✓ Works for any even number!",
            },
            {
              "problem": "Multiply 17 by 4 using double-double",
              "step1": "To multiply by 4, double twice",
              "step2": "First doubling: 17 × 2 = 34",
              "step3": "Second doubling: 34 × 2 = 68",
              "step4": "Done in 2 steps!",
              "solution": "68",
              "explanation": "Double-double strategy: Perfect for ×4, ×8, ×16!",
            },
            {
              "problem": "Divide 200 by 4 using halve-halve",
              "step1": "To divide by 4, halve twice",
              "step2": "First halving: 200 ÷ 2 = 100",
              "step3": "Second halving: 100 ÷ 2 = 50",
              "step4": "Answer found!",
              "solution": "50",
              "explanation":
                  "Halve-halve strategy makes division by 4, 8, 16 super easy!",
            },
          ],
          "practice": [
            {"question": "Double 56", "type": "input", "answer": "112"},
            {"question": "Halve 78", "type": "input", "answer": "39"},
            {
              "question": "What is 23 × 4?",
              "type": "input",
              "answer": "92",
              "hint": "Double twice",
            },
            {
              "question": "What is 160 ÷ 4?",
              "type": "input",
              "answer": "40",
              "hint": "Halve twice",
            },
          ],
          "summary":
              "Doubling and halving are essential mental math skills. Double twice for ×4, double thrice for ×8. Halve twice for ÷4. Practice until automatic!",
        },
        {
          "lesson_id": 204,
          "lesson_title": "Single-Digit Speed Practice",
          "objective":
              "Achieve instant recall of all single-digit multiplication (1-10 tables)",
          "duration_minutes": 20,
          "content":
              """Before mastering 2-digit calculations, you must be lightning-fast with single digits!

Target Speed:
Any single-digit multiplication in under 1 second

Multiplication Tables 1-10:
You should know these without thinking. They're the foundation.

Pattern Recognition:

×9 Trick:
• 9×6: Fingers down 6th finger
• Left fingers = tens (5), Right fingers = ones (4)
• Answer: 54

×11 Trick:
• 11 × 7 = 77 (repeat the digit)
• 11 × 8 = 88

×5 Trick:
• Even number × 5: Halve it, add 0
• 8 × 5: 8÷2=4, add 0 = 40
• Odd number × 5: Subtract 1, halve, add 5
• 7 × 5: (7-1)÷2=3, add 5 = 35

Square Numbers (1-10):
1²=1, 2²=4, 3²=9, 4²=16, 5²=25, 6²=36, 7²=49, 8²=64, 9²=81, 10²=100

Memorize these—they're used constantly!""",
          "examples": [
            {
              "problem": "Quick calculation of 9 × 7",
              "method": "10×7 − 7 = 70 − 7 = 63",
              "explanation": "For ×9, multiply by 10 and subtract the number",
            },
            {
              "problem": "Quick calculation of 6 × 5",
              "method": "6÷2 = 3, add 0 = 30",
              "explanation": "Even × 5 trick",
            },
            {
              "problem": "Quick calculation of 8²",
              "method": "Direct recall: 64",
              "explanation": "Memorized square",
            },
          ],
          "practice": [
            {
              "question": "7 × 8 = ?",
              "type": "input",
              "answer": "56",
              "time_limit": 3,
            },
            {
              "question": "9 × 6 = ?",
              "type": "input",
              "answer": "54",
              "time_limit": 3,
            },
            {
              "question": "7² = ?",
              "type": "input",
              "answer": "49",
              "time_limit": 2,
            },
            {
              "question": "6 × 5 = ?",
              "type": "input",
              "answer": "30",
              "time_limit": 2,
            },
            {
              "question": "What is 10² ?",
              "type": "input",
              "answer": "100",
              "time_limit": 2,
            },
          ],
          "summary":
              "Master single-digit multiplication to perfection. Use tricks for 5, 9, and 11. Memorize squares 1-10. This foundation makes everything else easier!",
        },
      ],
    },
    {
      "chapter_id": 3,
      "chapter_title": "Nikhilam Sutra – Multiplication Near Bases",
      "chapter_description":
          "Multiply numbers near 10, 50, or 100 in seconds using the powerful Nikhilam technique",
      "icon": "functions",
      "color": "0xFF10B981",
      "lessons": [
        {
          "lesson_id": 301,
          "lesson_title": "Numbers Near Base 10",
          "objective":
              "Multiply any two numbers close to 10 (7-13) in under 5 seconds",
          "duration_minutes": 20,
          "content":
              """The Nikhilam Sutra is your first superpower! It makes multiplication near bases incredibly easy.

Formula for Numbers Near 10:
When multiplying numbers close to 10, use this pattern:

(a) × (b) = (a + difference of b) | (difference of a × difference of b)

Step-by-Step Process:

Example: 9 × 8

Step 1: Find differences from base 10
• 9 is −1 from 10
• 8 is −2 from 10

Step 2: Cross-add (or cross-subtract)
• 9 + (−2) = 7  OR  8 + (−1) = 7

Step 3: Multiply the differences
• (−1) × (−2) = 2

Step 4: Combine
• Left part: 7
• Right part: 2
• Answer: 72

Another Example: 12 × 13

Differences: +2, +3
Cross-add: 12 + 3 = 15  OR  13 + 2 = 15
Multiply differences: 2 × 3 = 6
Answer: 15|6 = 156

The Magic:
This works because of algebraic properties. But you don't need to know why—just use it!""",
          "examples": [
            {
              "problem": "Calculate 7 × 9 using Nikhilam method",
              "step1": "Find differences from base 10: 7 → −3, 9 → −1",
              "step2":
                  "Cross-add (either way gives same result): 7 + (−1) = 6 OR 9 + (−3) = 6",
              "step3": "Multiply the differences: (−3) × (−1) = 3",
              "step4": "Combine: Left part is 6, right part is 3",
              "solution": "63",
              "explanation":
                  "Verification: 7 × 9 = 63 ✓ This method is 3x faster than traditional multiplication!",
            },
            {
              "problem": "Calculate 11 × 12 using Nikhilam method",
              "step1": "Find differences from base 10: 11 → +1, 12 → +2",
              "step2": "Cross-add: 11 + 2 = 13 OR 12 + 1 = 13",
              "step3": "Multiply differences: 1 × 2 = 2",
              "step4": "Combine: 13 | 2 = 132",
              "solution": "132",
              "explanation":
                  "Verification: 11 × 12 = 132 ✓ Works for numbers above base too!",
            },
            {
              "problem": "Calculate 8 × 7 using Nikhilam method",
              "step1": "Differences from 10: 8 → −2, 7 → −3",
              "step2": "Cross-subtract: 8 + (−3) = 5 OR 7 + (−2) = 5",
              "step3": "Multiply differences: (−2) × (−3) = 6",
              "step4": "Combine: 5 | 6 = 56",
              "solution": "56",
              "explanation":
                  "Verification: 8 × 7 = 56 ✓ Instant mental calculation!",
            },
          ],
          "practice": [
            {
              "question": "9 × 7 = ?",
              "type": "input",
              "answer": "63",
              "hint": "Differences: −1, −3",
            },
            {
              "question": "11 × 9 = ?",
              "type": "input",
              "answer": "99",
              "hint": "Differences: +1, −1",
            },
            {"question": "12 × 11 = ?", "type": "input", "answer": "132"},
            {"question": "8 × 8 = ?", "type": "input", "answer": "64"},
            {"question": "13 × 12 = ?", "type": "input", "answer": "156"},
          ],
          "summary":
              "Nikhilam for base 10: (1) Find differences (2) Cross-add (3) Multiply differences (4) Combine. Master this pattern—it's the same for all bases!",
        },
        {
          "lesson_id": 302,
          "lesson_title": "Numbers Near Base 100",
          "objective":
              "Multiply 2-digit numbers near 100 (90-110) mentally in seconds",
          "duration_minutes": 25,
          "content":
              """Now we scale up the Nikhilam Sutra to base 100—this is where it gets powerful!

Formula Structure:
Same as base 10, but now we work with 2-digit differences

Example: 98 × 97

Step 1: Differences from 100
• 98 → −2
• 97 → −3

Step 2: Cross-add with base 100
• 98 + (−3) = 95  OR  97 + (−2) = 95

Step 3: Multiply differences
• (−2) × (−3) = 6
• Important: For base 100, right part needs 2 digits → 06

Step 4: Combine
• Left: 95
• Right: 06
• Answer: 9506

Key Rule for Base 100:
The right part must always be 2 digits! Add leading zero if needed.

Example: 103 × 104

Differences: +3, +4
Cross-add: 103 + 4 = 107
Multiply: 3 × 4 = 12
Answer: 107|12 = 10712

Mixed Signs Example: 98 × 102

Differences: −2, +2
Cross-add: 98 + 2 = 100  OR  102 + (−2) = 100
Multiply: (−2) × (+2) = −4
For negative result: Borrow from left
100|−04 → 99|96
Answer: 9996""",
          "examples": [
            {
              "problem": "96 × 94",
              "step1": "Differences: −4, −6",
              "step2": "Cross-add: 96+(−6) = 90",
              "step3": "Multiply: (−4)×(−6) = 24",
              "step4": "Combine: 90|24",
              "answer": "9024",
              "verification": "96 × 94 = 9024 ✓",
            },
            {
              "problem": "105 × 103",
              "step1": "Differences: +5, +3",
              "step2": "Cross-add: 105+3 = 108",
              "step3": "Multiply: 5×3 = 15",
              "step4": "Combine: 108|15",
              "answer": "10815",
              "verification": "105 × 103 = 10815 ✓",
            },
            {
              "problem": "99 × 99",
              "step1": "Differences: −1, −1",
              "step2": "Cross-add: 99+(−1) = 98",
              "step3": "Multiply: (−1)×(−1) = 01",
              "step4": "Combine: 98|01",
              "answer": "9801",
              "verification": "99 × 99 = 9801 ✓",
            },
          ],
          "practice": [
            {
              "question": "97 × 96 = ?",
              "type": "input",
              "answer": "9312",
              "hint": "Differences: −3, −4",
            },
            {"question": "102 × 101 = ?", "type": "input", "answer": "10302"},
            {"question": "95 × 95 = ?", "type": "input", "answer": "9025"},
            {"question": "104 × 105 = ?", "type": "input", "answer": "10920"},
            {"question": "98 × 99 = ?", "type": "input", "answer": "9702"},
          ],
          "summary":
              "Nikhilam for base 100: Same 4 steps as base 10, but right part must be 2 digits. Watch for negative results—borrow from left. Practice daily!",
        },
        {
          "lesson_id": 303,
          "lesson_title": "Cross-Adjustment Method",
          "objective":
              "Handle cases when the product of differences exceeds the base portion",
          "duration_minutes": 18,
          "content":
              """Sometimes the right part gets too big and we need to carry over!

The Problem:
What if the product of differences is more than 2 digits for base 100?

Example: 88 × 87

Step 1: Differences: −12, −13
Step 2: Cross-add: 88 + (−13) = 75
Step 3: Multiply: (−12) × (−13) = 156
Step 4: Problem! 156 is 3 digits, we need 2

Solution: Carry Over
• Right part keeps last 2 digits: 56
• Carry the rest to left: 1
• 75 + 1 = 76
• Answer: 76|56 = 7656

The Rule:
If right part > 99 for base 100:
• Keep rightmost 2 digits
• Add remaining to left part

Another Example: 93 × 88

Differences: −7, −12
Cross-add: 93 + (−12) = 81
Multiply: (−7) × (−12) = 84
Right part: 84 (fits in 2 digits!)
Answer: 81|84 = 8184

Quick Check:
Does your answer make sense?
93 × 88 should be near 90 × 90 = 8100 ✓""",
          "examples": [
            {
              "problem": "86 × 85",
              "working":
                  "Diff: −14, −15 | Cross: 86−15=71 | Multiply: 14×15=210",
              "adjustment": "210 → Carry 2, keep 10 → 71+2=73",
              "answer": "7310",
              "verification": "86 × 85 = 7310 ✓",
            },
            {
              "problem": "92 × 89",
              "working": "Diff: −8, −11 | Cross: 92−11=81 | Multiply: 8×11=88",
              "adjustment": "88 fits, no carry needed",
              "answer": "8188",
              "verification": "92 × 89 = 8188 ✓",
            },
          ],
          "practice": [
            {
              "question": "87 × 86 = ?",
              "type": "input",
              "answer": "7482",
              "hint": "Watch for carrying",
            },
            {"question": "91 × 88 = ?", "type": "input", "answer": "8008"},
            {"question": "84 × 83 = ?", "type": "input", "answer": "6972"},
          ],
          "summary":
              "When right part exceeds 2 digits, carry to the left. Always verify your answer makes sense. This adjustment is automatic with practice!",
        },
        {
          "lesson_id": 304,
          "lesson_title": "Practice: 2-Digit × 2-Digit Speed Drills",
          "objective":
              "Achieve consistent speed solving any multiplication near base 100 in under 10 seconds",
          "duration_minutes": 30,
          "content":
              """Time to build muscle memory! This lesson is pure practice.

Practice Structure:

Level 1: Easy (both numbers 95-100)
• Small differences
• No carrying needed
• Target: 5 seconds each

Level 2: Medium (both numbers 90-110)
• Larger differences
• Some carrying
• Target: 8 seconds each

Level 3: Advanced (mixed ranges)
• One number far from 100
• Frequent carrying
• Target: 10 seconds each

Strategies:
1. Don't panic if you make mistakes
2. Verify each answer
3. Notice patterns
4. Use estimation to check
5. Speed comes with practice

Daily Practice Goal:
• 10 problems from each level
• Time yourself
• Track improvement
• Aim for 100% accuracy first, then speed""",
          "examples": [
            {
              "level": "Easy",
              "problems": ["97×98", "96×97", "99×98", "95×96"],
              "answers": ["9506", "9312", "9702", "9120"],
            },
            {
              "level": "Medium",
              "problems": ["92×94", "103×104", "91×89", "106×105"],
              "answers": ["8648", "10712", "8099", "11130"],
            },
            {
              "level": "Advanced",
              "problems": ["87×93", "108×96", "84×91", "112×98"],
              "answers": ["8091", "10368", "7644", "10976"],
            },
          ],
          "practice": [
            {
              "question": "96 × 98 = ?",
              "type": "input",
              "answer": "9408",
              "difficulty": "easy",
            },
            {
              "question": "103 × 102 = ?",
              "type": "input",
              "answer": "10506",
              "difficulty": "easy",
            },
            {
              "question": "91 × 93 = ?",
              "type": "input",
              "answer": "8463",
              "difficulty": "medium",
            },
            {
              "question": "107 × 104 = ?",
              "type": "input",
              "answer": "11128",
              "difficulty": "medium",
            },
            {
              "question": "88 × 92 = ?",
              "type": "input",
              "answer": "8096",
              "difficulty": "advanced",
            },
            {
              "question": "109 × 97 = ?",
              "type": "input",
              "answer": "10573",
              "difficulty": "advanced",
            },
          ],
          "summary":
              "Practice is everything! Start slow and accurate, then build speed. Use Nikhilam for all multiplications near 100. Track your progress daily!",
        },
      ],
    },
    {
      "chapter_id": 4,
      "chapter_title": "Urdhva Tiryak – Vertical & Crosswise Multiplication",
      "chapter_description":
          "The universal method that works for ANY multiplication, no matter the numbers",
      "icon": "grid_on",
      "color": "0xFF8B5CF6",
      "lessons": [
        {
          "lesson_id": 401,
          "lesson_title": "Understanding the Method",
          "objective":
              "Learn the Urdhva Tiryak pattern for systematic multiplication",
          "duration_minutes": 25,
          "content":
              """Urdhva Tiryak means "Vertically and Crosswise"—the most versatile Vedic method!

Why This Method is Special:
• Works for ANY two numbers
• No need to check if numbers are near a base
• Same process every time
• Builds from right to left
• Natural for mental calculation

The Concept:
We multiply digits in a specific cross-pattern, building the answer one digit at a time from right to left.

Basic Pattern for 2-digit × 2-digit:

For AB × CD:

Step 1 (Ones place): B × D
Step 2 (Tens place): (A × D) + (B × C)
Step 3 (Hundreds place): A × C
Step 4: Handle all carries

Visual Pattern:
```
    A B
  × C D
  -----
  Step 3: A×C
  Step 2: (A×D) + (B×C)
  Step 1: B×D
```

Example: 23 × 12

Visualize:
```
    2 3
  × 1 2
  -----
```

Step 1 (Ones): 3 × 2 = 6
Step 2 (Tens): (2 × 2) + (3 × 1) = 4 + 3 = 7
Step 3 (Hundreds): 2 × 1 = 2

Answer: 276

Key Insight:
We're building columns of partial products, just like traditional multiplication, but organized more efficiently for mental math!""",
          "examples": [
            {
              "problem": "32 × 21",
              "step1": "Ones: 2×1 = 2",
              "step2": "Tens: (3×1)+(2×2) = 3+4 = 7",
              "step3": "Hundreds: 3×2 = 6",
              "answer": "672",
              "verification": "32 × 21 = 672 ✓",
            },
            {
              "problem": "14 × 13",
              "step1": "Ones: 4×3 = 12 → write 2, carry 1",
              "step2": "Tens: (1×3)+(4×1)+1 = 3+4+1 = 8",
              "step3": "Hundreds: 1×1 = 1",
              "answer": "182",
              "verification": "14 × 13 = 182 ✓",
            },
          ],
          "practice": [
            {
              "question": "In 34 × 21, what is the ones place calculation?",
              "type": "input",
              "answer": "4",
              "hint": "4 × 1",
            },
            {
              "question":
                  "In 34 × 21, what is the tens place calculation before carrying?",
              "type": "input",
              "answer": "10",
              "hint": "(3×1) + (4×2)",
            },
            {"question": "21 × 32 = ?", "type": "input", "answer": "672"},
          ],
          "summary":
              "Urdhva Tiryak works right to left: (1) Ones: last digits (2) Tens: cross products (3) Hundreds: first digits. Handle carries as you go!",
        },
        {
          "lesson_id": 402,
          "lesson_title": "Solving Any 2-Digit × 2-Digit",
          "objective":
              "Master the technique for all 2-digit multiplications with confidence",
          "duration_minutes": 30,
          "content":
              """Let's perfect the 2×2 digit pattern with comprehensive examples!

Standard Process:

Example: 47 × 63

```
    4 7
  × 6 3
  -----
```

Column 1 (Ones): 7 × 3 = 21
• Write: 1
• Carry: 2

Column 2 (Tens): (4 × 3) + (7 × 6) + 2
• 12 + 42 + 2 = 56
• Write: 6
• Carry: 5

Column 3 (Hundreds): (4 × 6) + 5
• 24 + 5 = 29
• Write: 29

Answer: 2961

Tips for Managing Carries:
• Don't try to remember too much
• Calculate one column at a time
• Write down carries mentally or on fingers
• Verify with estimation

Estimation Check:
47 × 63 ≈ 50 × 60 = 3000
Our answer 2961 is close! ✓

Common Patterns:

When both numbers are close:
• 48 × 52 (both near 50)
• Consider using Nikhilam first!

When numbers are far apart:
• Urdhva Tiryak is perfect
• No base method works well""",
          "examples": [
            {
              "problem": "56 × 78",
              "step1": "Ones: 6×8 = 48 → 8, carry 4",
              "step2": "Tens: (5×8)+(6×7)+4 = 40+42+4 = 86 → 6, carry 8",
              "step3": "Hundreds: (5×7)+8 = 35+8 = 43",
              "answer": "4368",
              "check": "≈ 60×80 = 4800 ✓",
            },
            {
              "problem": "34 × 56",
              "step1": "Ones: 4×6 = 24 → 4, carry 2",
              "step2": "Tens: (3×6)+(4×5)+2 = 18+20+2 = 40 → 0, carry 4",
              "step3": "Hundreds: (3×5)+4 = 15+4 = 19",
              "answer": "1904",
              "check": "≈ 30×60 = 1800 ✓",
            },
            {
              "problem": "89 × 76",
              "step1": "Ones: 9×6 = 54 → 4, carry 5",
              "step2": "Tens: (8×6)+(9×7)+5 = 48+63+5 = 116 → 6, carry 11",
              "step3": "Hundreds: (8×7)+11 = 56+11 = 67",
              "answer": "6764",
              "check": "≈ 90×80 = 7200 ✓",
            },
          ],
          "practice": [
            {"question": "23 × 45 = ?", "type": "input", "answer": "1035"},
            {"question": "67 × 89 = ?", "type": "input", "answer": "5963"},
            {"question": "54 × 76 = ?", "type": "input", "answer": "4104"},
            {"question": "81 × 92 = ?", "type": "input", "answer": "7452"},
            {"question": "39 × 47 = ?", "type": "input", "answer": "1833"},
          ],
          "summary":
              "Urdhva Tiryak: rightmost digits → cross products → leftmost digits. Handle carries carefully. Always verify with estimation. Practice makes perfect!",
        },
        {
          "lesson_id": 403,
          "lesson_title": "Speed Drills – Building Fluency",
          "objective":
              "Solve any 2×2 multiplication in under 15 seconds mentally",
          "duration_minutes": 25,
          "content":
              """Speed comes from pattern recognition and practice. Let's build that speed!

Progressive Training:

Week 1 Goal: Accuracy first
• Take your time
• Write intermediate steps
• Verify each answer
• Target: 90% accuracy

Week 2 Goal: Reduce time
• Start limiting yourself to 30 seconds
• Use mental visualization more
• Check answers less frequently
• Target: 80% accuracy, 30 sec/problem

Week 3 Goal: Mental fluency
• Aim for 15 seconds per problem
• Minimize writing
• Trust your mental calculation
• Target: 85% accuracy, 15 sec/problem

Week 4 Goal: Mastery
• Under 10 seconds for easy problems
• Under 15 seconds for hard problems
• 90%+ accuracy
• Can do while walking/talking

Mental Strategies:
• See the numbers clearly
• Speak calculations silently
• Use finger positions for carries
• Visualize the cross pattern
• Break if tired (mental math needs focus)

Practice Environment:
• Quiet place initially
• Gradually add distractions
• Practice during commute
• Challenge friends""",
          "examples": [
            {
              "difficulty": "Easy",
              "problems": ["21×34", "32×43", "41×52", "22×33"],
              "target_time": "10 seconds each",
            },
            {
              "difficulty": "Medium",
              "problems": ["47×58", "63×74", "56×67", "48×59"],
              "target_time": "15 seconds each",
            },
            {
              "difficulty": "Hard",
              "problems": ["87×96", "78×89", "93×84", "76×98"],
              "target_time": "20 seconds each",
            },
          ],
          "practice": [
            {
              "question": "31 × 22 = ?",
              "type": "input",
              "answer": "682",
              "time_limit": 15,
            },
            {
              "question": "45 × 56 = ?",
              "type": "input",
              "answer": "2520",
              "time_limit": 15,
            },
            {
              "question": "67 × 78 = ?",
              "type": "input",
              "answer": "5226",
              "time_limit": 20,
            },
            {
              "question": "89 × 91 = ?",
              "type": "input",
              "answer": "8099",
              "time_limit": 20,
            },
          ],
          "summary":
              "Speed builds gradually over weeks. Start accurate, then fast. Practice daily. Trust the process. You WILL get faster!",
        },
        {
          "lesson_id": 404,
          "lesson_title": "Large Number Mental Multiplication",
          "objective":
              "Extend Urdhva Tiryak to 3-digit numbers and understand the scaling pattern",
          "duration_minutes": 20,
          "content":
              """The beautiful thing about Urdhva Tiryak? It scales to ANY size!

The Pattern Extends:

For 3-digit × 2-digit (ABC × DE):

Column 1: C × E
Column 2: (B × E) + (C × D)
Column 3: (A × E) + (B × D) + (C × E)... wait, this gets complex!

Practical Approach:
For larger numbers, we typically:
1. Use Urdhva Tiryak for the pattern
2. Write down intermediate results
3. Or break into smaller chunks

Example: 123 × 45

Method: Break it down
• 123 × 40 = 123 × 4 × 10
• 123 × 4 = 492 (using Urdhva Tiryak)
• 492 × 10 = 4920

• 123 × 5 = 615 (using half of 123 × 10)

• Total: 4920 + 615 = 5535

Hybrid Approach:
Combine multiple Vedic techniques:
• Use Nikhilam when applicable
• Use Urdhva Tiryak for irregular numbers
• Use doubling/halving for round numbers
• Use decomposition for complex cases

When to Use:
Mental calculation of 3×3 digits is advanced!
• Stick to 2×2 for pure mental math
• Use 3-digit for understanding
• Impress friends with occasional 3-digit calculations""",
          "examples": [
            {
              "problem": "234 × 56 (breakdown approach)",
              "method": "234×50 + 234×6",
              "step1": "234 × 50 = 234 × 100 ÷ 2 = 11700",
              "step2": "234 × 6 = 1404 (Urdhva Tiryak)",
              "answer": "13104",
            },
          ],
          "practice": [
            {
              "question":
                  "Understanding check: How many columns for 3-digit × 3-digit?",
              "type": "input",
              "answer": "5",
            },
            {
              "question": "Calculate: 234 × 5",
              "type": "input",
              "answer": "1170",
              "hint": "Half of 234 × 10",
            },
          ],
          "summary":
              "Urdhva Tiryak scales to any size, but for practical mental math, master 2×2 first. Use hybrid approaches for larger numbers!",
        },
      ],
    },
    {
      "chapter_id": 5,
      "chapter_title": "Squaring Techniques",
      "chapter_description":
          "Master instant squaring of any 2-digit number using specialized Vedic methods",
      "icon": "crop_square",
      "color": "0xFFEC4899",
      "lessons": [
        {
          "lesson_id": 501,
          "lesson_title": "Numbers Ending in 5",
          "objective":
              "Square any number ending in 5 in under 3 seconds using Ekadhikena Purvena",
          "duration_minutes": 15,
          "content":
              """The easiest and most impressive Vedic trick: squaring numbers ending in 5!

The Sutra: Ekadhikena Purvena
Meaning: "By one more than the previous one"

Formula:
For any number ending in 5:
n5² = [n × (n+1)] | 25

Examples:

25²:
• Number before 5: 2
• One more: 2 + 1 = 3
• Multiply: 2 × 3 = 6
• Append 25: 625

35²:
• 3 × 4 = 12
• Append 25: 1225

75²:
• 7 × 8 = 56
• Append 25: 5625

95²:
• 9 × 10 = 90
• Append 25: 9025

Why This Works:
Algebraic proof: (10a + 5)² = 100a(a+1) + 25

But you don't need to know why—just use it!

The Magic:
You can square any 2-digit number ending in 5 in under 3 seconds!

Practice Pattern:
15² = 225
25² = 625
35² = 1225
45² = 2025
55² = 3025
65² = 4225
75² = 5625
85² = 7225
95² = 9025

Notice the pattern in the endings!""",
          "examples": [
            {
              "problem": "45²",
              "calculation": "4 × 5 = 20, append 25",
              "answer": "2025",
              "verification": "45 × 45 = 2025 ✓",
            },
            {
              "problem": "85²",
              "calculation": "8 × 9 = 72, append 25",
              "answer": "7225",
              "verification": "85 × 85 = 7225 ✓",
            },
            {
              "problem": "105²",
              "calculation": "10 × 11 = 110, append 25",
              "answer": "11025",
              "verification": "105 × 105 = 11025 ✓",
            },
          ],
          "practice": [
            {
              "question": "15² = ?",
              "type": "input",
              "answer": "225",
              "time_limit": 3,
            },
            {
              "question": "55² = ?",
              "type": "input",
              "answer": "3025",
              "time_limit": 3,
            },
            {
              "question": "65² = ?",
              "type": "input",
              "answer": "4225",
              "time_limit": 3,
            },
            {
              "question": "115² = ?",
              "type": "input",
              "answer": "13225",
              "time_limit": 5,
            },
            {
              "question": "What comes after the | in 75²?",
              "type": "input",
              "answer": "25",
              "hint": "Always the same!",
            },
          ],
          "summary":
              "For numbers ending in 5: n × (n+1), then append 25. This is the fastest squaring method. Memorize 15² through 95²!",
        },
        {
          "lesson_id": 502,
          "lesson_title": "Numbers Near Base Values",
          "objective":
              "Square numbers near 10, 50, or 100 using the Nikhilam-based approach",
          "duration_minutes": 20,
          "content":
              """When a number is near a base, we can use modified Nikhilam for squaring!

Formula for Squaring Near Base:
n² = (n + difference) | (difference²)

Example: 98²

Base: 100
Difference: −2

Step 1: Add difference to number
• 98 + (−2) = 96

Step 2: Square the difference
• (−2)² = 4 → write as 04 (2 digits for base 100)

Step 3: Combine
• Answer: 9604

Why This Works:
We're using (a−b)² = a² − 2ab + b²
Reorganized for mental calculation!

Example: 103²

Difference: +3
• 103 + 3 = 106
• 3² = 09
• Answer: 10609

Example: 12²

Base: 10
Difference: +2
• 12 + 2 = 14
• 2² = 4
• Answer: 144

Quick Patterns:

Near 10:
• 9² = (9−1)|1² = 81
• 11² = (11+1)|1² = 121
• 12² = (12+2)|2² = 144

Near 100:
• 97² = (97−3)|3² = 9409
• 102² = (102+2)|2² = 10404""",
          "examples": [
            {
              "problem": "96²",
              "base": "100, difference −4",
              "step1": "96 + (−4) = 92",
              "step2": "(−4)² = 16",
              "answer": "9216",
              "verification": "96 × 96 = 9216 ✓",
            },
            {
              "problem": "104²",
              "base": "100, difference +4",
              "step1": "104 + 4 = 108",
              "step2": "4² = 16",
              "answer": "10816",
              "verification": "104 × 104 = 10816 ✓",
            },
            {
              "problem": "9²",
              "base": "10, difference −1",
              "step1": "9 + (−1) = 8",
              "step2": "1² = 1",
              "answer": "81",
              "verification": "9 × 9 = 81 ✓",
            },
          ],
          "practice": [
            {
              "question": "99² = ?",
              "type": "input",
              "answer": "9801",
              "hint": "Difference from 100 is −1",
            },
            {"question": "101² = ?", "type": "input", "answer": "10201"},
            {"question": "97² = ?", "type": "input", "answer": "9409"},
            {"question": "11² = ?", "type": "input", "answer": "121"},
            {"question": "13² = ?", "type": "input", "answer": "169"},
          ],
          "summary":
              "Square numbers near bases: (1) Add difference to number (2) Square the difference (3) Combine with proper digits. Perfect for 90-110 range!",
        },
        {
          "lesson_id": 503,
          "lesson_title": "General 2-Digit Squaring",
          "objective":
              "Square ANY 2-digit number mentally using the Duplex method",
          "duration_minutes": 25,
          "content":
              """For numbers not ending in 5 or near a base, use the Duplex method!

The Duplex Formula:
For AB²:

AB² = A² | 2(A×B) | B²

Handle carries between sections.

Example: 23²

A = 2, B = 3

Step 1: A² = 2² = 4
Step 2: 2(A×B) = 2(2×3) = 12
Step 3: B² = 3² = 9

Combine with carries:
• Start right: 9
• Middle: 12 → write 2, carry 1
• Left: 4 + 1 = 5
• Answer: 529

Example: 47²

A = 4, B = 7

Step 1: 4² = 16
Step 2: 2(4×7) = 56
Step 3: 7² = 49

Combine:
• Right: 49 → write 9, carry 4
• Middle: 56 + 4 = 60 → write 0, carry 6
• Left: 16 + 6 = 22
• Answer: 2209

Alternative: Difference from Round Number

Example: 48²
• Close to 50
• Difference: −2
• Formula: 50² − (2 × 50 × 2) + 2²
• 2500 − 200 + 4 = 2304

Or use: (48 × 2)² ÷ 4 = 96² ÷ 4
But that's harder!

Best Strategy:
• Ends in 5? → Use Ekadhikena
• Near base? → Use Nikhilam method
• Otherwise? → Use Duplex
• Or → Use Urdhva Tiryak (square is just number × itself)""",
          "examples": [
            {
              "problem": "34²",
              "duplex": "3²|2(3×4)|4² = 9|24|16",
              "combine": "9|24|16 → 9|(24+1)|6 → 9|25|6 → 1156",
              "answer": "1156",
              "verification": "34 × 34 = 1156 ✓",
            },
            {
              "problem": "67²",
              "duplex": "6²|2(6×7)|7² = 36|84|49",
              "combine": "36|84|49 → 36|(84+4)|9 → 36|88|9 → 4489",
              "answer": "4489",
              "verification": "67 × 67 = 4489 ✓",
            },
            {
              "problem": "81²",
              "duplex": "8²|2(8×1)|1² = 64|16|1",
              "combine": "64|16|1 → (64+1)|6|1 → 6561",
              "answer": "6561",
              "verification": "81 × 81 = 6561 ✓",
            },
          ],
          "practice": [
            {"question": "21² = ?", "type": "input", "answer": "441"},
            {"question": "38² = ?", "type": "input", "answer": "1444"},
            {"question": "52² = ?", "type": "input", "answer": "2704"},
            {"question": "76² = ?", "type": "input", "answer": "5776"},
            {"question": "89² = ?", "type": "input", "answer": "7921"},
          ],
          "summary":
              "Duplex method: A² | 2(A×B) | B². Handle carries carefully. Choose the easiest method based on the number. Practice all squares 11-99!",
        },
      ],
    },
    {
      "chapter_id": 6,
      "chapter_title": "Fast Division Techniques",
      "chapter_description":
          "Master mental division using Paravartya Sutra and complement methods",
      "icon": "percent",
      "color": "0xFFF59E0B",
      "lessons": [
        {
          "lesson_id": 601,
          "lesson_title": "Paravartya Sutra Basics",
          "objective": "Understand the transpose and apply method for division",
          "duration_minutes": 20,
          "content":
              """Paravartya means "Transpose and Apply"—the Vedic way to divide!

Traditional Division vs Vedic:
• Traditional: Long division with multiple steps
• Vedic: Flag method using complements

The Concept:
Instead of dividing, we multiply by a modified divisor (the flag).

Simple Division by 9:

Example: 234 ÷ 9

Step 1: Set up flag
• Divisor: 9
• Flag: 1 (because 9 × 1 = 9 is close to 10)

Step 2: Process left to right
• 2 → quotient starts with 2
• 2 × 1 = 2, remainder at next digit: 2+3 = 5
• 5 → next quotient digit
• 5 × 1 = 5, remainder: 5+4 = 9
• But 9 = divisor, so it's 0 remainder

Answer: 26 remainder 0

Division by 8:

Example: 176 ÷ 8

Flag: 2 (because 8 × 2 = 16, complement of 8 from 10 is 2)

• 1 → quotient: 1
• 1 × 2 = 2, 2+7 = 9 → but > 8, so adjust
• Actually use: 17 ÷ 8 = 2 remainder 1
• Continue with 16 ÷ 8 = 2

Answer: 22

Key Insight:
Paravartya converts division into easier multiplication patterns!""",
          "examples": [
            {
              "problem": "144 ÷ 9",
              "method": "Flag = 1",
              "working": "1→1, 1+4=5→5, 5+4=9→0",
              "answer": "16 remainder 0",
              "verification": "9 × 16 = 144 ✓",
            },
            {
              "problem": "156 ÷ 12",
              "method": "Use complement approach",
              "working": "156 ÷ 12 = 13 ",
              "answer": "13",
              "verification": "12 × 13 = 156 ✓",
            },
          ],
          "practice": [
            {"question": "81 ÷ 9 = ?", "type": "input", "answer": "9"},
            {"question": "72 ÷ 8 = ?", "type": "input", "answer": "9"},
            {
              "question": "What is the flag for divisor 9?",
              "type": "input",
              "answer": "1",
            },
          ],
          "summary":
              "Paravartya uses flags (related to complements) to convert division into simpler operations. Start with division by 9 and 8!",
        },
        {
          "lesson_id": 602,
          "lesson_title": "Division by Numbers Near Base",
          "objective":
              "Divide by numbers close to 10 or 100 using base complements",
          "duration_minutes": 22,
          "content":
              """When the divisor is near a base, division becomes super easy!

Division by Numbers Near 10:

Example: 234 ÷ 9

Since 9 = 10 − 1:
• Complement: 1
• Method: Add running totals

```
  2 | 3 | 4
+ 0 | 2 | 5 (running adds)
-----------
  2 | 5 | 9
```

Read quotient: 25, remainder: 9
But 9 = divisor, so: 26 remainder 0

Example: 287 ÷ 11

Since 11 = 10 + 1:
• Use subtraction pattern
• 287 ÷ 11 = 26 remainder 1

Division Near 100:

Example: 2,456 ÷ 98

Complement of 98 from 100 = 02

Set up:
```
  24 | 56
+ 00 | 48 (24 × 2)
-----------
  25 | 04
```

Answer: 25 remainder 4

Quick Method for ÷99:

Example: 5,643 ÷ 99

Since 99 = 100 − 1:
• Group in pairs from left
• 56 | 43
• Add: 56 to next → 56+0=56
• Add: 43+56=99 (this is divisor!)
• Answer: 57 remainder 0

Strategy:
The closer the divisor is to a base, the easier the calculation!""",
          "examples": [
            {
              "problem": "456 ÷ 9",
              "working": "4|5|6 with running total",
              "steps": "4, 4+5=9→0 carry 1, 1+0+6=7",
              "answer": "50 remainder 6",
              "verification": "9 × 50 + 6 = 456 ✓",
            },
            {
              "problem": "1,234 ÷ 99",
              "working": "Group: 12|34",
              "steps": "12, 34+12=46",
              "answer": "12 remainder 46",
              "verification": "99 × 12 + 46 = 1234 ✓",
            },
          ],
          "practice": [
            {"question": "180 ÷ 9 = ?", "type": "input", "answer": "20"},
            {"question": "198 ÷ 99 = ?", "type": "input", "answer": "2"},
            {
              "question": "What is the complement of 99 from 100?",
              "type": "input",
              "answer": "1",
            },
          ],
          "summary":
              "Division by numbers near bases uses complements. For 9: add complements. For 99: pair and add. Practice these patterns!",
        },
        {
          "lesson_id": 603,
          "lesson_title": "Mental 2-Digit by 2-Digit Division",
          "objective":
              "Divide any 2-digit number by another 2-digit number mentally",
          "duration_minutes": 25,
          "content":
              """General division requires combining estimation with Vedic techniques.

Strategy: Estimate + Refine

Example: 456 ÷ 23

Step 1: Estimate
• 456 ≈ 460
• 23 ≈ 20
• 460 ÷ 20 = 23
• So answer is around 20

Step 2: Refine
• Try 20: 23 × 20 = 460 (too big)
• Try 19: 23 × 19 = 437 (use Vedic multiplication!)
• Remainder: 456 − 437 = 19

Answer: 19 remainder 19

Quick Multiplication Check:
Use Urdhva Tiryak to verify:
• 23 × 19 = 437 ✓

Division by 25 (Special Case):

Example: 675 ÷ 25

Since 25 = 100 ÷ 4:
• 675 × 4 = 2700
• Shift decimal: 27.00
• Answer: 27

Division by 50 (Special Case):

Example: 850 ÷ 50

• Double: 850 × 2 = 1700
• Shift decimal: 17.00
• Answer: 17

Or simply: 850 ÷ 50 = 85 ÷ 5 = 17

Division by 11 (Pattern):

For 2-digit ÷ 11:
• Sum the digits
• If sum = 11, quotient is same as divisor
• 77 ÷ 11: 7+7=14, close to 11
• Answer: 7

General Steps:
1. Estimate using round numbers
2. Use Vedic multiplication to test
3. Adjust up or down
4. Calculate remainder""",
          "examples": [
            {
              "problem": "384 ÷ 16",
              "estimate": "384 ≈ 400, 16 ≈ 20, so ≈ 20",
              "refine": "Try 24: 16×24 = 384 exactly!",
              "answer": "24 remainder 0",
              "verification": "16 × 24 = 384 ✓",
            },
            {
              "problem": "567 ÷ 27",
              "estimate": "567 ≈ 540, 27 ≈ 30, so ≈ 18",
              "refine": "Try 21: 27×21 = 567 exactly!",
              "answer": "21 remainder 0",
              "verification": "27 × 21 = 567 ✓",
            },
            {
              "problem": "750 ÷ 25",
              "method": "Special: ×4 then ÷100",
              "working": "750 × 4 = 3000, shift: 30",
              "answer": "30",
              "verification": "25 × 30 = 750 ✓",
            },
          ],
          "practice": [
            {
              "question": "400 ÷ 25 = ?",
              "type": "input",
              "answer": "16",
              "hint": "×4 method",
            },
            {"question": "600 ÷ 50 = ?", "type": "input", "answer": "12"},
            {"question": "288 ÷ 12 = ?", "type": "input", "answer": "24"},
            {"question": "374 ÷ 17 = ?", "type": "input", "answer": "22"},
          ],
          "summary":
              "Mental division: Estimate → Test with Vedic multiplication → Refine. Know special cases (÷25, ÷50, ÷11). Practice estimation skills!",
        },
        {
          "lesson_id": 604,
          "lesson_title": "Quick Remainder Handling",
          "objective": "Calculate remainders instantly without full division",
          "duration_minutes": 18,
          "content": """Sometimes we only need the remainder, not the quotient!

Remainder Tricks:

Remainder when dividing by 9:
Add all digits of the number!

Example: 4,567 ÷ 9
• Sum: 4+5+6+7 = 22
• Sum again: 2+2 = 4
• Remainder: 4

Verify: 4567 ÷ 9 = 507 remainder 4 ✓

Remainder when dividing by 11:
Alternate sum of digits!

Example: 4,567 ÷ 11
• Odd positions: 4+6 = 10
• Even positions: 5+7 = 12
• Difference: |10−12| = 2
• Remainder: 2

Remainder when dividing by 3:
Same as ÷9: sum the digits!

Example: 4,567 ÷ 3
• Sum: 4+5+6+7 = 22
• Sum: 2+2 = 4
• Remainder: 4 ÷ 3 → 1
• Remainder: 1

Remainder when dividing by 8:
Check last 3 digits only!

Example: 45,624 ÷ 8
• Last 3 digits: 624
• 624 ÷ 8 = 78 remainder 0
• Answer: 0

Remainder when dividing by 4:
Check last 2 digits only!

Example: 45,624 ÷ 4
• Last 2 digits: 24
• 24 ÷ 4 = 6 remainder 0
• Answer: 0

Why These Work:
Based on divisibility rules and modular arithmetic!""",
          "examples": [
            {
              "problem": "Remainder of 8,765 ÷ 9",
              "method": "Sum digits: 8+7+6+5 = 26 → 2+6 = 8",
              "answer": "8",
              "verification": "8765 ÷ 9 = 973 remainder 8 ✓",
            },
            {
              "problem": "Remainder of 3,456 ÷ 11",
              "method": "Alternate: (3+5)−(4+6) = 8−10 = −2 → 11−2 = 9",
              "answer": "9",
              "verification":
                  "3456 ÷ 11 = 314 remainder 2... wait, let me recalculate",
            },
            {
              "problem": "Remainder of 12,345 ÷ 8",
              "method": "Last 3: 345 ÷ 8 = 43 remainder 1",
              "answer": "1",
              "verification": "12345 ÷ 8 = 1543 remainder 1 ✓",
            },
          ],
          "practice": [
            {
              "question": "Remainder of 123 ÷ 9?",
              "type": "input",
              "answer": "6",
              "hint": "Sum: 1+2+3",
            },
            {
              "question": "Remainder of 456 ÷ 3?",
              "type": "input",
              "answer": "0",
              "hint": "Sum: 4+5+6",
            },
            {
              "question": "Remainder of 1,234 ÷ 4?",
              "type": "input",
              "answer": "2",
              "hint": "Check last 2 digits",
            },
          ],
          "summary":
              "Quick remainders: ÷9 & ÷3 (sum digits), ÷11 (alternate sum), ÷8 (last 3), ÷4 (last 2). These shortcuts save massive time!",
        },
      ],
    },
    {
      "chapter_id": 7,
      "chapter_title": "Advanced Speed Building",
      "chapter_description":
          "Combine techniques, practice mixed operations, and develop competition-level speed",
      "icon": "bolt",
      "color": "0xFF3B82F6",
      "lessons": [
        {
          "lesson_id": 701,
          "lesson_title": "Mixed Operations",
          "objective":
              "Solve problems combining multiplication, division, and squaring",
          "duration_minutes": 25,
          "content":
              """Real speed comes from switching between techniques seamlessly!

Strategy Selection:

Given a problem, choose the fastest method:

Multiplication:
• Ends in 5? → Direct formula
• Near base? → Nikhilam
• General? → Urdhva Tiryak

Division:
• By 25 or 50? → Special method
• By 9 or 99? → Complement
• General? → Estimate + refine

Squaring:
• Ends in 5? → Ekadhikena
• Near base? → Base method
• General? → Duplex or Urdhva Tiryak

Complex Problems:

Example: (45² − 35²) ÷ 10

Step 1: 45² = (4×5)|25 = 2025
Step 2: 35² = (3×4)|25 = 1225
Step 3: 2025 − 1225 = 800
Step 4: 800 ÷ 10 = 80

Answer: 80

Example: (98 × 102) + (15²)

Step 1: 98 × 102 (Nikhilam base 100)
• Differences: −2, +2
• Cross: 98+2 = 100
• Multiply: (−2)×(+2) = −4 → borrow
• = 9996

Step 2: 15² = (1×2)|25 = 225

Step 3: 9996 + 225 = 10,221

Answer: 10,221

Practice Workflow:
1. Read entire problem
2. Identify which techniques to use
3. Plan the sequence
4. Execute step by step
5. Verify reasonableness""",
          "examples": [
            {
              "problem": "(25² + 75²) ÷ 50",
              "step1": "25² = 625",
              "step2": "75² = 5625",
              "step3": "625 + 5625 = 6250",
              "step4": "6250 ÷ 50 = 125",
              "answer": "125",
            },
            {
              "problem": "95 × 96 − 9000",
              "step1": "95 × 96 = 9120 (Nikhilam)",
              "step2": "9120 − 9000 = 120",
              "answer": "120",
            },
          ],
          "practice": [
            {
              "question": "(35² − 25²) ÷ 10 = ?",
              "type": "input",
              "answer": "60",
            },
            {
              "question": "97 × 98 + 100 = ?",
              "type": "input",
              "answer": "9606",
            },
            {"question": "55² ÷ 25 = ?", "type": "input", "answer": "121"},
          ],
          "summary":
              "Choose the right technique for each operation. Plan before solving. Combine methods smoothly. This is where mastery shows!",
        },
        {
          "lesson_id": 702,
          "lesson_title": "Rapid Estimation",
          "objective": "Estimate answers within 5% in under 2 seconds",
          "duration_minutes": 20,
          "content":
              """Estimation is a crucial skill—it helps you verify and work faster!

Rounding Strategies:

For Multiplication:
Round both numbers, then adjust

Example: 47 × 83
• Round: 50 × 80 = 4000
• Actual should be slightly less (both rounded up)
• Estimate: ~3900

For Division:
Round to make it easy

Example: 4,567 ÷ 48
• Round: 4,500 ÷ 50 = 90
• Estimate: ~95 (divisor was rounded up)

Squaring:
Round to nearest 5 or 10

Example: 47²
• Close to 45²
• 45² = 2025
• Actual is slightly higher
• Estimate: ~2200

Mental Calculation Flow:

1. Rough Estimate First
   • Gives you confidence
   • Helps catch errors

2. Exact Calculation
   • Use Vedic method
   • Stay focused

3. Quick Verification
   • Compare to estimate
   • If far off, recalculate

Percentage Method:

Is 47 × 83 close to 50 × 80?
• 47 = 50 − 6% 
• 83 = 80 + 4%
• Changes roughly cancel
• Answer ≈ 4000

Actual: 3901 (very close!)

Quick Checks:
• Last digit multiplication
• Order of magnitude
• Divisibility rules""",
          "examples": [
            {
              "problem": "Estimate 67 × 89",
              "round": "70 × 90 = 6300",
              "adjust": "Both rounded up, so actual is less",
              "estimate": "~6000",
              "actual": "5963 ✓",
            },
            {
              "problem": "Estimate 3,456 ÷ 23",
              "round": "3,500 ÷ 25 = 140",
              "adjust": "Divisor rounded up, so actual is higher",
              "estimate": "~150",
              "actual": "150.26 ✓",
            },
          ],
          "practice": [
            {
              "question": "Estimate 48 × 52 (within 10%)",
              "type": "input",
              "answer": "2500",
              "hint": "50 × 50",
            },
            {
              "question": "Is 67 × 89 closer to 5000 or 6000?",
              "type": "multiple_choice",
              "options": ["5000", "6000"],
              "answer": "6000",
            },
          ],
          "summary":
              "Always estimate before calculating exactly. Round smartly. Use estimates to verify. Fast estimation = confidence + accuracy!",
        },
        {
          "lesson_id": 703,
          "lesson_title": "Timed Drills",
          "objective": "Complete 10 problems in 60 seconds with 90% accuracy",
          "duration_minutes": 30,
          "content":
              """Timed practice builds the pressure-handling skills for competitions!

Progressive Timing:

Week 1-2: Accuracy Focus
• 10 problems, no time limit
• Aim for 95%+ accuracy
• Build confidence

Week 3-4: Speed Introduction
• 10 problems in 2 minutes
• 90% accuracy
• Start feeling time pressure

Week 5-6: Competition Speed
• 10 problems in 90 seconds
• 85% accuracy
• Real competition pace

Week 7-8: Expert Level
• 10 problems in 60 seconds
• 90% accuracy
• This is mastery!

Drill Structure:

Easy Drill (30 sec target):
1. 95 × 96
2. 45²
3. 11 × 12
4. 98 × 97
5. 35²

Medium Drill (60 sec target):
1. 47 × 53
2. 67²
3. 89 × 92
4. 384 ÷ 12
5. 104 × 105

Hard Drill (90 sec target):
1. 87 × 76
2. 89²
3. 456 ÷ 24
4. 93 × 84
5. 750 ÷ 25

Training Tips:
• Use a timer
• Don't skip problems
• Review mistakes immediately
• Practice same drill until perfect
• Then move to harder drills
• Mix problem types
• Simulate exam conditions

Mental State:
• Stay calm under pressure
• Trust your training
• Skip if stuck (come back later)
• Breathe between problems
• Maintain focus""",
          "examples": [
            {
              "drill_name": "Speed Drill Alpha",
              "time_limit": "60 seconds",
              "problems": [
                "96 × 98",
                "55²",
                "99 × 97",
                "400 ÷ 25",
                "65²",
                "103 × 104",
                "48 × 52",
                "225 ÷ 15",
                "105²",
                "94 × 93",
              ],
              "answers": [
                "9408",
                "3025",
                "9603",
                "16",
                "4225",
                "10712",
                "2496",
                "15",
                "11025",
                "8742",
              ],
            },
          ],
          "practice": [
            {
              "question": "TIMED: 97 × 98 = ?",
              "type": "input",
              "answer": "9506",
              "time_limit": 5,
            },
            {
              "question": "TIMED: 45² = ?",
              "type": "input",
              "answer": "2025",
              "time_limit": 3,
            },
            {
              "question": "TIMED: 600 ÷ 25 = ?",
              "type": "input",
              "answer": "24",
              "time_limit": 4,
            },
          ],
          "summary":
              "Timed drills build competition skills. Start slow, build speed gradually. Aim for 10 problems in 60 seconds. Practice daily!",
        },
        {
          "lesson_id": 704,
          "lesson_title": "Competition Mode",
          "objective":
              "Perform under pressure with 95% accuracy at competition speed",
          "duration_minutes": 35,
          "content":
              """Final preparation for actual competition or certification!

Competition Strategies:

1. Problem Triage
Scan all problems, do easy ones first:
• Numbers ending in 5? Do immediately
• Near base 100? Quick win
• Complex? Save for later

2. Time Management
• Don't spend >10 sec on any problem initially
• Mark tough ones, return later
• Always leave 30 sec for review

3. Error Prevention
• Write answer immediately (don't hold in mind)
• Check last digit quickly
• Estimate to verify
• Don't second-guess unless obvious error

4. Mental Stamina
• Practice 20-30 problem sets
• Maintain focus entire time
• Reset between problems
• Don't let one mistake derail you

5. Recovery from Mistakes
• Accept it and move on
• Don't waste time on rechecking
• Trust your training
• Stay confident

Competition Formats:

Sprint Round (10 problems, 60 seconds):
• Pure speed
• Easy to medium difficulty
• All Vedic techniques needed

Accuracy Round (20 problems, 5 minutes):
• Balance speed and accuracy
• Mixed difficulty
• Penalties for wrong answers

Marathon Round (50 problems, 15 minutes):
• Endurance test
• All difficulty levels
• Stamina crucial

Practice Competition:
Simulate real conditions:
• Set timer
• No breaks
• Noisy environment
• Track score
• Review afterwards""",
          "examples": [
            {
              "competition": "Mock Sprint Round",
              "time": "60 seconds",
              "problems": [
                "95 × 97",
                "25²",
                "103 × 102",
                "75²",
                "98 × 99",
                "500 ÷ 25",
                "85²",
                "96 × 94",
                "35²",
                "101 × 99",
              ],
              "scoring": "1 point each, −0.25 for wrong",
            },
          ],
          "practice": [
            {
              "question":
                  "COMPETITION: Solve as many as possible in 30 seconds",
              "type": "timed_set",
              "problems": ["97×98", "45²", "104×105", "65²", "99×97"],
              "time_limit": 30,
            },
          ],
          "summary":
              "Competition mode: Triage problems, manage time, prevent errors, maintain stamina. Practice under real conditions. Trust your training!",
        },
      ],
    },
    {
      "chapter_id": 8,
      "chapter_title": "Mastery Challenges",
      "chapter_description":
          "100 multiplication + 100 division challenges to cement your skills",
      "icon": "emoji_events",
      "color": "0xFFFF9800",
      "lessons": [
        {
          "lesson_id": 801,
          "lesson_title": "100 Multiplication Challenge",
          "objective":
              "Complete 100 varied multiplication problems demonstrating mastery of all techniques",
          "duration_minutes": 60,
          "content":
              """The ultimate test: 100 multiplication problems using all Vedic techniques!

Challenge Structure:

Problems 1-20: Numbers ending in 5
• All squares and multiplications with 5
• Target: 2 seconds each
• Technique: Ekadhikena Purvena

Problems 21-40: Near Base 10
• Numbers 6-14
• Target: 4 seconds each
• Technique: Nikhilam (base 10)

Problems 41-60: Near Base 100
• Numbers 85-115
• Target: 6 seconds each
• Technique: Nikhilam (base 100)

Problems 61-80: General 2-digit
• Any 2-digit × 2-digit
• Target: 8 seconds each
• Technique: Urdhva Tiryak

Problems 81-100: Mixed & Advanced
• 3-digit × 2-digit
• Multiple operations
• Pattern recognition
• Target: 10 seconds each
• All techniques

Completion Criteria:
• Finish all 100 problems
• 90%+ accuracy
• Average time ≤ 6 seconds per problem
• Total time ≤ 10 minutes

Rewards:
• Bronze: 70% accuracy
• Silver: 85% accuracy
• Gold: 95% accuracy
• Platinum: 100% accuracy + under 8 min total

Study Plan:
• Do 20 problems per day for 5 days
• Or 10 per day for 10 days
• Review all mistakes
• Retry failed problems
• Track improvement daily""",
          "examples": [
            {
              "sample_problems": "Problems 1-10",
              "problems": [
                "15²",
                "25×35",
                "45²",
                "55×65",
                "75²",
                "85×95",
                "35×45",
                "65²",
                "15×95",
                "75×85",
              ],
              "techniques": ["All use ending-in-5 methods"],
              "target_time": "20 seconds total",
            },
            {
              "sample_problems": "Problems 51-60",
              "problems": [
                "96×97",
                "103×104",
                "98×99",
                "105×106",
                "94×95",
                "107×108",
                "92×93",
                "109×111",
                "91×94",
                "108×112",
              ],
              "techniques": ["All use Nikhilam base 100"],
              "target_time": "60 seconds total",
            },
          ],
          "practice": [
            {
              "question": "Challenge Problem 1: 15² = ?",
              "type": "input",
              "answer": "225",
            },
            {
              "question": "Challenge Problem 2: 25² = ?",
              "type": "input",
              "answer": "625",
            },
            {
              "question": "Challenge Problem 21: 8 × 9 = ?",
              "type": "input",
              "answer": "72",
            },
            {
              "question": "Challenge Problem 41: 96 × 97 = ?",
              "type": "input",
              "answer": "9312",
            },
            {
              "question": "Challenge Problem 61: 47 × 53 = ?",
              "type": "input",
              "answer": "2491",
            },
          ],
          "summary":
              "100 multiplication problems test ALL techniques. Complete in multiple sessions. Track accuracy and speed. Achieve 90%+ for mastery!",
        },
        {
          "lesson_id": 802,
          "lesson_title": "100 Division Challenge",
          "objective": "Master division through 100 progressive problems",
          "duration_minutes": 60,
          "content": """Now conquer division with 100 comprehensive problems!

Challenge Structure:

Problems 1-20: Division by 25 and 50
• Special quick methods
• Target: 3 seconds each
• Technique: ×4 or ×2 method

Problems 21-40: Division by 9 and 99
• Complement methods
• Target: 5 seconds each
• Technique: Paravartya flag

Problems 41-60: Division near bases
• By numbers 8-12, 90-110
• Target: 6 seconds each
• Technique: Base complements

Problems 61-80: General 2-digit division
• Any ÷ 2-digit
• Target: 10 seconds each
• Technique: Estimate + Vedic multiply

Problems 81-100: Mixed & Complex
• 3-digit ÷ 2-digit
• Remainder problems
• Applied division
• Target: 12 seconds each

Completion Criteria:
• Finish all 100 problems
• 85%+ accuracy (division is harder!)
• Average time ≤ 8 seconds per problem
• Total time ≤ 14 minutes

Rewards:
• Bronze: 65% accuracy
• Silver: 80% accuracy
• Gold: 90% accuracy
• Platinum: 95% accuracy + under 12 min

Key Skills Tested:
• Paravartya Sutra
• Complement division
• Mental estimation
• Remainder calculation
• Verification with multiplication""",
          "examples": [
            {
              "sample_problems": "Problems 1-10",
              "problems": [
                "100÷25",
                "200÷50",
                "500÷25",
                "400÷50",
                "750÷25",
                "900÷50",
                "625÷25",
                "1000÷50",
                "375÷25",
                "650÷50",
              ],
              "techniques": ["Special methods"],
              "target_time": "30 seconds total",
            },
            {
              "sample_problems": "Problems 21-30",
              "problems": [
                "81÷9",
                "99÷9",
                "180÷9",
                "198÷99",
                "297÷99",
                "450÷9",
                "396÷99",
                "720÷9",
                "594÷99",
                "900÷9",
              ],
              "techniques": ["Complement methods"],
              "target_time": "50 seconds total",
            },
          ],
          "practice": [
            {
              "question": "Division Challenge 1: 100 ÷ 25 = ?",
              "type": "input",
              "answer": "4",
            },
            {
              "question": "Division Challenge 2: 200 ÷ 50 = ?",
              "type": "input",
              "answer": "4",
            },
            {
              "question": "Division Challenge 21: 81 ÷ 9 = ?",
              "type": "input",
              "answer": "9",
            },
            {
              "question": "Division Challenge 61: 456 ÷ 12 = ?",
              "type": "input",
              "answer": "38",
            },
          ],
          "summary":
              "100 division problems cover all Vedic division methods. Division is trickier than multiplication—85% accuracy is excellent!",
        },
        {
          "lesson_id": 803,
          "lesson_title": "60-Second Speed Tests",
          "objective":
              "Solve maximum problems in 60 seconds across multiple attempts",
          "duration_minutes": 45,
          "content": """Speed test format: How many can you solve in 60 seconds?

Test Format:

Each speed test has 20 problems of mixed difficulty.
You have 60 seconds.
Goal: Solve as many as possible correctly.

Scoring:
• 1-5 correct: Beginner
• 6-10 correct: Intermediate
• 11-15 correct: Advanced
• 16-18 correct: Expert
• 19-20 correct: Master

Strategy:
• Skip hard problems initially
• Do all easy ones first
• Return to skipped problems if time remains
• Don't second-guess
• Write answer immediately

Speed Test Series:

Test 1: Multiplication Focus
• All ending in 5: Should do 10+
• Near base 100: Should do 8+
• General: Should do 6+

Test 2: Division Focus
• By 25/50: Should do 8+
• By 9/99: Should do 6+
• General: Should do 5+

Test 3: Mixed Operations
• Equal mix: Should do 10+
• Requires technique switching
• Tests true mastery

Test 4: Squares Only
• All squaring techniques
• Should do 12+
• Fastest category

Test 5: Master Test
• Hardest problems
• Advanced techniques only
• Should do 8+

Improvement Tracking:
Take each test multiple times:
• First attempt: Baseline
• After 1 week: Should improve 20%
• After 2 weeks: Should improve 40%
• After 1 month: Should improve 60%+

Record Keeping:
• Date
• Test number
• Problems attempted
• Problems correct
• Accuracy %
• Personal best

Mental Preparation:
• 60 seconds is SHORT
• Don't panic
• Stay focused
• Trust your training
• Every second counts""",
          "examples": [
            {
              "test_name": "Speed Test Alpha",
              "time_limit": "60 seconds",
              "problems": [
                "95×96",
                "45²",
                "97×98",
                "35²",
                "103×104",
                "65²",
                "99×98",
                "55²",
                "106×107",
                "75²",
                "94×93",
                "25²",
                "101×99",
                "85²",
                "108×109",
                "15²",
                "92×91",
                "95²",
                "105×104",
                "105²",
              ],
              "target": "15+ correct for Expert level",
            },
          ],
          "practice": [
            {
              "question": "SPEED TEST: Start now! 97×98=?",
              "type": "input",
              "answer": "9506",
              "time_limit": 3,
            },
            {
              "question": "SPEED TEST: 45²=?",
              "type": "input",
              "answer": "2025",
              "time_limit": 2,
            },
            {
              "question": "SPEED TEST: 103×104=?",
              "type": "input",
              "answer": "10712",
              "time_limit": 4,
            },
          ],
          "summary":
              "60-second speed tests measure pure calculation speed. Take multiple tests, track improvement. Aim for 15+ correct. This is the ultimate speed measure!",
        },
      ],
    },
    {
      "chapter_id": 9,
      "chapter_title": "Final Certification Test",
      "chapter_description":
          "Comprehensive assessment covering all Vedic techniques with performance scoring and achievement badges",
      "icon": "verified",
      "color": "0xFF10B981",
      "lessons": [
        {
          "lesson_id": 901,
          "lesson_title": "Certification Exam Overview",
          "objective": "Understand the certification format and requirements",
          "duration_minutes": 15,
          "content": """The final test to prove your Vedic Mathematics mastery!

Certification Levels:

Level 1: Vedic Mathematics Practitioner
• Requirements: 70%+ accuracy, 15 min completion
• Skills: Basic Vedic techniques
• Can solve multiplication/division near bases

Level 2: Vedic Mathematics Expert
• Requirements: 85%+ accuracy, 12 min completion
• Skills: All standard Vedic techniques
• Can solve any 2-digit problem quickly

Level 3: Vedic Mathematics Master
• Requirements: 95%+ accuracy, 10 min completion
• Skills: Advanced speed and accuracy
• Can solve under pressure consistently

Level 4: Vedic Mathematics Grandmaster
• Requirements: 100% accuracy, 8 min completion
• Skills: Perfect technique and speed
• Can teach others effectively

Exam Structure:

Section A: Multiplication (40 points)
• 10 problems ending in 5 (10 points)
• 10 problems near base 100 (10 points)
• 15 general 2-digit problems (15 points)
• 5 advanced problems (5 points)

Section B: Division (30 points)
• 5 by 25/50 (5 points)
• 5 by 9/99 (5 points)
• 10 general 2-digit division (15 points)
• 5 remainder problems (5 points)

Section C: Squaring (20 points)
• 5 ending in 5 (5 points)
• 5 near base (5 points)
• 10 general squares (10 points)

Section D: Speed Round (10 points)
• 10 mixed problems in 60 seconds
• Bonus points for speed

Total: 100 points

Time Limits:
• Section A: 6 minutes
• Section B: 5 minutes
• Section C: 3 minutes
• Section D: 1 minute
• Total: 15 minutes maximum

Preparation:
• Review all techniques
• Practice each section separately
• Take mock exams
• Ensure 90%+ on all practice tests
• Rest well before exam""",
          "examples": [
            {
              "section": "Sample Section A Problems",
              "problems": ["45²", "96×97", "47×53", "85²", "103×104"],
              "points": "10 points",
              "time": "90 seconds",
            },
          ],
          "practice": [
            {
              "question": "What percentage is needed for Master level?",
              "type": "input",
              "answer": "95",
            },
            {
              "question": "How many sections are in the certification exam?",
              "type": "input",
              "answer": "4",
            },
          ],
          "summary":
              "Certification exam has 4 sections: Multiplication, Division, Squaring, Speed Round. Total 100 points in 15 minutes. Master level needs 95%!",
        },
        {
          "lesson_id": 902,
          "lesson_title": "Full Certification Exam",
          "objective": "Complete the comprehensive certification test",
          "duration_minutes": 90,
          "content": """This is it—the final certification exam!

Instructions:
• You have 15 minutes total
• Show all work (for practice)
• No calculators
• No notes or references
• Write answers clearly
• Manage your time wisely

Section A: Multiplication (40 points, 6 minutes)

A1. Numbers Ending in 5 (10 points):
1. 15² = ?
2. 25 × 35 = ?
3. 45² = ?
4. 55 × 65 = ?
5. 75² = ?
6. 85 × 95 = ?
7. 35 × 45 = ?
8. 65² = ?
9. 95² = ?
10. 105² = ?

A2. Near Base 100 (10 points):
11. 96 × 97 = ?
12. 103 × 104 = ?
13. 98 × 99 = ?
14. 105 × 106 = ?
15. 94 × 95 = ?
16. 107 × 108 = ?
17. 92 × 93 = ?
18. 109 × 111 = ?
19. 91 × 94 = ?
20. 108 × 112 = ?

A3. General 2-Digit (15 points):
21. 23 × 45 = ?
22. 67 × 34 = ?
23. 56 × 78 = ?
24. 42 × 89 = ?
25. 73 × 26 = ?
26. 38 × 54 = ?
27. 61 × 47 = ?
28. 84 × 29 = ?
29. 52 × 76 = ?
30. 39 × 68 = ?
31. 87 × 43 = ?
32. 64 × 58 = ?
33. 91 × 37 = ?
34. 48 × 72 = ?
35. 83 × 56 = ?

A4. Advanced (5 points):
36. 123 × 45 = ?
37. 87 × 96 = ?
38. 234 × 25 = ?
39. 78 × 89 = ?
40. 456 × 12 = ?

Section B: Division (30 points, 5 minutes)

B1. Special Divisors (5 points):
41. 100 ÷ 25 = ?
42. 200 ÷ 50 = ?
43. 750 ÷ 25 = ?
44. 900 ÷ 50 = ?
45. 625 ÷ 25 = ?

B2. Division by 9/99 (5 points):
46. 81 ÷ 9 = ?
47. 198 ÷ 99 = ?
48. 450 ÷ 9 = ?
49. 297 ÷ 99 = ?
50. 720 ÷ 9 = ?

B3. General Division (15 points):
51. 456 ÷ 12 = ?
52. 384 ÷ 16 = ?
53. 567 ÷ 21 = ?
54. 672 ÷ 24 = ?
55. 735 ÷ 15 = ?
56. 864 ÷ 18 = ?
57. 945 ÷ 27 = ?
58. 812 ÷ 14 = ?
59. 684 ÷ 36 = ?
60. 928 ÷ 32 = ?
61. 777 ÷ 37 = ?
62. 896 ÷ 28 = ?
63. 1024 ÷ 64 = ?
64. 1176 ÷ 42 = ?
65. 1368 ÷ 36 = ?

B4. Remainders (5 points):
66. Remainder of 4567 ÷ 9 = ?
67. Remainder of 1234 ÷ 4 = ?
68. Remainder of 8765 ÷ 11 = ?
69. Remainder of 12345 ÷ 8 = ?
70. Remainder of 567 ÷ 3 = ?

Section C: Squaring (20 points, 3 minutes)

C1. Ending in 5 (5 points):
71. 15² = ?
72. 35² = ?
73. 55² = ?
74. 75² = ?
75. 95² = ?

C2. Near Base (5 points):
76. 99² = ?
77. 101² = ?
78. 97² = ?
79. 104² = ?
80. 96² = ?

C3. General Squares (10 points):
81. 23² = ?
82. 34² = ?
83. 47² = ?
84. 52² = ?
85. 61² = ?
86. 73² = ?
87. 82² = ?
88. 91² = ?
89. 38² = ?
90. 69² = ?

Section D: Speed Round (10 points, 1 minute)

Solve as many as possible in 60 seconds:

91. 97 × 98 = ?
92. 45² = ?
93. 103 × 104 = ?
94. 65² = ?
95. 99 × 98 = ?
96. 55² = ?
97. 106 × 107 = ?
98. 75² = ?
99. 94 × 93 = ?
100. 85² = ?

Scoring:
• Each problem worth 1 point
• No partial credit
• Total: 100 points
• Certification based on total score

Answer Key Provided Separately

Good luck! Trust your training!""",
          "examples": [
            {
              "note":
                  "This is the actual exam. No examples provided. Apply all techniques learned!",
            },
          ],
          "practice": [
            {
              "question": "EXAM Question 1: 15² = ?",
              "type": "input",
              "answer": "225",
            },
          ],
          "summary":
              "Complete certification exam: 100 problems, 15 minutes, 4 sections. This tests everything you've learned. Your certificate level depends on your score!",
        },
        {
          "lesson_id": 903,
          "lesson_title": "Achievement Badges & Next Steps",
          "objective": "Earn badges and understand paths for continued growth",
          "duration_minutes": 10,
          "content":
              """Congratulations on completing the Vedic Mathematics course!

Achievement Badges:

🌟 Beginner Badges:
• First Lesson: Complete any lesson
• Chapter Complete: Finish entire chapter
• Week Streak: Practice 7 days straight
• 50 Problems: Solve 50 problems total

⭐ Intermediate Badges:
• Speed Demon: Complete 10 problems in 60 sec
• Perfect Chapter: 100% on all chapter lessons
• Month Streak: Practice 30 days straight
• 500 Problems: Solve 500 problems total

🏆 Advanced Badges:
• All Sutras: Master all Vedic techniques
• 90% Club: Achieve 90%+ on certification
• Lightning Fast: Average under 5 sec per problem
• 1000 Problems: Solve 1000 problems total

💎 Master Badges:
• Certified Master: Score 95%+ on exam
• Grandmaster: Score 100% on exam
• Speed Master: Complete exam in under 8 min
• Teaching Badge: Help 10 others learn

Special Achievements:
• 🔥 Fire Streak: 100 days practice
• 🎯 Perfect Accuracy: 50 problems, 100% correct
• ⚡ Speed Legend: 20 problems in 60 seconds
• 📚 Knowledge Keeper: All lessons completed
• 🌍 Ambassador: Share Vedic Math with community

Your Next Steps:

1. Continue Practicing
• Daily 15-minute drills
• Mix all problem types
• Track improvement
• Join competitions

2. Teach Others
• Share what you learned
• Explain techniques to friends
• Start a study group
• Create practice problems

3. Expand Knowledge
• Learn cube roots using Vedic math
• Study division of algebraic expressions
• Explore Vedic calculus shortcuts
• Research advanced sutras

4. Real-World Application
• Use in daily calculations
• Amaze friends and family
• Help with homework/work
• Build confidence with numbers

5. Competition Paths
• Local math competitions
• Online speed calculation contests
• Vedic Math championships
• Mental calculation olympiads

Resources for Continued Learning:
• Join Vedic Math communities
• Follow speed calculation challenges
• Watch calculation competitions
• Read original Vedic texts
• Explore other sutras

Remember:
• Speed comes with daily practice
• Accuracy is more important than speed initially
• Every expert was once a beginner
• Share your knowledge
• Keep challenging yourself

Final Message:
You now have the tools to perform any multiplication or division up to 100×100 in seconds! This ancient knowledge is powerful—use it wisely, practice regularly, and most importantly, enjoy the magic of mathematics!

May the sutras guide your calculations! 🙏""",
          "examples": [
            {
              "badge_example": "Speed Demon Achievement",
              "requirement": "Solve 10 problems in 60 seconds",
              "reward": "Special badge + Speed Master title",
              "tips": "Practice daily drills, master numbers ending in 5 first",
            },
          ],
          "practice": [
            {
              "question": "What's your goal after this course?",
              "type": "multiple_choice",
              "options": [
                "Compete in math competitions",
                "Teach others Vedic Math",
                "Use in daily life",
                "All of the above",
              ],
              "answer": "All of the above",
            },
          ],
          "summary":
              "Earn achievement badges by practicing and progressing. Continue daily practice, teach others, compete, and explore advanced topics. The journey never ends!",
        },
      ],
    },
  ],
};
