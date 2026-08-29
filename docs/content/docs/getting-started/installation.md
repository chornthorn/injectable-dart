---
title: "Installation"
linkTitle: "Installation"
weight: 1
description: >
  Add injectable and injectable_codegen to your Dart or Flutter project dependencies.
---

This guide explains how to add `injectable` and `injectable_codegen` to your Dart or Flutter application.

---

## 1. Add Dependencies

Add the runtime `injectable` package and `get_it` to your `dependencies`, and add `injectable_codegen` alongside `build_runner` to your `dev_dependencies`.

```bash
# In a Dart project:
dart pub add injectable get_it
dart pub add dev:injectable_codegen dev:build_runner

# In a Flutter project:
flutter pub add injectable get_it
flutter pub add dev:injectable_codegen dev:build_runner
```

### Example `pubspec.yaml`

```yaml
name: my_app
description: "A project using Injectable"
version: 1.0.0

environment:
  sdk: ^3.12.0

dependencies:
  get_it: ^9.2.1
  injectable: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
  injectable_codegen: ^1.0.0
  lints: ^5.0.0
  test: ^1.25.0
```

{{% alert title="Note" color="info" %}}
Ensure your Dart SDK constraint is at least `^3.10.0` if you plan to use Dart's dot-shorthand syntax for enums (e.g. `scope: .singleton`).
{{% /alert %}}

---

## 2. Analysis Options Configuration

Injectable generates Dart code into `.config.dart` files. If you run strict analyzer checks, you may want to exclude generated files from analysis or ignore specific lints in generated code.

In your `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - "**/*.config.dart"
```

---

## 3. Verifying the Installation

To verify that the code generator builder is correctly recognized, execute:

```bash
dart run build_runner build
```

If no annotated files exist yet, `build_runner` will report success with 0 outputs. Proceed to the [Quickstart](../quickstart/) to annotate your first services.
