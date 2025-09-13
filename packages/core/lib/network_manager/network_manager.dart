abstract class NetworkManager {
  String? token;
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
}
