# Troubleshooting & Diagnostics

Common issues, generator errors, and debugging strategies for `injectify` and `injectify_generator`.

---

## 1. Circular Dependency Detected

### Symptom

`build_runner` fails with a cyclic dependency error during topological sort (e.g., `ServiceA -> ServiceB -> ServiceA`).

### Cause

Two or more classes depend on each other through constructor parameters.

### Solution

- Refactor the code to break the cycle by extracting shared logic into a separate `ServiceC` or repository.
- Use an interface or event bus/stream instead of direct bi-directional constructor coupling.
- If necessary, pass one dependency via a method call rather than in the constructor.

---

## 2. Double Registration / "Object/factory already registered in GetIt"

### Symptom

Runtime exception `StateError: Object/factory with type X is already registered in GetIt`.

### Cause

A micro-package is composed more than once:

- The parent micro-package composed it with `useMicroPackage: true` AND the root `injection.dart` composed it again.
- Or `@InjectableInit(externalMicroPackages: [...])` registered a module that was also registered manually in `main()`.

### Solution

- Adhere strictly to the **Single Composition Rule**:
  - If a nested micro-package is auto-composed by its parent module (`useMicroPackage: true`), remove any duplicate reference in the root container.
  - Avoid calling manual `getIt.initFeatureX()` if the module is already included in `externalMicroPackages`.

---

## 3. Unresolved Type / Missing Dependency

### Symptom

Generated code contains `gh<dynamic>()` or compilation error: `Couldn't find constructor for Type`.

### Cause

- A dependency parameter type is not annotated with `@Injectable()` or provided by an `@ExternalModule()`.
- Or the dependency belongs to a different folder micro-package and is not public / not accessible.

### Solution

- Ensure the missing type is annotated with `@Injectable(scope: ...)`.
- If it is a third-party class, add a getter or method in an `@ExternalModule()`.
- Check import visibility across folders/packages.

---

## 4. Pending Future / Async GetIt Throws

### Symptom

Calling `getIt<Database>()` throws `StateError: Database has not been initialized or is still pending`.

### Cause

`Database` is an asynchronous singleton (`Future<Database>` or `@PreResolve`), but the app tried to resolve it synchronously before awaiting `configureDependencies()` or `getIt.allReady()`.

### Solution

- Ensure `await configureDependencies()` is awaited inside `main()`:
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    runApp(const MyApp());
  }
  ```
- If the dependency is resolved before all singletons are ready, use `await getIt.getAsync<Database>()` or `await getIt.allReady()`.

---

## 5. Build Runner Cache Issues

### Symptom

Code generator does not reflect recent changes, or builds fail with stale file errors.

### Solution

Clean the build cache and regenerate:

```bash
# Dart
dart run build_runner clean
dart run build_runner build

# Flutter
flutter pub run build_runner clean
flutter pub run build_runner build
```
