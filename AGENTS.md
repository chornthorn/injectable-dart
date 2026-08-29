# Agent Rules & Guidelines

## 1. No Backward Compatibility Needed

- **Never maintain backward compatibility**: When refactoring, renaming, or modifying APIs, classes, annotations, or parameters, completely remove the old symbols and replace them directly.
- **Do not introduce deprecated aliases or typedefs**: Do not leave legacy aliases, fallback typedefs, or deprecated shims (e.g., no `typedef Singleton = Injectable;`, no legacy `@module`, no `@Named`, no `@thirdParty`).
- **Clean and breaking changes are preferred**: Keep the codebase modern, clean, and free of redundant compatibility wrappers.

## 2. Architecture & Design Principles

- **Dart Idiomatic & Minimalist**: Avoid unnecessary boilerplates and maintain clean, self-documenting code.
- **Injectable Micro-Packages**:
  - `@InjectableMicroPackage(moduleName: 'Feature')` defines a folder-scoped micro-package.
  - Root `@InjectableInit(useMicroPackage: true)` discovers and registers all micro-packages flatly at the root container.
  - `@InjectableMicroPackage(useMicroPackage: true)` auto-composes its nested sub micro-packages inside its generated module's `init()` (default `false`). Compose each module exactly once.
  - `@InjectableInit(externalMicroPackages: [ExternalMicroPackage(ModuleType)])` composes module types from other packages (own pubspec) in declaration order — the generated `init()` calls `gh.initMicroPackage(...)` for each. Prefer this over manual `getIt.initX()` wiring.
  - Use unified `@Injectable(scope: Scope.singleton | Scope.lazySingleton | Scope.factory)`.
  - Use `@ExternalModule()` for external provider modules and `@Inject('tag')` for qualifiers.
