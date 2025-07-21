import 'package:final_sd_front/integrations/http_helper/dio_instances.dart';
import 'package:final_sd_front/integrations/http_helper/http_helper.dart';
import 'package:final_sd_front/integrations/http_helper/i_http_helper.dart';
import 'package:final_sd_front/integrations/injector/i_injector.dart';
import 'package:final_sd_front/integrations/injector/injector.dart';
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
      ..registerLazySingleton<INavigation>(() => Navigation(routeBuilders));
  }

  static T resolve<T extends Object>() {
    return _injector.resolve<T>();
  }
}
