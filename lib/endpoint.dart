import 'dart:core';

class Endpoint {
  // NOTE: not realistic! we'll configure environment-specific variables in a soon to be
  // upcoming lesson
  static const apiScheme = 'http';
  static const apiHost = 'app.cadencemspl.com';

  static const prefix = '/cadence-service';

  static Uri uri(String path, {Map<String, dynamic> queryParameters}) {
    final uri = new Uri(
      scheme: apiScheme,
      host: apiHost,
      path: '$prefix$path',
      queryParameters: queryParameters,
    );
    return uri;
  }
}
