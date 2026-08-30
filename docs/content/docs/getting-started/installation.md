---
title: "Installation"
linkTitle: "Installation"
weight: 1
description: >
  Add injectify and injectify_generator to your Dart or Flutter project dependencies.
---

This guide explains how to add `injectify` and `injectify_generator` to your Dart or Flutter application.

---

## 1. Add Dependencies

Add `get_it` and `injectify` to your `dependencies`, and add `build_runner` and `injectify_generator` to your `dev_dependencies` in your `pubspec.yaml`.

### Example `pubspec.yaml`

```yaml
name: my_app
description: "A project using Injectify"
version: 1.0.0

environment:
  sdk: ^3.12.0

dependencies:
  get_it: ^9.2.1
  injectify:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify
      # Optionally pin to a specific branch or commit hash:
      # ref: main

dev_dependencies:
  build_runner: ^2.4.0
  injectify_generator:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify_generator
      # ref: main
  lints: ^5.0.0
  test: ^1.25.0
```

### Fetch Dependencies

Run `pub get` to resolve and download dependencies:

```bash
# In a Dart project:
dart pub get

# In a Flutter project:
flutter pub get
```

{{% alert title="Dart SDK Version" color="info" %}}
Ensure your Dart SDK constraint is at least `^3.0.0` (or `^3.12.0`).
{{% /alert %}}

---

## 2. Analysis Options Configuration

Injectify generates Dart code into `.config.dart` files. If you run strict analyzer checks, you may want to exclude generated files from analysis or ignore specific lints in generated code.

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
dart run build_runner build --delete-conflicting-outputs
```

If no annotated files exist yet, `build_runner` will report success with 0 outputs. Proceed to the [Quickstart](../quickstart/) to annotate your first services.
