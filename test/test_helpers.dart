import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const sampleProjectJson = <String, dynamic>{
  'id': '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  'title': 'Personal Portfolio Website',
  'description': 'Built with Django.',
  'tech_stack': 'Django, Python, Git',
  'project_url': 'https://github.com/1drism/myportofolio',
  'project_image_url': '',
};

/// [ApiClient] whose requests are answered by [handler] instead of a server.
ApiClient fakeApiClient([MockClientHandler? handler]) => ApiClient(
  baseUrl: 'http://test.local',
  client: MockClient(
    handler ?? (_) async => http.Response(jsonEncode([sampleProjectJson]), 200),
  ),
);

/// The app wired to [fakeApiClient].
MyApp testApp([MockClientHandler? handler]) =>
    MyApp(apiClient: fakeApiClient(handler));
