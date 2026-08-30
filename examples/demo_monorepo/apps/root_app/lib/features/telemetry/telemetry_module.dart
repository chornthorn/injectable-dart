import 'package:injectify/injectify.dart';

/// Folder-scoped micro-package boundary for the async `telemetry` feature.
@InjectableMicroPackage(moduleName: 'Telemetry')
void configureTelemetryModule() {}
