import 'package:flutter_test/flutter_test.dart';
import 'package:musso_deme_app/services/institution_service.dart';
import 'package:musso_deme_app/modeles/institution_model.dart';

void main() {
  group('InstitutionService', () {
    test('InstitutionModel can be created with all fields', () {
      final institution = InstitutionModel(
        id: 1,
        nom: 'Test Institution',
        numeroTel: '+223 12 34 56 78',
        description: 'Test description',
        logoUrl: 'https://example.com/logo.png',
        createdAt: DateTime.now(),
      );
      
      expect(institution.id, 1);
      expect(institution.nom, 'Test Institution');
      expect(institution.numeroTel, '+223 12 34 56 78');
      expect(institution.description, 'Test description');
      expect(institution.logoUrl, 'https://example.com/logo.png');
      expect(institution.createdAt, isNotNull);
    });
    
    test('InstitutionModel toJsonForApi returns correct structure', () {
      final institution = InstitutionModel(
        id: 1,
        nom: 'Test Institution',
        numeroTel: '+223 12 34 56 78',
        description: 'Test description',
        logoUrl: 'https://example.com/logo.png',
      );
      
      final json = institution.toJsonForApi();
      
      // Should not include id or server-generated fields
      expect(json.containsKey('id'), false);
      expect(json.containsKey('createdAt'), false);
      
      // Should include all required fields for API
      expect(json['nom'], 'Test Institution');
      expect(json['numeroTel'], '+223 12 34 56 78');
      expect(json['description'], 'Test description');
      expect(json['logoUrl'], 'https://example.com/logo.png');
    });
  });
}