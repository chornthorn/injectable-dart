import 'package:injectable/injectable.dart';

/// Contract for the HTTP API client.
abstract class ApiService {
  Future<String> fetchData();
}

/// Development/test implementation backed by canned responses.
@Injectable(as: ApiService, env: [Environment.dev, Environment.test])
class MockApiService implements ApiService {
  @override
  Future<String> fetchData() async => 'mock data (offline)';
}

/// Production implementation backed by the real backend.
@Injectable(as: ApiService, env: [Environment.prod])
class RealApiService implements ApiService {
  @override
  Future<String> fetchData() async => 'live data (api.example.com)';
}
