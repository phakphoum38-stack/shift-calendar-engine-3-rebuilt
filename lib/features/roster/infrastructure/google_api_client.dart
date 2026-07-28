import 'package:http/http.dart' as http;

class GoogleApiClient extends http.BaseClient {
  GoogleApiClient(this.headers, [http.Client? inner])
    : inner = inner ?? http.Client();

  final Map<String, String> headers;
  final http.Client inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(headers);
    return inner.send(request);
  }

  @override
  void close() => inner.close();
}
