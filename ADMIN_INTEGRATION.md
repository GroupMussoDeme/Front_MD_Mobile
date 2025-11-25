# Admin API Integration for Musso Deme App

This document describes the integration of the admin API endpoints in the Musso Deme Flutter app.

## Services Created/Enhanced

### 1. ContentService (`lib/services/content_service.dart`)

Supports all admin endpoints for content management:

- `createContent(token, content)` - Create new content
- `getContentById(token, id)` - Get content by ID
- `getAllContents(token)` - Get all contents
- `updateContent(token, content)` - Update existing content
- `deleteContent(token, id)` - Delete content
- `getContentsByType(token, type)` - Get contents by type (AUDIOS, VIDEOS, etc.)
- `getContentsSortedByDate(token, order)` - Get contents sorted by date (asc/desc)
- `getContentsWithDuration(token)` - Get contents with duration

### 2. InstitutionService (`lib/services/institution_service.dart`)

Supports all admin endpoints for institution management:

- `createInstitution(token, institution)` - Create new institution
- `getInstitutionById(token, id)` - Get institution by ID
- `getAllInstitutions(token)` - Get all institutions
- `updateInstitution(token, institution)` - Update existing institution
- `deleteInstitution(token, id)` - Delete institution

### 3. AdminProfileService (`lib/services/admin_profile_service.dart`)

Supports all admin profile management endpoints:

- `getAdminProfileById(token, id)` - Get admin profile by ID
- `getAdminProfileByEmail(token, email)` - Get admin profile by email
- `updateAdminProfile(token, id, updates)` - Update admin profile
- `deactivateAdminAccount(token, id)` - Deactivate admin account
- `activateAdminAccount(token, id)` - Activate admin account
- `deleteAdminAccount(token, id)` - Delete admin account permanently

## Models Updated

### ContentModel (`lib/modeles/content_model.dart`)

Enhanced with additional fields and methods:

- Added `type` and `createdAt` fields
- Added `title` and `duration` getter methods
- Added `toJsonForApi()` method for API requests

### InstitutionModel (`lib/modeles/institution_model.dart`)

Enhanced with additional fields:

- Added `createdAt` field
- Added `toJsonForApi()` method for API requests

### UserModel (`lib/modeles/user_model.dart`)

Used for admin profile management.

## Example Usage

### Admin Dashboard Page

An example page (`lib/pages/AdminDashboardPage.dart`) demonstrates how to use these services:

- Displays lists of contents and institutions
- Allows creating new contents and institutions
- Allows deleting existing contents and institutions
- Includes refresh functionality

To navigate to this page:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AdminDashboardPage(authToken: 'YOUR_AUTH_TOKEN'),
  ),
);
```

## Running Tests

Tests have been created for all services:

```bash
# Run content service tests
flutter test test/content_service_test.dart

# Run institution service tests
flutter test test/institution_service_test.dart

# Run admin profile service tests
flutter test test/admin_profile_service_test.dart
```

## API Endpoints

All services use the base URL: `http://localhost:8080/api`

Authentication is handled through JWT tokens passed in the `Authorization: Bearer {token}` header.