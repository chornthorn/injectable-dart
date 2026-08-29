---
title: "Installation"
linkTitle: "Installation"
weight: 1
description: >
  Add injectable and injectable_codegen to your Dart or Flutter project dependencies via Git URL.
---

This guide explains how to add `injectable` and `injectable_codegen` to your Dart or Flutter application.

{{% alert title="Important: Git Dependency Notice" color="warning" %}}
**Pre-Release / Git Dependency Notice**:
This toolkit is not yet published to [pub.dev](https://pub.dev). Because the `injectable` package name is already taken on pub.dev by a legacy library, we plan to rename the package under a new namespace prior to its official pub.dev release.

In the meantime, you can use the toolkit directly from GitHub using **Git URL dependencies** with the corresponding subdirectory paths (`path: injectable` and `path: injectable_codegen`).
{{% /alert %}}

---

## 1. Add Dependencies via Git

Add `get_it` and the runtime `injectable` package to your `dependencies`, and add `build_runner` and `injectable_codegen` to your `dev_dependencies` in your `pubspec.yaml`.

### Example `pubspec.yaml`

```yaml
name: my_app
description: "A project using Injectable"
version: 1.0.0

environment:
  sdk: ^3.12.0

dependencies:
  get_it: ^9.2.1
  injectable:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable
      # Optionally pin to a specific branch or commit hash:
      # ref: main

dev_dependencies:
  build_runner: ^2.4.0
  injectable_codegen:
    git:
      url: https://github.com/chornthorn/injectable-dart.git
      path: injectable_codegen
      # ref: main
  lints: ^5.0.0
  test: ^1.25.0
```

### Fetch Dependencies

Run `pub get` to resolve and download the git dependencies:

```bash
# In a Dart project:
dart pub get

# In a Flutter project:
flutter pub get
```

{{% alert title="Dart SDK Version" color="info" %}}
Ensure your Dart SDK constraint is at least `^3.10.0` (or `^3.12.0`) to take advantage of Dart 3 language features like dot-shorthand enums (`scope: .singleton`).
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
