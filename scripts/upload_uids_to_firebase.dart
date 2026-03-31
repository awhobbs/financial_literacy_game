/// One-time script to upload UIDs from CSV files to Firebase Firestore
///
/// Usage:
///   dart run scripts/upload_uids_to_firebase.dart
///
/// Prerequisites:
///   1. Firebase Admin SDK credentials (service account JSON)
///   2. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
///
/// Note: This script uses the firebase_admin package which requires
/// server-side credentials. Run this from a secure environment.

import 'dart:io';
import 'dart:convert';

// For client-side Firebase (if running from Flutter context)
// This is a simplified version that outputs JSON for manual import
// or can be adapted to use firebase_admin for server-side execution.

void main() async {
  print('=== UID Upload Script ===\n');

  final uidsDir = Directory('uids');
  if (!await uidsDir.exists()) {
    print('Error: uids/ directory not found');
    print('Run this script from the project root directory');
    exit(1);
  }

  final allUIDs = <Map<String, dynamic>>[];
  final regionUIDs = <String, List<Map<String, dynamic>>>{};

  // Process all CSV files
  await for (final file in uidsDir.list()) {
    if (file is File && file.path.endsWith('.csv')) {
      print('Processing: ${file.path}');
      final entries = await _parseCSV(file);
      allUIDs.addAll(entries);

      // Group by region
      for (final entry in entries) {
        final region = entry['region'] as String? ?? 'Unknown';
        regionUIDs.putIfAbsent(region, () => []);
        regionUIDs[region]!.add(entry);
      }
    }
  }

  print('\n=== Summary ===');
  print('Total UIDs: ${allUIDs.length}');
  print('Regions:');
  for (final region in regionUIDs.keys) {
    print('  $region: ${regionUIDs[region]!.length} UIDs');
  }

  // Generate Firestore-ready JSON for each region
  print('\n=== Generating Firestore Import Files ===');

  final outputDir = Directory('scripts/output');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Create region-based documents for uidLists collection
  for (final region in regionUIDs.keys) {
    final regionCode = _getRegionCode(region);
    final doc = {
      'region': region,
      'regionCode': regionCode,
      'uids': regionUIDs[region]!.map((e) => {
        'uid': e['uid'],
        'firstName': e['firstName'] ?? '',
        'lastName': e['lastName'] ?? '',
        'enumerator': e['enumerator'] ?? '',
      }).toList(),
      'count': regionUIDs[region]!.length,
      'uploadedAt': DateTime.now().toIso8601String(),
    };

    final outputFile = File('scripts/output/uidLists_$regionCode.json');
    await outputFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(doc),
    );
    print('Created: ${outputFile.path}');
  }

  // Create a combined file for all UIDs
  final allDoc = {
    'allUIDs': allUIDs.map((e) => {
      'uid': e['uid'],
      'firstName': e['firstName'] ?? '',
      'lastName': e['lastName'] ?? '',
      'region': e['region'] ?? '',
      'enumerator': e['enumerator'] ?? '',
    }).toList(),
    'totalCount': allUIDs.length,
    'uploadedAt': DateTime.now().toIso8601String(),
  };

  final allFile = File('scripts/output/all_uids.json');
  await allFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(allDoc),
  );
  print('Created: ${allFile.path}');

  print('\n=== Instructions ===');
  print('To upload to Firestore:');
  print('1. Go to Firebase Console > Firestore Database');
  print('2. Create collection "uidLists"');
  print('3. For each region file (uidLists_*.json):');
  print('   - Add document with ID matching region code (e.g., "UGPC")');
  print('   - Import the JSON data');
  print('\nOr use Firebase Admin SDK to upload programmatically.');

  print('\n=== Firestore CLI Upload (Alternative) ===');
  print('If you have firebase-tools installed:');
  print('  firebase firestore:import scripts/output/');
}

Future<List<Map<String, dynamic>>> _parseCSV(File file) async {
  final entries = <Map<String, dynamic>>[];
  final lines = await file.readAsLines();

  if (lines.isEmpty) return entries;

  // Parse header
  final headers = lines[0].split(',').map((h) => h.trim().toLowerCase()).toList();

  // Find column indices
  final uidIdx = headers.indexOf('uid');
  final firstNameIdx = headers.indexWhere((h) => h.contains('first'));
  final lastNameIdx = headers.indexWhere((h) => h.contains('last'));
  final enumeratorIdx = headers.indexWhere((h) => h.contains('enumerator'));
  final regionIdx = headers.indexOf('region');

  // Parse data rows
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    final parts = line.split(',');
    if (parts.isEmpty) continue;

    final uid = uidIdx >= 0 && uidIdx < parts.length
        ? parts[uidIdx].trim()
        : '';

    if (uid.isEmpty) continue;

    entries.add({
      'uid': uid,
      'firstName': firstNameIdx >= 0 && firstNameIdx < parts.length
          ? parts[firstNameIdx].trim()
          : '',
      'lastName': lastNameIdx >= 0 && lastNameIdx < parts.length
          ? parts[lastNameIdx].trim()
          : '',
      'enumerator': enumeratorIdx >= 0 && enumeratorIdx < parts.length
          ? parts[enumeratorIdx].trim()
          : '',
      'region': regionIdx >= 0 && regionIdx < parts.length
          ? parts[regionIdx].trim()
          : '',
    });
  }

  return entries;
}

String _getRegionCode(String region) {
  switch (region.toLowerCase()) {
    case 'central':
      return 'UGPC';
    case 'northern':
      return 'UGPN';
    case 'eastern':
      return 'UGPE';
    case 'western':
      return 'UGPW';
    default:
      return region.toUpperCase().replaceAll(' ', '_');
  }
}
