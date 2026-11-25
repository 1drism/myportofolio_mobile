import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  final json = <String, dynamic>{
    'id': '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
    'title': 'Portfolio',
    'description': 'My site',
    'tech_stack': 'Django, Flutter',
    'project_url': 'https://example.com',
    'project_image_url': 'https://example.com/img.png',
  };

  test('fromJson reads snake_case keys', () {
    final project = Project.fromJson(json);

    expect(project.id, json['id']);
    expect(project.techStack, 'Django, Flutter');
    expect(project.projectUrl, 'https://example.com');
    expect(project.projectImageUrl, 'https://example.com/img.png');
  });

  test('toJson uses snake_case keys and omits id', () {
    final out = Project.fromJson(json).toJson();

    expect(out.containsKey('id'), isFalse);
    expect(out['tech_stack'], 'Django, Flutter');
    expect(out['project_url'], 'https://example.com');
    expect(out['project_image_url'], 'https://example.com/img.png');
  });

  test('missing or null image URL becomes empty string', () {
    final missing = Map<String, dynamic>.of(json)..remove('project_image_url');
    final nulled = Map<String, dynamic>.of(json)..['project_image_url'] = null;

    expect(Project.fromJson(missing).projectImageUrl, '');
    expect(Project.fromJson(nulled).projectImageUrl, '');
  });
}
