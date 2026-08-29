import 'package:injectable/injectable.dart';

/// Folder-scoped micro-package boundary for the async `telemetry` feature.
@InjectableMicroPackage(moduleName: 'Telemetry')
void configureTelemetryModule() {}
