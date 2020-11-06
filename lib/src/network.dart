import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Returns an http client that ignores unsafe SSL certificates.
http.BaseClient newSelfSignedHttpClient() {
  final trustSelfSigned = true;
  final httpClient = io.HttpClient()
    ..badCertificateCallback =
      ((io.X509Certificate cert, String host, int port) => trustSelfSigned);
  return IOClient(httpClient);
}
