import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator/injectable_generator.dart';

/// Builder factory for Injectify code generator.
Builder injectifyBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const InjectableGenerator(),
    generatedExtension: '.config.dart',
    header: '',
  );
}
