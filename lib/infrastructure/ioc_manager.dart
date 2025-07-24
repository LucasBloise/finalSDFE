import 'package:final_sd_front/features/favorites/presentation/favorites_view_model.dart';
import 'package:final_sd_front/features/home/presentation/home_view_model.dart';
import 'package:final_sd_front/features/home/services/auth_service.dart';
import 'package:final_sd_front/features/home/services/character_service.dart';
import 'package:final_sd_front/features/home/services/i_auth_service.dart';
import 'package:final_sd_front/features/home/services/i_character_service.dart';
import 'package:final_sd_front/integrations/http_helper/dio_instances.dart';
import 'package:final_sd_front/integrations/http_helper/http_helper.dart';
import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';
import 'package:final_sd_front/integrations/injector/i_injector.dart';
import 'package:final_sd_front/integrations/injector/injector.dart';
import 'package:final_sd_front/integrations/navigation/app_router.dart';
import 'package:final_sd_front/integrations/navigation/i_navigation.dart';
import 'package:final_sd_front/integrations/navigation/navigation.dart';
import 'package:final_sd_front/integrations/navigation/routes.dart';

abstract class IocManager {
  static late IInjector _injector;

  static void register() {
    _injector = IInjector.register(Injector());
    _registerCommonDependencies(_injector);
  }

  static void _registerCommonDependencies(IInjector injector) {
    injector
      ..registerFactory<IHttpHelper>(
        () => HttpHelper(
          drCallDio: HttpClientInstances.httpClient,
          publicRequestsDio: HttpClientInstances.httpPublicClient,
        ),
      )
      ..registerLazySingleton<IAuthService>(
          () => AuthService(httpHelper: resolve<IHttpHelper>()))
      ..registerLazySingleton<ICharacterService>(
          () => CharacterService(httpHelper: resolve<IHttpHelper>()))
      ..registerFactory<HomeViewModel>(
        () => HomeViewModel(
            authService: resolve<IAuthService>(),
            characterService: resolve<ICharacterService>()),
      )
      ..registerFactory<FavoritesViewModel>(() => FavoritesViewModel())
      ..registerLazySingleton<INavigation>(() => Navigation(routeBuilders));
  }

  static T resolve<T extends Object>() {
    return _injector.resolve<T>();
  }
}
