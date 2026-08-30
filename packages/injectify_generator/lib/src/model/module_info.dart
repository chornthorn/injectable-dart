import 'package:build/build.dart';

import 'dependency_info.dart';

/// Represents a discovered micro-package module.
class DiscoveredModule {
  final String moduleClassName;
  final AssetId assetId;
  final String directory;
  final Uri packageUri;

  const DiscoveredModule({
    required this.moduleClassName,
    required this.assetId,
    required this.directory,
    required this.packageUri,
  });
}

/// Result of scanning a directory tree for dependencies and sub-modules.
class ModuleScanResult {
  final List<DependencyInfo> dependencies;
  final List<DiscoveredModule> subModules;
  final Set<Uri> typeUris;

  const ModuleScanResult({
    this.dependencies = const [],
    this.subModules = const [],
    this.typeUris = const {},
  });
}

/// Reference to an external [MicroPackageModule] type (from another package
/// with its own pubspec) to be composed by the generated initializer.
class ExternalMicroPackageInfo {
  /// The generated module class name (e.g. `SharedInjectableModule`).
  final String typeName;

  /// The library URI of the module class (for aliased imports).
  final Uri? typeUri;

  const ExternalMicroPackageInfo({required this.typeName, this.typeUri});
}

/// Configuration parsed from [@InjectableInit] or [@InjectableMicroPackage].
class InjectableConfig {
  final bool isMicroPackage;
  final bool useMicroPackage;
  final String initializerName;
  final bool asExtension;
  final bool preferRelativeImports;
  final String moduleClassName;
  final String? moduleName;
  final List<String> manualModuleTypeNames;
  final List<ExternalMicroPackageInfo> externalMicroPackages;

  const InjectableConfig({
    required this.isMicroPackage,
    required this.useMicroPackage,
    required this.initializerName,
    required this.asExtension,
    required this.preferRelativeImports,
    required this.moduleClassName,
    this.moduleName,
    this.manualModuleTypeNames = const [],
    this.externalMicroPackages = const [],
  });
}
