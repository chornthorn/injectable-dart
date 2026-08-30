# Environments & Filtering Example

Demo of **environment gating** and **environment filters** in
[Injectable](https://github.com/chornthorn/injectable-dart).

## What it demonstrates

| Topic | Where |
| --- | --- |
| `@Injectable(env: [...])` on interface implementations | `lib/services/api_service.dart`, `lib/services/analytics_service.dart` |
| Standalone `@Environment('staging')` annotation | `lib/services/feature_flags.dart` |
| Un-gated dependencies (registered everywhere) | `lib/services/app_config.dart` |
| A dependency requiring multiple environments | `lib/services/debug_logger.dart` |
| Built-in filters `NoEnvOrContains` / `NoEnvOrContainsAll` | `bin/environments_filtering_example.dart` (sections 3–4) |
| Custom `EnvironmentFilter` (denylist semantics) | `lib/custom_environment_filter.dart` |

## Run

```bash
# 1. Resolve the workspace (from the repo root)
dart pub get

# 2. Generate lib/injection.config.dart
dart run build_runner build --delete-conflicting-outputs

# 3. Run the demo
dart run bin/environments_filtering_example.dart
```

## Test

```bash
dart test
```

The demo walks through five initialization strategies:

1. `init(environment: 'dev')` — mock implementations only.
2. `init(environment: 'prod')` — live implementations only; resolving a
   dev-only service throws.
3. `init(environmentFilter: NoEnvOrContains({'dev', 'staging'}))` — multiple
   active environments at once.
4. `NoEnvOrContainsAll` — requires **every** declared environment to be active.
5. `init(environmentFilter: NotInFilter({'prod'}))` — a custom denylist filter.
