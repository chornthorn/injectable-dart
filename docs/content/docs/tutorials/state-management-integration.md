---
title: "Flutter State Management Integration"
linkTitle: "State Management Integration"
weight: 3
description: >
  Best practices for integrating Injectify with flutter_bloc, Cubits, dynamic runtime @FactoryParam parameters, and Flutter widget trees.
---

This tutorial demonstrates how to integrate Injectify with Flutter state management libraries such as `flutter_bloc`, manage dynamic constructor arguments with `@FactoryParam()`, and provide blocs within the widget tree cleanly.

---

## 1. Project Dependencies

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  get_it: ^8.0.3
  injectify:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify

dev_dependencies:
  build_runner: ^2.4.15
  injectify_generator:
    git:
      url: https://github.com/chornthorn/injectify-dart.git
      path: packages/injectify_generator
```

---

## 2. Defining Repositories and Global Services

Create `lib/repositories/product_repository.dart`:

```dart
import 'package:injectify/injectify.dart';

class Product {
  final String id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});
}

@Injectable(scope: Scope.lazySingleton)
class ProductRepository {
  final List<Product> _items = [
    const Product(id: 'p1', title: 'Wireless Headphones', price: 99.99),
    const Product(id: 'p2', title: 'Mechanical Keyboard', price: 149.99),
    const Product(id: 'p3', title: 'Ergonomic Mouse', price: 59.99),
  ];

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_items);
  }

  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _items.firstWhere((p) => p.id == id);
  }
}
```

---

## 3. Creating Feature Cubits

State management classes like BLoCs and Cubits should generally use `Scope.factory` so each widget or page gets a fresh, isolated state instance.

### Global / Parameterless Cubit (`CatalogCubit`)

```dart
// lib/features/catalog/catalog_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectify/injectify.dart';
import '../../repositories/product_repository.dart';

abstract class CatalogState {}
class CatalogInitial extends CatalogState {}
class CatalogLoading extends CatalogState {}
class CatalogLoaded extends CatalogState {
  final List<Product> products;
  CatalogLoaded(this.products);
}

@Injectable(scope: Scope.factory)
class CatalogCubit extends Cubit<CatalogState> {
  final ProductRepository _repository;

  CatalogCubit(this._repository) : super(CatalogInitial());

  Future<void> loadCatalog() async {
    emit(CatalogLoading());
    final items = await _repository.getProducts();
    emit(CatalogLoaded(items));
  }
}
```

### Parameterized Cubit with `@FactoryParam` (`ProductDetailCubit`)

When a screen requires a runtime parameter (such as a selected item ID or route argument), use `@FactoryParam()`:

```dart
// lib/features/product_detail/product_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectify/injectify.dart';
import '../../repositories/product_repository.dart';

abstract class ProductDetailState {}
class ProductDetailLoading extends ProductDetailState {}
class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  ProductDetailLoaded(this.product);
}

@Injectable(scope: Scope.factory)
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository _repository;
  final String productId;

  ProductDetailCubit(
    this._repository, {
    @FactoryParam() required this.productId,
  }) : super(ProductDetailLoading());

  Future<void> loadDetails() async {
    final item = await _repository.getProductById(productId);
    if (item != null) {
      emit(ProductDetailLoaded(item));
    }
  }
}
```

---

## 4. Providing Cubits in Flutter UI

In `lib/features/catalog/catalog_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection.dart';
import 'catalog_cubit.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CatalogCubit>()..loadCatalog(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Store Catalog')),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state is CatalogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CatalogLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### Passing Dynamic Parameter to Details Page

```dart
class ProductDetailPage extends StatelessWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Pass the productId at lookup time via param1:
      create: (context) => getIt<ProductDetailCubit>(param1: productId)..loadDetails(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoaded) {
              return Center(child: Text(state.product.title));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
```
