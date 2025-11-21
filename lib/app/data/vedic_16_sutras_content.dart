/// Complete 16 Vedic Mathematics Sutras Content
/// Structured for interactive learning with TTS support

const vedic16SutrasData = {
  "course_info": {
    "total_sutras": 16,
    "learning_path": "Beginner → Intermediate → Advanced → Pro",
    "estimated_duration": "60 days",
    "includes": [
      "16 Vedic Sutras explained",
      "Interactive step-by-step learning",
      "Real-life examples",
      "Practice exercises",
      "Micro-quizzes",
      "Animation descriptions",
      "TTS audio narration",
    ],
  },

  "sutras": [
    {
      "sutra_id": 1,
      "sutra_name": "Ekadhikena Purvena",
      "sanskrit_meaning": "By One More Than the Previous One",
      "difficulty_level": "beginner",
      "category": "squaring",
      "chapter_id": 5,
      "lesson_id": 501,

      "simple_explanation":
          "This sutra helps you square any number ending in 5 instantly! Simply multiply the first digit by one more than itself, then append 25.",

      "tts_introduction":
          "Welcome to the first Vedic sutra: Ekadhikena Purvena, which means 'By One More Than the Previous One'. This is one of the easiest and most impressive Vedic math techniques you'll learn!",

      "real_life_examples": [
        {
          "scenario": "Quick mental calculation at a store",
          "problem":
              "If you need to calculate 25 squared for area calculations",
          "solution": "Using this sutra: 2 × 3 = 6, append 25 = 625",
          "benefit": "No calculator needed, instant answer!",
        },
        {
          "scenario": "Impressing friends at a party",
          "problem": "Someone challenges you to square 85",
          "solution": "8 × 9 = 72, append 25 = 7225",
          "benefit": "Answer in under 2 seconds!",
        },
        {
          "scenario": "Homework help",
          "problem": "Calculate 65 squared",
          "solution": "6 × 7 = 42, append 25 = 4225",
          "benefit": "Help siblings or friends instantly",
        },
      ],

      "interactive_steps": [
        {
          "step_number": 1,
          "title": "Understanding the Pattern",
          "content":
              "Any number ending in 5 follows a beautiful pattern. Let's discover it!",
          "tts_text":
              "Step 1: Understanding the Pattern. Any number ending in 5 follows a beautiful pattern. Let's discover it together!",
          "interaction_type": "tapToReveal",
          "visual_type": "highlighted",
          "animation_description":
              "Show numbers 15, 25, 35, 45, 55 appearing one by one with a sparkle effect",
        },
        {
          "step_number": 2,
          "title": "Identify the First Digit",
          "content":
              "For 25², the first digit is 2. For 35², it's 3. For 65², it's 6.",
          "tts_text":
              "Step 2: Identify the first digit. For 25 squared, the first digit is 2. For 35 squared, it's 3.",
          "interaction_type": "fillInBlank",
          "interaction_data": {
            "question": "What's the first digit of 45?",
            "answer": "4",
          },
          "animation_description":
              "Highlight the first digit with a circle that pulses",
        },
        {
          "step_number": 3,
          "title": "Add One to the First Digit",
          "content":
              "Take that first digit and add 1 to it. So 2 becomes 3, 3 becomes 4, 6 becomes 7.",
          "tts_text":
              "Step 3: Add one to the first digit. So 2 becomes 3, 3 becomes 4, and 6 becomes 7. Simple!",
          "interaction_type": "practice",
          "interaction_data": {
            "exercises": [
              {"input": "2", "output": "3"},
              {"input": "3", "output": "4"},
              {"input": "8", "output": "9"},
            ],
          },
          "animation_description": "Show +1 animation with number transforming",
        },
        {
          "step_number": 4,
          "title": "Multiply the Digits",
          "content":
              "Multiply the original first digit by the new number. For 25²: 2 × 3 = 6",
          "tts_text":
              "Step 4: Multiply the original first digit by the new number. For 25 squared: 2 times 3 equals 6.",
          "interaction_type": "calculation",
          "interaction_data": {"problem": "3 × 4", "answer": "12"},
          "animation_description":
              "Show multiplication animation with numbers combining",
        },
        {
          "step_number": 5,
          "title": "Append 25",
          "content":
              "Whatever you got from multiplication, simply add 25 at the end! For 25²: 6|25 = 625",
          "tts_text":
              "Step 5: Append 25 to your answer. For 25 squared: 6 then 25 equals 625. That's it!",
          "interaction_type": "tapToReveal",
          "visual_type": "animation",
          "animation_description":
              "Show '25' sliding into place with a satisfying click sound",
        },
        {
          "step_number": 6,
          "title": "Complete Example: 75²",
          "content":
              "Let's do a complete example: 75² = (7 × 8) | 25 = 56 | 25 = 5625",
          "tts_text":
              "Step 6: Complete example. 75 squared equals 7 times 8, which is 56, then append 25, giving us 5625.",
          "interaction_type": "stepByStep",
          "visual_type": "calculation",
          "animation_description":
              "Animate the full calculation step by step with checkmarks",
        },
      ],

      "shortcut_technique":
          "For any n5 squared: (n × (n+1)) | 25. Example: 35² = (3×4)|25 = 12|25 = 1225",

      "practice_problems": [
        {"problem": "15²", "answer": "225", "hint": "1 × 2 = 2, append 25"},
        {"problem": "45²", "answer": "2025", "hint": "4 × 5 = 20, append 25"},
        {"problem": "55²", "answer": "3025", "hint": "5 × 6 = 30"},
        {"problem": "85²", "answer": "7225", "hint": "8 × 9 = 72"},
        {"problem": "95²", "answer": "9025", "hint": "9 × 10 = 90"},
        {"problem": "105²", "answer": "11025", "hint": "10 × 11 = 110"},
        {"problem": "125²", "answer": "15625", "hint": "12 × 13 = 156"},
      ],

      "micro_quiz": [
        {
          "question": "What does Ekadhikena Purvena mean?",
          "type": "multiple_choice",
          "options": [
            "By One More Than the Previous One",
            "By One Less",
            "Multiply by Two",
            "Divide and Conquer",
          ],
          "answer": "By One More Than the Previous One",
          "tts_question": "Question 1: What does Ekadhikena Purvena mean?",
        },
        {
          "question": "In 35², what do you multiply: 3 × ___?",
          "type": "fillInBlank",
          "answer": "4",
          "hint": "One more than 3",
          "tts_question":
              "Question 2: In 35 squared, what do you multiply 3 by?",
        },
        {
          "question": "Calculate 65² using the sutra",
          "type": "input",
          "answer": "4225",
          "tts_question": "Question 3: Calculate 65 squared using the sutra",
        },
      ],

      "ui_animation_notes": {
        "intro_animation":
            "Show '5' glowing and transforming into squared result",
        "step_reveal": "Cards flip to reveal each step",
        "calculation_animation":
            "Numbers slide and combine with multiplication effect",
        "success_celebration": "Confetti burst when answer is correct",
        "hint_animation": "Lightbulb icon bounces when hint is tapped",
      },
    },

    {
      "sutra_id": 2,
      "sutra_name": "Nikhilam Navatashcaramam Dashatah",
      "sanskrit_meaning": "All from 9 and the Last from 10",
      "difficulty_level": "beginner",
      "category": "subtraction_multiplication",
      "chapter_id": 3,
      "lesson_id": 301,

      "simple_explanation":
          "This powerful sutra helps you multiply numbers near 10, 100, or 1000 super fast using complements!",

      "tts_introduction":
          "Welcome to Nikhilam Navatashcaramam Dashatah. Don't worry about the long name! It simply means: All from 9 and the last from 10. This is the most powerful Vedic multiplication technique!",

      "real_life_examples": [
        {
          "scenario": "Shopping calculations",
          "problem": "Calculate 98 × 97 for bulk purchase discount",
          "solution": "Both near 100: (98-2)|(−2×−3) = 95|06 = 9506",
          "benefit": "Instant mental calculation without calculator",
        },
        {
          "scenario": "Percentage calculations",
          "problem": "Find 96% of 95",
          "solution": "96 × 95 = 9120 (using Nikhilam)",
          "benefit": "Quick financial calculations",
        },
      ],

      "interactive_steps": [
        {
          "step_number": 1,
          "title": "What are Complements?",
          "content":
              "A complement is what you add to a number to reach a base (like 10 or 100). Example: Complement of 7 from 10 is 3.",
          "tts_text":
              "Step 1: What are complements? A complement is what you add to a number to reach a base. For example, the complement of 7 from 10 is 3, because 7 plus 3 equals 10.",
          "interaction_type": "dragAndDrop",
          "interaction_data": {
            "pairs": [
              {"number": "7", "complement": "3", "base": "10"},
              {"number": "92", "complement": "08", "base": "100"},
            ],
          },
          "animation_description":
              "Show number and complement combining to form the base with a completion animation",
        },
        {
          "step_number": 2,
          "title": "Finding Complements: All from 9, Last from 10",
          "content":
              "To find complement of 73 from 100: Subtract each digit from 9, except the last digit from 10. So: (9-7)(10-3) = 27",
          "tts_text":
              "Step 2: Finding complements. To find the complement of 73 from 100, subtract each digit from 9, except the last digit which you subtract from 10. So 9 minus 7 is 2, and 10 minus 3 is 7, giving us 27.",
          "interaction_type": "fillInBlank",
          "interaction_data": {
            "problem": "Find complement of 68 from 100",
            "steps": [
              {"position": "first", "from": 9, "digit": 6, "answer": 3},
              {"position": "last", "from": 10, "digit": 8, "answer": 2},
            ],
            "final_answer": "32",
          },
          "animation_description":
              "Show each digit being subtracted with visual number line",
        },
        {
          "step_number": 3,
          "title": "Finding Base Difference",
          "content":
              "Base difference is how far a number is from the base. 98 is -2 from 100. 103 is +3 from 100.",
          "tts_text":
              "Step 3: Finding base difference. The base difference is how far a number is from the base. 98 is negative 2 from 100, because it's 2 below. 103 is positive 3 from 100, because it's 3 above.",
          "interaction_type": "multipleChoice",
          "interaction_data": {
            "question": "What is the base difference of 96 from 100?",
            "options": ["-4", "+4", "-6", "+6"],
            "answer": "-4",
          },
          "animation_description":
              "Show number line with base at center and numbers positioned above/below",
        },
        {
          "step_number": 4,
          "title": "Nikhilam Formula for Multiplication",
          "content":
              "When multiplying near a base: (Number + Other's difference) | (Difference × Difference)",
          "tts_text":
              "Step 4: The Nikhilam formula. When multiplying numbers near a base, use this pattern: First part is the number plus the other number's difference from base. Second part is the two differences multiplied together.",
          "interaction_type": "stepByStep",
          "visual_type": "calculation",
          "animation_description":
              "Animate the formula with boxes highlighting each part",
        },
        {
          "step_number": 5,
          "title": "Example: 98 × 97",
          "content":
              "Base: 100. Differences: 98→-2, 97→-3. Cross-add: 98+(-3)=95. Multiply: (-2)×(-3)=06. Answer: 9506",
          "tts_text":
              "Step 5: Complete example. 98 times 97. Base is 100. 98 is negative 2, 97 is negative 3. Cross-add: 98 plus negative 3 equals 95. Multiply differences: negative 2 times negative 3 equals 6, written as 06. Final answer: 9506.",
          "interaction_type": "calculation",
          "visual_type": "stepByStep",
          "animation_description":
              "Animated calculation with each step appearing sequentially with sound effects",
        },
        {
          "step_number": 6,
          "title": "Practice Together: 96 × 94",
          "content":
              "Try it yourself! Differences: -4, -6. Cross-add: 96-6=90. Multiply: 4×6=24. Answer: 9024",
          "tts_text":
              "Step 6: Let's practice together. 96 times 94. Find the differences: negative 4 and negative 6. Cross-add: 96 minus 6 equals 90. Multiply differences: 4 times 6 equals 24. Combine them: 90 and 24 gives us 9024!",
          "interaction_type": "practice",
          "interaction_data": {
            "problem": "96 × 94",
            "guided_steps": true,
            "answer": "9024",
          },
          "animation_description":
              "Interactive step-by-step with user input validated at each stage",
        },
      ],

      "shortcut_technique":
          "For numbers near 100: (a + b's diff) | (a's diff × b's diff with 2 digits)",

      "practice_problems": [
        {"problem": "97 × 96", "answer": "9312", "hint": "Differences: -3, -4"},
        {"problem": "98 × 99", "answer": "9702", "hint": "Both close to 100"},
        {"problem": "102 × 103", "answer": "10506", "hint": "Above base"},
        {"problem": "95 × 95", "answer": "9025", "hint": "Same number"},
        {
          "problem": "104 × 105",
          "answer": "10920",
          "hint": "Differences: +4, +5",
        },
        {"problem": "9 × 8", "answer": "72", "hint": "Base 10: -1, -2"},
        {"problem": "12 × 11", "answer": "132", "hint": "Base 10: +2, +1"},
      ],

      "micro_quiz": [
        {
          "question": "What is the complement of 92 from 100?",
          "type": "input",
          "answer": "08",
          "hint": "All from 9, last from 10",
          "tts_question": "What is the complement of 92 from 100?",
        },
        {
          "question": "In 98 × 97, what is the base?",
          "type": "multiple_choice",
          "options": ["10", "50", "100", "1000"],
          "answer": "100",
          "tts_question": "In 98 times 97, what is the base?",
        },
        {
          "question": "Calculate 99 × 98 using Nikhilam",
          "type": "input",
          "answer": "9702",
          "tts_question": "Calculate 99 times 98 using Nikhilam sutra",
        },
      ],

      "ui_animation_notes": {
        "intro_animation": "Numbers approaching base (100) from both sides",
        "complement_visual":
            "Show missing piece fitting into place like a puzzle",
        "multiplication_flow":
            "Cross-add animation with lines connecting numbers",
        "success_celebration":
            "Numbers transform into final answer with burst effect",
      },
    },

    {
      "sutra_id": 3,
      "sutra_name": "Urdhva-Tiryagbhyam",
      "sanskrit_meaning": "Vertically and Crosswise",
      "difficulty_level": "intermediate",
      "category": "general_multiplication",
      "chapter_id": 4,
      "lesson_id": 401,

      "simple_explanation":
          "The universal multiplication method! Works for ANY two numbers - multiply vertically and crosswise to build your answer.",

      "tts_introduction":
          "Welcome to Urdhva-Tiryagbhyam, meaning Vertically and Crosswise. This is the most versatile Vedic multiplication technique - it works for any numbers, any size!",

      "real_life_examples": [
        {
          "scenario": "Any multiplication problem",
          "problem": "Calculate 47 × 63 mentally",
          "solution": "Using crosswise pattern: 2961",
          "benefit": "No long multiplication needed!",
        },
        {
          "scenario": "Checking calculator results",
          "problem": "Verify 84 × 56",
          "solution": "Quick mental check using pattern",
          "benefit": "Catch calculation errors instantly",
        },
      ],

      "interactive_steps": [
        {
          "step_number": 1,
          "title": "The Crosswise Pattern",
          "content":
              "For 23 × 12, visualize a cross pattern connecting digits. We'll multiply in three steps: right column, cross multiplication, left column.",
          "tts_text":
              "Step 1: The crosswise pattern. For 23 times 12, imagine a cross pattern connecting the digits. We multiply in three steps: right column, cross multiplication, and left column.",
          "interaction_type": "animation",
          "visual_type": "diagram",
          "animation_description":
              "Show two numbers vertically aligned with animated crossing lines highlighting multiplication pairs",
        },
        {
          "step_number": 2,
          "title": "Step 1: Rightmost Digits (Ones Place)",
          "content":
              "Multiply the last digits: 3 × 2 = 6. Write 6 in the ones place.",
          "tts_text":
              "Step 2: Ones place. Multiply the last digits: 3 times 2 equals 6. Write 6 in the ones place.",
          "interaction_type": "calculation",
          "interaction_data": {
            "highlight_digits": ["3", "2"],
            "operation": "3 × 2",
            "result": "6",
            "position": "ones",
          },
          "animation_description":
              "Highlight rightmost digits and show multiplication with result appearing in answer position",
        },
        {
          "step_number": 3,
          "title": "Step 2: Cross Multiply (Tens Place)",
          "content":
              "Cross multiply: (2 × 2) + (3 × 1) = 4 + 3 = 7. Write 7 in tens place.",
          "tts_text":
              "Step 3: Tens place. Cross multiply: 2 times 2 is 4, plus 3 times 1 is 3, total is 7. Write 7 in the tens place.",
          "interaction_type": "calculation",
          "interaction_data": {
            "cross_pairs": [
              ["2", "2"],
              ["3", "1"],
            ],
            "calculation": "(2×2) + (3×1) = 7",
            "position": "tens",
          },
          "animation_description":
              "Animate crossing lines with products adding together",
        },
        {
          "step_number": 4,
          "title": "Step 3: Leftmost Digits (Hundreds Place)",
          "content":
              "Multiply the first digits: 2 × 1 = 2. Write 2 in hundreds place.",
          "tts_text":
              "Step 4: Hundreds place. Multiply the first digits: 2 times 1 equals 2. Write 2 in the hundreds place.",
          "interaction_type": "calculation",
          "interaction_data": {
            "highlight_digits": ["2", "1"],
            "operation": "2 × 1",
            "result": "2",
            "position": "hundreds",
          },
          "animation_description":
              "Leftmost digits multiply with result sliding into final position",
        },
        {
          "step_number": 5,
          "title": "Complete Answer",
          "content": "Combine all parts: 2 | 7 | 6 = 276. That's 23 × 12!",
          "tts_text":
              "Step 5: Combine all parts. 2, 7, 6 equals 276. That's 23 times 12!",
          "interaction_type": "tapToReveal",
          "visual_type": "calculation",
          "animation_description":
              "All digits slide together to form final answer with celebration effect",
        },
        {
          "step_number": 6,
          "title": "Handling Carries",
          "content":
              "When a result is > 9, carry to next column. Example: 47 × 63 = 2961 (with carries)",
          "tts_text":
              "Step 6: Handling carries. When any result is greater than 9, we carry to the next column. Let's see how this works with 47 times 63.",
          "interaction_type": "stepByStep",
          "visual_type": "calculation",
          "animation_description":
              "Show carry animation with numbers moving to next column",
        },
      ],

      "shortcut_technique":
          "Build answer right-to-left: (1) last×last (2) cross-products (3) first×first. Handle carries.",

      "practice_problems": [
        {
          "problem": "32 × 21",
          "answer": "672",
          "hint": "Ones: 2×1, Cross: (3×1)+(2×2), Hundreds: 3×2",
        },
        {"problem": "43 × 12", "answer": "516", "hint": "Watch for carries"},
        {"problem": "56 × 34", "answer": "1904", "hint": "Larger numbers"},
        {"problem": "67 × 78", "answer": "5226", "hint": "Multiple carries"},
        {
          "problem": "89 × 91",
          "answer": "8099",
          "hint": "Near base, but practice Urdhva",
        },
      ],

      "micro_quiz": [
        {
          "question": "What does Urdhva-Tiryagbhyam mean?",
          "type": "multiple_choice",
          "options": [
            "Vertically and Crosswise",
            "From left to right",
            "Always multiply by 9",
            "Base method",
          ],
          "answer": "Vertically and Crosswise",
          "tts_question": "What does Urdhva-Tiryagbhyam mean?",
        },
        {
          "question": "In 34 × 21, what is the ones place calculation?",
          "type": "input",
          "answer": "4",
          "hint": "4 × 1",
          "tts_question": "In 34 times 21, what is the ones place calculation?",
        },
        {
          "question": "Calculate 23 × 13 using this sutra",
          "type": "input",
          "answer": "299",
          "tts_question": "Calculate 23 times 13 using Urdhva-Tiryagbhyam",
        },
      ],

      "ui_animation_notes": {
        "intro_animation": "Show crossing lines pattern forming",
        "multiplication_visual": "Digits glow as they're multiplied",
        "carry_animation": "Small number flies up to next column",
        "pattern_highlight": "Color-code vertical vs crosswise multiplications",
      },
    },

    {
      "sutra_id": 4,
      "sutra_name": "Paravartya Yojayet",
      "sanskrit_meaning": "Transpose and Apply",
      "difficulty_level": "intermediate",
      "category": "division",
      "chapter_id": 6,
      "lesson_id": 601,

      "simple_explanation":
          "Master division by transposing the divisor! This makes division as easy as multiplication.",

      "tts_introduction":
          "Paravartya Yojayet means Transpose and Apply. This brilliant sutra transforms difficult division into simple multiplication!",

      "real_life_examples": [
        {
          "scenario": "Splitting bills equally",
          "problem": "Divide 456 rupees among 12 people",
          "solution": "456 ÷ 12 = 38 using transpose method",
          "benefit": "Quick mental calculation",
        },
      ],

      "interactive_steps": [
        {
          "step_number": 1,
          "title": "What is Transposing?",
          "content":
              "Transpose means to flip or change. We change division into a related multiplication!",
          "tts_text":
              "Step 1: What is transposing? Transpose means to flip or change. In this sutra, we change division into a related multiplication problem.",
          "interaction_type": "animation",
          "animation_description":
              "Show division symbol flipping to become multiplication",
        },
        {
          "step_number": 2,
          "title": "The Flag Method",
          "content":
              "For divisor 9, the 'flag' is 1 (because 9×1 is close to 10). This flag helps us divide mentally.",
          "tts_text":
              "Step 2: The flag method. For divisor 9, the flag is 1, because 9 times 1 is close to 10. This flag helps us divide mentally.",
          "interaction_type": "fillInBlank",
          "interaction_data": {
            "question": "What is the flag for divisor 8?",
            "answer": "2",
            "explanation": "8 × 2 = 16, close to 10",
          },
          "animation_description":
              "Show flag planting on number with multiplication relationship",
        },
        {
          "step_number": 3,
          "title": "Division by 9 Example",
          "content":
              "234 ÷ 9: Process left to right. 2→2, (2×1)+3=5→5, (5×1)+4=9→0. Answer: 26 R0",
          "tts_text":
              "Step 3: Division by 9 example. 234 divided by 9. Process left to right. 2 gives quotient 2. 2 times flag 1 plus 3 equals 5, quotient 5. 5 times 1 plus 4 equals 9, which equals divisor, so quotient 0. Answer: 26 with remainder 0.",
          "interaction_type": "stepByStep",
          "visual_type": "calculation",
          "animation_description":
              "Animated flow showing each digit processing with flag multiplication",
        },
      ],

      "shortcut_technique":
          "Flag division: Process left to right, multiply by flag and add next digit",

      "practice_problems": [
        {"problem": "81 ÷ 9", "answer": "9", "hint": "Flag is 1"},
        {"problem": "72 ÷ 8", "answer": "9", "hint": "Flag is 2"},
        {
          "problem": "144 ÷ 9",
          "answer": "16",
          "hint": "Process: 1→1, 1+4=5→5+1, 5+4=9→6 R0",
        },
      ],

      "micro_quiz": [
        {
          "question": "What does Paravartya Yojayet mean?",
          "type": "multiple_choice",
          "options": [
            "Transpose and Apply",
            "Divide by 9",
            "Multiply crosswise",
            "Square it",
          ],
          "answer": "Transpose and Apply",
          "tts_question": "What does Paravartya Yojayet mean?",
        },
        {
          "question": "What is the flag for divisor 9?",
          "type": "input",
          "answer": "1",
          "tts_question": "What is the flag for divisor 9?",
        },
      ],

      "ui_animation_notes": {
        "intro_animation": "Division symbol transforms into multiplication",
        "flag_visual": "Small flag marker showing the multiplier",
        "flow_animation": "Numbers flow left to right with processing steps",
      },
    },
  ],
};

// NOTE: This file contains first 4 of 16 sutras.
// Continue with remaining 12 sutras following the same detailed structure:
// 5. Shunyam Saamyasamuccaye (When the Sum is the Same, that Sum is Zero)
// 6. Anurupye Shunyamanyat (If One is in Ratio, the Other is Zero)
// 7. Sankalana-vyavakalanabhyam (By Addition and By Subtraction)
// 8. Puranapuranabhyam (By the Completion or Non-Completion)
// 9. Chalana-Kalanabhyam (Differences and Similarities)
// 10. Yaavadunam (Whatever the Extent of its Deficiency)
// 11. Vyashtisamanstih (Part and Whole)
// 12. Shesanyankena Charamena (The Remainders by the Last Digit)
// 13. Sopaantyadvayamantyam (The Ultimate and Twice the Penultimate)
// 14. Ekanyunena Purvena (By One Less than the Previous One)
// 15. Gunitasamuchyah (The Product of the Sum is Equal to the Sum of the Product)
// 16. Gunakasamuchyah (The Factors of the Sum is Equal to the Sum of the Factors)

// Each sutra should include:
// - Simple explanation
// - TTS introduction
// - Real-life examples (3)
// - Interactive steps (6+) with TTS text
// - Shortcut technique
// - Practice problems (5-7)
// - Micro quiz (3 questions)
// - UI animation notes
