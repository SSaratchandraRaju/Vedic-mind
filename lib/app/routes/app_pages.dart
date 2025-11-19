import 'package:get/get.dart';
import 'app_routes.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/lesson_binding.dart';
import '../bindings/quiz_binding.dart';
import '../bindings/practice_binding.dart';
import '../bindings/progress_binding.dart';
import '../bindings/math_tables_binding.dart';
import '../bindings/section_detail_binding.dart';
import '../bindings/leaderboard_binding.dart';
import '../bindings/history_binding.dart';
import '../bindings/notifications_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/settings_binding.dart';
import '../bindings/vedic_course_binding.dart';
import '../ui/pages/splash/splash_view.dart';
import '../ui/pages/onboarding/onboarding_view.dart';
import '../ui/pages/auth/login_view.dart';
import '../ui/pages/auth/signup_view.dart';
import '../ui/pages/auth/otp_verification_view.dart';
import '../ui/pages/dashboard/dashboard_view.dart';
import '../ui/pages/home/home_view.dart';
import '../ui/pages/math_tables/math_tables_view.dart';
import '../ui/pages/section_detail/section_detail_view.dart';
import '../ui/pages/lessons/lesson_view.dart';
import '../ui/pages/vedic_course/vedic_course_view.dart';
import '../ui/pages/vedic_course/chapter_detail_view.dart';
import '../ui/pages/vedic_course/lesson_detail_view.dart';
import '../ui/pages/vedic_course/lesson_steps_view.dart';
import '../ui/pages/vedic_course/lesson_practice_view.dart';
import '../ui/pages/vedic_methods/vedic_methods_overview_view.dart';
import '../ui/pages/vedic_methods/method_detail_view.dart';
import '../ui/pages/quiz/quiz_view.dart';
import '../ui/pages/practice/practice_view.dart';
import '../ui/pages/practice/practice_results_view.dart';
import '../ui/pages/progress/progress_view.dart';
import '../ui/pages/leaderboard/leaderboard_view.dart';
import '../ui/pages/history/history_view.dart';
import '../ui/pages/notifications/notifications_view.dart';
import '../ui/pages/settings/settings_view.dart';
import '../ui/pages/settings/edit_profile_view.dart';

class AppPages {
  static const initial = Routes.SPLASH;

  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(name: Routes.ONBOARDING, page: () => const OnboardingView(), binding: OnboardingBinding()),
    GetPage(name: Routes.LOGIN, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: Routes.SIGNUP, page: () => const SignupView(), binding: AuthBinding()),
    GetPage(name: Routes.OTP_VERIFICATION, page: () => const OTPVerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.DASHBOARD, page: () => const DashboardView(), binding: DashboardBinding()),
    GetPage(name: Routes.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: Routes.MATH_TABLES, page: () => const MathTablesView(), binding: MathTablesBinding()),
    GetPage(name: Routes.SECTION_DETAIL, page: () => const SectionDetailView(), binding: SectionDetailBinding()),
    GetPage(name: Routes.LESSONS, page: () => const LessonView(), binding: LessonBinding()),
    GetPage(name: Routes.VEDIC_METHODS, page: () => const VedicMethodsOverviewView()),
    GetPage(name: Routes.METHOD_DETAIL, page: () => const MethodDetailView()),
    GetPage(name: Routes.VEDIC_COURSE, page: () => const VedicCourseView(), binding: VedicCourseBinding()),
    GetPage(name: Routes.CHAPTER_DETAIL, page: () => const ChapterDetailView(), binding: VedicCourseBinding()),
    GetPage(name: Routes.LESSON_DETAIL, page: () => const LessonDetailView(), binding: VedicCourseBinding()),
    GetPage(name: Routes.LESSON_STEPS, page: () => const LessonStepsView(), binding: VedicCourseBinding()),
    GetPage(name: Routes.LESSON_PRACTICE, page: () => const LessonPracticeView(), binding: VedicCourseBinding()),
    GetPage(name: Routes.QUIZ, page: () => const QuizView(), binding: QuizBinding()),
    GetPage(name: Routes.PRACTICE, page: () => const PracticeView(), binding: PracticeBinding()),
    GetPage(name: Routes.PRACTICE_RESULTS, page: () => const PracticeResultsView()),
    GetPage(name: Routes.PROGRESS, page: () => const ProgressView(), binding: ProgressBinding()),
    GetPage(name: Routes.LEADERBOARD, page: () => const LeaderboardView(), binding: LeaderboardBinding()),
    GetPage(name: Routes.HISTORY, page: () => const HistoryView(), binding: HistoryBinding()),
    GetPage(name: Routes.NOTIFICATIONS, page: () => const NotificationsView(), binding: NotificationsBinding()),
    GetPage(name: Routes.SETTINGS, page: () => const SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.EDIT_PROFILE, page: () => const EditProfileView(), binding: SettingsBinding()),
  ];
}

