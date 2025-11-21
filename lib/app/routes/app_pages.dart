import 'package:get/get.dart';
import 'package:vedic_maths/app/pages/splash/splash_view.dart';
import 'app_routes.dart';
import '../bindings/home_binding.dart';
import '../bindings/practice_binding.dart';
import '../bindings/practice_hub_binding.dart';
import '../bindings/arithmetic_practice_binding.dart';
import '../bindings/math_tables_binding.dart';
import '../bindings/math_tables_test_binding.dart';
import '../bindings/section_detail_binding.dart';
import '../bindings/leaderboard_binding.dart';
import '../bindings/history_binding.dart';
import '../bindings/notifications_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/settings_binding.dart';
import '../bindings/vedic_course_binding.dart';
import '../bindings/enhanced_vedic_binding.dart';

import '../pages/splash/onboarding_view.dart';
import '../pages/auth/login_view.dart';
import '../pages/auth/signup_view.dart';
import '../pages/auth/otp_verification_view.dart';
import '../pages/home_view.dart';
import '../pages/math_tables/math_tables_view.dart';
import '../pages/math_tables/math_tables_test_view.dart';
import '../pages/math_tables/section_detail_view.dart';
// import '../pages/lessons/lesson_view.dart';
import '../pages/vedic_course/vedic_course_view.dart';
import '../pages/vedic_course/chapter_detail_view.dart';
import '../pages/vedic_course/lesson_detail_view.dart';
import '../pages/vedic_course/all_lessons_view.dart';
import '../pages/vedic_course/lesson_steps_view.dart';
import '../pages/vedic_course/lesson_practice_view.dart';
import '../pages/vedic_sutras/vedic_16_sutras_view.dart';
import '../pages/vedic_sutras/sutra_detail_view.dart';
import '../pages/vedic_sutras/interactive_lesson_view.dart';
import '../pages/vedic_methods/vedic_methods_overview_view.dart';
import '../pages/vedic_methods/method_detail_view.dart';
// import '../pages/quiz/quiz_view.dart';
import '../pages/practice/practice_view.dart';
import '../pages/practice/practice_hub_view.dart';
import '../pages/practice/arithmetic_setup_view.dart';
import '../pages/practice/practice_games_view.dart';
import '../bindings/sutras_practice_binding.dart';
import '../bindings/tactics_practice_binding.dart';
import '../pages/practice/practice_sutras_view.dart';
import '../pages/practice/practice_tactics_view.dart';
import '../pages/practice/practice_results_view.dart';
// import '../pages/progress/progress_view.dart';
import '../pages/leaderboard_view.dart';
import '../pages/history_view.dart';
import '../pages/notifications_view.dart';
import '../pages/settings/settings_view.dart';
import '../pages/settings/edit_profile_view.dart';
import '../pages/vedic_sutras/games/sutra1_square_dash_game.dart';
import '../pages/vedic_sutras/games/sutra2_near_base_rush_game.dart';
import '../pages/vedic_sutras/games/sutra3_crosswise_matrix_game.dart';
import '../pages/vedic_sutras/games/sutra4_division_dash_game.dart';
import '../pages/vedic_sutras/games/sutra5_zero_sum_solver_game.dart';
import '../pages/vedic_sutras/games/sutra6_ratio_racer_game.dart';
import '../pages/vedic_sutras/games/sutra7_equation_eliminator_game.dart';
import '../pages/vedic_sutras/games/sutra8_complete_adjust_game.dart';
import '../pages/vedic_sutras/games/sutra9_pattern_predictor_game.dart';
import '../pages/vedic_sutras/games/sutra10_deficiency_detector_game.dart';
import '../pages/vedic_sutras/games/sutra11_part_whole_puzzles_game.dart';
import '../pages/vedic_sutras/games/sutra12_remainder_race_game.dart';
import '../pages/vedic_sutras/games/sutra13_penultimate_puzzles_game.dart';
import '../pages/vedic_sutras/games/sutra14_decimal_dash_game.dart';
import '../pages/vedic_sutras/games/sutra15_product_sum_spotter_game.dart';
import '../pages/vedic_sutras/games/sutra16_factorization_finale_game.dart';

class AppPages {
  static const initial = Routes.SPLASH;

  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => const OTPVerificationView(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.DASHBOARD,
    //   page: () => const DashboardView(),
    //   binding: DashboardBinding(),
    // ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.MATH_TABLES,
      page: () => const MathTablesView(),
      binding: MathTablesBinding(),
    ),
    GetPage(
      name: Routes.MATH_TABLES_TEST,
      page: () => const MathTablesTestView(),
      binding: MathTablesTestBinding(),
    ),
    GetPage(
      name: Routes.SECTION_DETAIL,
      page: () => const SectionDetailView(),
      binding: SectionDetailBinding(),
    ),
    // GetPage(
    //   name: Routes.LESSONS,
    //   page: () => const LessonView(),
    //   binding: LessonBinding(),
    // ),
    GetPage(
      name: Routes.VEDIC_METHODS,
      page: () => const VedicMethodsOverviewView(),
    ),
    GetPage(name: Routes.METHOD_DETAIL, page: () => const MethodDetailView()),
    GetPage(
      name: Routes.VEDIC_COURSE,
      page: () => const VedicCourseView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.CHAPTER_DETAIL,
      page: () => const ChapterDetailView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.LESSON_DETAIL,
      page: () => const LessonDetailView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.ALL_LESSONS,
      page: () => const AllLessonsView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.LESSON_STEPS,
      page: () => const LessonStepsView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.LESSON_PRACTICE,
      page: () => const LessonPracticeView(),
      binding: VedicCourseBinding(),
    ),
    GetPage(
      name: Routes.VEDIC_16_SUTRAS,
      page: () => const Vedic16SutrasView(),
      binding: EnhancedVedicBinding(),
    ),
    GetPage(
      name: Routes.SUTRA_DETAIL,
      page: () => const SutraDetailView(),
      binding: EnhancedVedicBinding(),
    ),
    GetPage(
      name: Routes.INTERACTIVE_LESSON,
      page: () => const InteractiveLessonView(),
      binding: EnhancedVedicBinding(),
    ),
    // GetPage(
    //   name: Routes.QUIZ,
    //   page: () => const QuizView(),
    //   binding: QuizBinding(),
    // ),
    GetPage(
      name: Routes.PRACTICE,
      page: () => const PracticeView(),
      binding: PracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_HUB,
      page: () => const PracticeHubView(),
      binding: PracticeHubBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_ARITHMETIC_SETUP,
      page: () => const ArithmeticSetupView(),
      binding: ArithmeticPracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_TABLES_SETUP,
      page: () => const PracticeView(), // Reuse existing practice view
      binding: PracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_SUTRAS,
      page: () => const PracticeSutrasView(),
      binding: SutrasPracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_TACTICS,
      page: () => const PracticeTacticsView(),
      binding: TacticsPracticeBinding(),
    ),
    GetPage(
      name: Routes.PRACTICE_GAMES,
      page: () => const PracticeGamesView(),
    ),
    GetPage(
      name: Routes.PRACTICE_RESULTS,
      page: () => const PracticeResultsView(),
    ),
    // GetPage(
    //   name: Routes.PROGRESS,
    //   page: () => const ProgressView(),
    //   binding: ProgressBinding(),
    // ),
    GetPage(
      name: Routes.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: SettingsBinding(),
    ),

    // Mini Game Routes
    GetPage(name: Routes.SUTRA1_GAME, page: () => const SquareDashGame()),
    GetPage(name: Routes.SUTRA2_GAME, page: () => const NearBaseRushGame()),
    GetPage(name: Routes.SUTRA3_GAME, page: () => const CrosswiseMatrixGame()),
    GetPage(name: Routes.SUTRA4_GAME, page: () => const DivisionDashGame()),
    GetPage(name: Routes.SUTRA5_GAME, page: () => const ZeroSumSolverGame()),
    GetPage(name: Routes.SUTRA6_GAME, page: () => const RatioRacerGame()),
    GetPage(
      name: Routes.SUTRA7_GAME,
      page: () => const EquationEliminatorGame(),
    ),
    GetPage(name: Routes.SUTRA8_GAME, page: () => const CompleteAdjustGame()),
    GetPage(name: Routes.SUTRA9_GAME, page: () => const PatternPredictorGame()),
    GetPage(
      name: Routes.SUTRA10_GAME,
      page: () => const DeficiencyDetectorGame(),
    ),
    GetPage(
      name: Routes.SUTRA11_GAME,
      page: () => const PartWholePuzzlesGame(),
    ),
    GetPage(name: Routes.SUTRA12_GAME, page: () => const RemainderRaceGame()),
    GetPage(
      name: Routes.SUTRA13_GAME,
      page: () => const PenultimatePuzzlesGame(),
    ),
    GetPage(name: Routes.SUTRA14_GAME, page: () => const DecimalDashGame()),
    GetPage(
      name: Routes.SUTRA15_GAME,
      page: () => const ProductSumSpotterGame(),
    ),
    GetPage(
      name: Routes.SUTRA16_GAME,
      page: () => const FactorizationFinaleGame(),
    ),
  ];
}
