## 0.1.0

- Initial public release.
- Class-form annotations: `@Injectable`, `@InjectableInit`, `@InjectableMicroPackage`, `@ExternalMicroPackage`, `@ExternalModule`, `@Inject`, `@FactoryParam`, `@FactoryMethod`, `@PreResolve`, `@Environment`, `@Order`, `@DisposeMethod`.
- Unified `Scope` enum: `factory`, `singleton`, `lazySingleton`.
- `GetItHelper` with environment filtering and `initMicroPackage` composition.
- Built-in `EnvironmentFilter` implementations: `NoEnvOrContains`, `NoEnvOrContainsAll`, `SimpleEnvironmentFilter`.
