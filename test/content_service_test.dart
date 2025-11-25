import 'package:flutter_test/flutter_test.dart';
import 'package:musso_deme_app/services/content_service.dart';
import 'package:musso_deme_app/modeles/content_model.dart';

void main() {
  group('ContentService', () {
    final String mockToken = 'mock_token';
    
    test('ContentModel can be created with all fields', () {
      final content = ContentModel(
        id: 1,
        titre: 'Test Content',
        langue: 'French',
        description: 'Test description',
        urlContenu: 'https://example.com/content.mp4',
        duree: '30',
        adminId: 1,
        categorieId: 1,
        type: 'VIDEO',
        createdAt: DateTime.now(),
      );
      
      expect(content.id, 1);
      expect(content.titre, 'Test Content');
      expect(content.langue, 'French');
      expect(content.description, 'Test description');
      expect(content.urlContenu, 'https://example.com/content.mp4');
      expect(content.duree, '30');
      expect(content.adminId, 1);
      expect(content.categorieId, 1);
      expect(content.type, 'VIDEO');
      expect(content.createdAt, isNotNull);
    });
    
    test('ContentModel toJsonForApi returns correct structure', () {
      final content = ContentModel(
        id: 1,
        titre: 'Test Content',
        langue: 'French',
        description: 'Test description',
        urlContenu: 'https://example.com/content.mp4',
        duree: '30',
        adminId: 1,
        categorieId: 1,
      );
      
      final json = content.toJsonForApi();
      
      // Should not include id or server-generated fields
      expect(json.containsKey('id'), false);
      expect(json.containsKey('type'), false);
      expect(json.containsKey('createdAt'), false);
      
      // Should include all required fields for API
      expect(json['titre'], 'Test Content');
      expect(json['langue'], 'French');
      expect(json['description'], 'Test description');
      expect(json['urlContenu'], 'https://example.com/content.mp4');
      expect(json['duree'], '30');
      expect(json['adminId'], 1);
      expect(json['categorieId'], 1);
    });
  });
}