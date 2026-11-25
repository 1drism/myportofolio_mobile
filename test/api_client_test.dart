import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _baseUrl = 'http://test.local';

const _projectJson = {
  'id': '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
  'title': 'Portfolio',
  'description': 'My site',
  'tech_stack': 'Django, Flutter',
  'project_url': 'https://example.com',
  'project_image_url': '',
};

void main() {
  test('getProjects parses the project list', () async {
    final client = ApiClient(
      baseUrl: _baseUrl,
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), '$_baseUrl/api/v1/projects/');
        return http.Response(jsonEncode([_projectJson]), 200);
      }),
    );

    final projects = await client.getProjects();

    expect(projects, hasLength(1));
    expect(projects.first.title, 'Portfolio');
  });

  test('non-2xx response throws ApiException with the status code', () async {
    final client = ApiClient(
      baseUrl: _baseUrl,
      client: MockClient((_) async => http.Response('Server error', 500)),
    );

    expect(
      client.getProjects(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 500)),
    );
  });

  test('createProject sends the token header and JSON body', () async {
    late http.Request sent;
    final client = ApiClient(
      baseUrl: _baseUrl,
      client: MockClient((request) async {
        sent = request;
        return http.Response(jsonEncode(_projectJson), 201);
      }),
    );

    final created = await client.createProject(
      const Project(
        title: 'Portfolio',
        description: 'My site',
        techStack: 'Django, Flutter',
        projectUrl: 'https://example.com',
      ),
      token: 'abc123',
    );

    expect(sent.method, 'POST');
    expect(sent.headers['Authorization'], 'Token abc123');
    final body = jsonDecode(sent.body) as Map<String, dynamic>;
    expect(body['tech_stack'], 'Django, Flutter');
    expect(body.containsKey('id'), isFalse);
    expect(created.id, _projectJson['id']);
  });

  test('obtainToken returns the token and logout sends it', () async {
    final client = ApiClient(
      baseUrl: _baseUrl,
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'abc123'}), 200);
        }
        expect(request.url.path, '/api/v1/auth/logout/');
        expect(request.headers['Authorization'], 'Token abc123');
        return http.Response('', 204);
      }),
    );

    final token = await client.obtainToken('user', 'pass');
    expect(token, 'abc123');
    await client.logout(token: token);
  });
}
