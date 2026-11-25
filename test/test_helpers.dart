import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

const testToken = 'test-token';

const sampleProjectJson = <String, dynamic>{
  'id': '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  'title': 'Personal Portfolio Website',
  'description': 'Built with Django.',
  'tech_stack': 'Django, Python, Git',
  'project_url': 'https://github.com/1drism/myportofolio',
  'project_image_url': '',
};

/// Stand-in for the Django API: token login/logout, project list and create.
Future<http.Response> fakeBackend(http.Request request) async {
  switch (request.url.path) {
    case '/api/v1/auth/token/':
      return http.Response(jsonEncode({'token': testToken}), 200);
    case '/api/v1/auth/logout/':
      return http.Response('', 204);
    case '/api/v1/projects/' when request.method == 'POST':
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({...body, 'id': 'new-id'}), 201);
    default:
      return http.Response(jsonEncode([sampleProjectJson]), 200);
  }
}

/// [ApiClient] whose requests are answered by [handler] instead of a server.
ApiClient fakeApiClient([MockClientHandler handler = fakeBackend]) =>
    ApiClient(baseUrl: 'http://test.local', client: MockClient(handler));

/// The app wired to [fakeApiClient].
MyApp testApp([MockClientHandler handler = fakeBackend]) =>
    MyApp(apiClient: fakeApiClient(handler));

/// Logs in through the app's [AuthState] without opening the login screen.
Future<void> logIn(WidgetTester tester) async {
  await tester
      .element(find.byType(MyHomePage))
      .read<AuthState>()
      .login('user', 'pass');
  await tester.pump();
}
