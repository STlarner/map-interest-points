import "dart:convert";
import "package:get_it/get_it.dart";
import "package:http/http.dart" as http;

import "../logger/log_provider.dart";
import "network_manager.dart";

class CoreNetworkManager extends NetworkManager {
  /// GET request
  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
  }) async {
    GetIt.I<LogProvider>().log("GET request to $path", Severity.network);

    final requestHeaders = await _getHeaders(extra: headers);

    final uri = _buildUri(
      path,
      queryParams: queryParams,
      pathParams: pathParams,
    );
    final response = await http.get(uri, headers: requestHeaders);
    return _processResponse(response);
  }

  /// POST request
  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    GetIt.I<LogProvider>().log("POST request to $path", Severity.network);

    final uri = _buildUri(
      path,
      queryParams: queryParams,
      pathParams: pathParams,
    );

    final requestHeaders = await _getHeaders(extra: headers);

    final response = await http.post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isNotEmpty) {
        GetIt.I<LogProvider>().log(
          "Response from ${response.request!.url}:\n${response.body}",
          Severity.network,
        );
        return jsonDecode(response.body);
      }
      return null;
    } else {
      GetIt.I<LogProvider>().log(
        "Error [${response.statusCode}]: ${response.body}",
        Severity.network,
      );
      throw Exception("Error [${response.statusCode}]: ${response.body}");
    }
  }

  Future<Map<String, String>> _getHeaders({Map<String, String>? extra}) async {
    final headers = {
      "Content-Type": "application/json",
      "User-Agent": "ToDoTrips",
    };

    if (getAuthenticationToken != null) {
      final token = await getAuthenticationToken!();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  Uri _buildUri(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
  }) {
    pathParams?.forEach((key, value) {
      path = path.replaceAll("{$key}", value.toString());
    });

    final uri = Uri.parse("${overrideBaseUrl ?? baseUrl}$path");
    overrideBaseUrl = null;

    if (queryParams != null) {
      return uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams.map((k, v) => MapEntry(k, v.toString())),
        },
      );
    }
    return uri;
  }
}
