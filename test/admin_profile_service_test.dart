import 'package:flutter_test/flutter_test.dart';
import 'package:musso_deme_app/services/admin_profile_service.dart';
import 'package:musso_deme_app/modeles/user_model.dart';

void main() {
  group('AdminProfileService', () {
    test('UserModel can be created with all fields', () {
      final user = UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        role: 'ADMIN',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      expect(user.id, 1);
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.role, 'ADMIN');
      expect(user.createdAt, isNotNull);
      expect(user.updatedAt, isNotNull);
    });
    
    test('UserModel toJson returns correct structure', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        role: 'ADMIN',
        createdAt: now,
        updatedAt: now,
      );
      
      final json = user.toJson();
      
      expect(json['id'], 1);
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['role'], 'ADMIN');
      expect(json['createdAt'], now.toIso8601String());
      expect(json['updatedAt'], now.toIso8601String());
    });
  });
}