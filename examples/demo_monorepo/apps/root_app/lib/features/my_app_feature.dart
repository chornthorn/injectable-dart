import 'package:injectable/injectable.dart';
import 'package:shared/app_config.dart';

@Injectable(scope: .singleton) // its also support dart-dotshorthand syntax
class MyAppFeature {
  final AppConfig _config;

  MyAppFeature(this._config);

  String hello() => '${_config.appName} v${_config.version} -- MyAppFeature';
}
