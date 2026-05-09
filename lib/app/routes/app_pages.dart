import 'package:get/get.dart';

import '../modules/chapter_details/bindings/chapter_details_binding.dart';
import '../modules/chapter_details/views/chapter_details_view.dart';
import '../modules/concept_map/bindings/concept_map_binding.dart';
import '../modules/concept_map/views/concept_map_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/select_difficulty/bindings/select_difficulty_binding.dart';
import '../modules/select_difficulty/views/select_difficulty_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.CHAPTER_DETAILS,
      page: () => const ChapterDetailsView(),
      binding: ChapterDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_DIFFICULTY,
      page: () => const SelectDifficultyView(),
      binding: SelectDifficultyBinding(),
    ),
    GetPage(
      name: _Paths.CONCEPT_MAP,
      page: () => const ConceptMapView(),
      binding: ConceptMapBinding(),
    ),
  ];
}
