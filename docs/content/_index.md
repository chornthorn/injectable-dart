---
title: "Injectable"
linkTitle: "Injectable"
---

{{< blocks/cover title="Injectable for Dart & Flutter" image_anchor="top" height="min" color="primary" >}}
<p class="lead mt-4">
A modern, code-generated dependency injection toolkit for Dart & Flutter, built on <code>GetIt</code> with <b>folder-scoped micro-packages</b> and explicit class-form annotations.
</p>
<div class="mx-auto mt-4">
    <a class="btn btn-lg btn-primary me-3 mb-4" href="docs/">
        Get Started <i class="fas fa-arrow-alt-circle-right ms-2"></i>
    </a>
    <a class="btn btn-lg btn-secondary me-3 mb-4" href="https://github.com/chornthorn/injectable-dart" target="_blank" rel="noopener">
        View on GitHub <i class="fab fa-github ms-2"></i>
    </a>
</div>
{{< /blocks/cover >}}

{{% blocks/lead color="white" %}}
Designed for scalable, modular Flutter and Dart applications with zero boilerplate, compile-time validation, and deterministic startup.
{{% /blocks/lead %}}

{{< blocks/section color="light" type="row" >}}
{{% blocks/feature icon="fa-bolt" title="Zero Boilerplate" %}}
Automatic constructor parameter lookup (`gh<T>()`) eliminates manual graph assembly and error-prone locator lookups.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa-folder-tree" title="Folder Micro-Packages" %}}
Isolate feature directories into autonomous sub-modules with `@InjectableMicroPackage` and automatic boundary isolation.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa-boxes-stacked" title="Monorepo Ready" %}}
Seamlessly compose micro-packages across separate pub packages via `externalMicroPackages` in deterministic order.
{{% /blocks/feature %}}
{{< /blocks/section >}}

{{< blocks/section color="white" type="row" >}}
{{% blocks/feature icon="fa-shield-halved" title="Compile-Time Safe" %}}
Pure code generation through `build_runner` with zero runtime mirrors or reflection overhead.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa-sliders" title="Environment Gating" %}}
Easily gate mock, dev, staging, and production dependencies via `@Environment` and customizable `EnvironmentFilter`.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa-clock" title="Async & PreResolve" %}}
Native support for asynchronous singletons (`singletonAsync`) and synchronous bootstrap guarantees with `@PreResolve`.
{{% /blocks/feature %}}
{{< /blocks/section >}}
