---
title: "Build Configuration Reference"
linkTitle: "Build Configuration"
weight: 2
description: >
  build.yaml options and build_runner CLI configuration for injectable_codegen.
---

Injectable integrates with Dart's `build_runner` code generation ecosystem through `injectable_codegen`.

---

## 1. Builder Definition (`build.yaml`)

`injectable_codegen` registers its builder in `build.yaml`:

```yaml
builders:
  injectable_generator:
    import: "package:injectable_codegen/builder.dart"
    builder_factories: ["injectableBuilder"]
    build_extensions: {".dart": [".config.dart"]}
    auto_apply: dependents
    build_to: source
```

- **`build_extensions`**: Emits files ending with `.config.dart` alongside the target `.dart` files.
- **`build_to: source`**: Emits directly into `lib/` so generated code can be committed and inspected.
- **`auto_apply: dependents`**: Automatically triggers whenever `injectable_codegen` is listed in `dev_dependencies`.

---

## 2. CLI Commands

### Standard Build
Generate files once:
```bash
dart run build_runner build
```

### Clean Rebuild
Resolve conflicting outputs or regenerate after changes:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Continuous Watch Mode
Automatically recompile when files change:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 3. Customizing Build Options

You can override builder settings in your project's root `build.yaml`:

```yaml
targets:
  $default:
    builders:
      injectable_codegen:injectable_generator:
        options:
          # Options can be passed here if extended in future versions
```
