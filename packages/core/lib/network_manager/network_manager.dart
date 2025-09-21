abstract class NetworkManager {
  Future<String?> Function()? getAuthenticationToken;
  String? overrideBaseUrl; // ovveride base url for a single request
  late final String baseUrl;

  /// GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
  });

  /// POST request
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
    dynamic body,
  });

  /// PUT request
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
    dynamic body,
  });

  /// PATCH request
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
    dynamic body,
  });

  /// DELETE request
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
  });
}
