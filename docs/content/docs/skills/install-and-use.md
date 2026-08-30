---
title: "Installation & Usage"
linkTitle: "Installation & Usage"
weight: 2
description: >
  How to install and activate the Injectify Agent Skill in your Dart and Flutter projects.
---

Follow this guide to equip your AI assistant with the Injectify Agent Skill.

---

## 1. Adding the Skill to Your Project

You can copy the official Injectify skill into your project's agent skill directory.

### Standard Agent Skills Directory

Most modern agent runners look for skills under `.agents/skills/` or `skills/`:

```bash
# Create the skill directory in your project root
mkdir -p .agents/skills/injectify

# Copy the skill from the injectify-dart repository
cp -r /path/to/injectify-dart/skills/injectify/* .agents/skills/injectify/
```

### Tool-Specific Locations

Depending on the AI tool you use, place the folder in the corresponding configuration path:

- **Claude Code**: `.claude/skills/injectify/` or `.agents/skills/injectify/`
- **Antigravity / Gemini CLI**: `.agents/skills/injectify/` or `.gemini/skills/injectify/`
- **Cursor**: `.cursor/skills/injectify/` or `.agents/skills/injectify/`

---

## 2. Configuring Dependencies

Make sure your `pubspec.yaml` references `injectify` and `injectify_generator`:

```yaml
dependencies:
  get_it: ^9.2.1
  injectify:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify

dev_dependencies:
  build_runner: ^2.4.0
  injectify_generator:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify_generator
```

---

## 3. Example Prompts for Your AI Agent

Once the skill is installed, your AI assistant will automatically activate it when you ask dependency injection questions or request code changes.

### Prompt 1: Initial Container Setup

```text
Set up Injectify and GetIt in my Flutter app with support for folder-scoped micro-packages.
```

The agent will:

1. Create `lib/injection.dart` with `@InjectableInit(useMicroPackage: true)`.
2. Update `main.dart` with `await configureDependencies()`.
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`.

### Prompt 2: Creating a Feature Micro-Package

```text
Create a new feature module 'orders' under lib/features/orders with an isolated @InjectableMicroPackage and an OrderRepository lazy singleton.
```

The agent will:

1. Create `lib/features/orders/orders_module.dart` with `@InjectableMicroPackage(moduleName: 'Orders')`.
2. Create `OrderRepository` annotated with `@Injectable(scope: Scope.lazySingleton)`.
3. Run `build_runner` to generate `orders_module.config.dart`.

### Prompt 3: Registering Third-Party Services

```text
Create an @ExternalModule to provide a Dio HTTP client with custom base URL and a pre-resolved SharedPreferences instance.
```

The agent will:

1. Define an abstract class with `@ExternalModule()`.
2. Annotate `Dio` with `@Injectable(scope: Scope.lazySingleton)`.
3. Annotate `SharedPreferences` with `@PreResolve()` and `@Injectable(scope: Scope.singleton)`.

---

## 4. Validating Generated Code

Always ensure your build runner produces clean output after changes:

```bash
# Dart
dart run build_runner build --delete-conflicting-outputs

# Flutter
flutter pub run build_runner build --delete-conflicting-outputs
```
