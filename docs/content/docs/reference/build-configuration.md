---
title: "Build Configuration Reference"
linkTitle: "Build Configuration"
weight: 2
description: >
  build.yaml options and build_runner CLI configuration for injectify_generator.
---

Injectify integrates with Dart's `build_runner` code generation ecosystem through `injectify_generator`.

---

## 1. Builder Definition (`build.yaml`)

`injectify_generator` registers its builder in `build.yaml`:

```yaml
builders:
  injectify_generator:
    import: "package:injectify_generator/builder.dart"
    builder_factories: ["injectifyBuilder"]
    build_extensions: { ".dart": [".config.dart"] }
    auto_apply: dependents
    build_to: source
```

- **`build_extensions`**: Emits files ending with `.config.dart` alongside the target `.dart` files.
- **`build_to: source`**: Emits directly into `lib/` so generated code can be committed and inspected.
- **`auto_apply: dependents`**: Automatically triggers whenever `injectify_generator` is listed in `dev_dependencies`.

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
