---
title: "Architecture & Pipeline"
linkTitle: "Architecture & Pipeline"
weight: 1
description: >
  The build-time generation pipeline and runtime adapter architecture of Injectable.
---

Injectable is composed of two primary layers:
1. **Runtime Framework (`package:injectable`)**: Lightweight annotations, interfaces, and the `GetItHelper` adapter.
2. **Build-Time Generator (`package:injectable_codegen`)**: An analyzer-driven `build_runner` builder that parses Dart code and generates type-safe configuration files.

---

## 1. High-Level Generation Pipeline

The generation process executes as a pipeline with six distinct stages:

```mermaid
flowchart TD
    A["1. Source Discovery<br/>(build_runner findAssets)"] --> B["2. Annotation Parsing<br/>(AnnotationParser)"]
    B --> C{"3. Micro-Package Gate<br/>(isMicroPackageGloballyEnabled)"}
    C -- "Enabled" --> D["4. Boundary Scanning & Exclusion<br/>(LibraryScanner)"]
    C -- "Disabled" --> SKIP["Skip Generation"]
    D --> E["5. Dependency Parsing<br/>(DependencyParser)"]
    E --> F["6. Import Alias Registration<br/>(ImportAliasRegistry)"]
    F --> G["7. Code Emission<br/>(ImportEmitter, ModuleClassEmitter, RegistrationEmitter)"]
    G --> H["Output File<br/>&lt;file&gt;.config.dart"]
```

---

## 2. Detailed Pipeline Stages

### Stage 1: Annotation Parsing (`AnnotationParser`)
The generator inspects the entry-point file for `@InjectableInit` or `@InjectableMicroPackage`. It extracts:
- Initializer method name (`initializerName`, default `'init'`).
- Micro-package flags (`useMicroPackage`, `modules`, `externalMicroPackages`).
- Custom naming (`moduleName`, `moduleClassName`).
- Generation preferences (`preferRelativeImports`, `asExtension`).

{{% alert title="Note" color="info" %}}
`AnnotationParser` employs dual-mode resolution: a primary `TypeChecker` / `ConstantReader` mechanism, paired with an AST syntactic fallback for scenarios where constant analysis is incomplete.
{{% /alert %}}

### Stage 2: Micro-Package Gating (`isMicroPackageGloballyEnabled`)
Before generating code for a micro-package, the builder scans `lib/**.dart` to verify whether micro-package mode is globally active in the package. If a root initializer exists with `useMicroPackage: false`, sub-folder micro-package generation is skipped to avoid orphaned or conflicting output.

### Stage 3: Boundary Scanning & Exclusion (`LibraryScanner`)
`LibraryScanner` computes the scan boundary:
- For **root compositors**, the glob is `lib/**.dart`.
- For **folder micro-packages**, the glob is restricted to the folder containing the annotated file (e.g. `lib/features/cart/**.dart`).
- **Boundary Exclusion**: Any nested subdirectories containing their own `@InjectableMicroPackage` are discovered and dynamically excluded from the parent module's scan. This guarantees that sub-feature dependencies are never duplicate-registered.

### Stage 4: Dependency Parsing (`DependencyParser`)
For every class within the computed scan boundary, `DependencyParser` extracts:
- Target lifecycle (`Scope.factory`, `Scope.singleton`, `Scope.lazySingleton`).
- Bound interfaces (`@Injectable(as: ServiceInterface)`).
- Constructor parameters and their injection qualifiers (`@Inject('tag')`, `@FactoryParam`).
- Environment restrictions (`@Environment('dev')`, `@dev`).
- Async initialization status (`@PreResolve` or `Future` return types).
- Explicit sort order (`@Order(int)`).

### Stage 5: Import Aliasing (`ImportAliasRegistry`)
To prevent identifier collisions between classes with identical names across different libraries or packages, `ImportAliasRegistry` assigns unique prefixes (`_i1`, `_i2`, ... `_iN`) for each imported package or library.

### Stage 6: Code Emission
The emitters write the finalized `.config.dart` file:
- `ImportEmitter`: Generates prefixed imports and header doc comments.
- `ModuleClassEmitter`: Generates the `MicroPackageModule` class or `GetIt` extension method.
- `RegistrationEmitter`: Emits calls to `gh.factory()`, `gh.singleton()`, `gh.lazySingleton()`, `gh.singletonAsync()`, `gh.factoryWithParam()`, and external micro-package invocations.

---

## 3. Emitted Output Types

Depending on the annotation used on the target file, Injectable produces one of two output structures:

| Target File Annotation | Output Structure | Usage |
| :--- | :--- | :--- |
| `@InjectableInit()` | `extension GetItInjectableX on GetIt` with `init()` method | Top-level application bootstrap |
| `@InjectableMicroPackage()` | Subclass of `MicroPackageModule` (e.g. `AuthInjectableModule`) | Reusable feature module |
