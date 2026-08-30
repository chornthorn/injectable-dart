# Environments & Filtering Example

Demo of **environment gating** and **environment filters** in
[Injectify](https://github.com/chornthorn/injectify-dart), built around a
real-world use case: an e-commerce **checkout feature** whose payment gateway
is chosen by environment, so _test mode can never run in production_.

## What it demonstrates

| Topic                                                        | Where                                                                                                                                                                             |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Real-world checkout feature (payment gateway + orchestrator) | `lib/features/checkout/`                                                                                                                                                          |
| `@Injectable(env: [...])` on interface implementations       | `lib/services/api_service.dart`, `lib/services/analytics_service.dart`, `lib/features/checkout/sandbox_payment_gateway.dart`, `lib/features/checkout/stripe_payment_gateway.dart` |
| Standalone `@Environment('staging')` annotation              | `lib/services/feature_flags.dart`                                                                                                                                                 |
| Un-gated dependencies (registered everywhere)                | `lib/services/app_config.dart`                                                                                                                                                    |
| A dependency requiring multiple environments                 | `lib/services/debug_logger.dart`                                                                                                                                                  |
| Built-in filters `NoEnvOrContains` / `NoEnvOrContainsAll`    | `bin/environments_filtering_example.dart` (sections 3–4)                                                                                                                          |
| Custom `EnvironmentFilter` (denylist semantics)              | `lib/custom_environment_filter.dart`                                                                                                                                              |

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

The demo walks through five initialization strategies, running a real checkout
in each:

1. `init(environment: 'dev')` — a full checkout completes on the **sandbox**
   gateway; no real money moves and console analytics log the event.
2. `init(environment: 'prod')` — checkout goes through the **live** gateway;
   the container never contains the sandbox gateway, so test mode is impossible.
3. `init(environmentFilter: NoEnvOrContains({'dev', 'staging'}))` — checkout
   works (dev) while staging-only preview feature flags are also available.
4. `NoEnvOrContainsAll` — requires **every** declared environment to be active;
   a strict filter can even make `CheckoutService` unresolvable when the
   gateway's environments aren't all active.
5. `init(environmentFilter: NotInFilter({'prod'}))` — a custom denylist filter
   that blocks prod-gated dependencies while everything else stays registered.
