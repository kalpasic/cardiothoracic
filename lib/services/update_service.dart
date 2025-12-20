import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'supabase_service.dart';

class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  // Check for updates
  Future<Map<String, dynamic>?> checkForUpdates() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Fetch latest version info from Supabase
      final response = await supabase
          .from('app_updates')
          .select()
          .eq('platform', Platform.isAndroid ? 'android' : 'ios')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle(); // Use maybeSingle to avoid error if no row found

      if (response == null) return null;

      // Compare versions
      if (_isNewerVersion(response['version'], currentVersion)) {
        return response;
      }
      return null;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return null;
    }
  }

  // Compare version strings (e.g., "1.0.1" > "1.0.0")
  bool _isNewerVersion(String latest, String current) {
    List<int> latestParts = latest.split('.').map((i) => int.tryParse(i) ?? 0).toList();
    List<int> currentParts = current.split('.').map((i) => int.tryParse(i) ?? 0).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  // Download update from Google Drive
  Future<File?> downloadUpdate(String fileId, String fileName) async {
    try {
      // Get temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/$fileName';
      File file = File(filePath);

      // If file already exists, return it
      if (await file.exists()) {
        return file;
      }

      // Download file from Google Drive
      final url = 'https://drive.google.com/uc?export=download&id=$fileId';
      final request = http.Request('GET', Uri.parse(url));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        debugPrint('Failed to download update: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading update: $e');
      return null;
    }
  }

  // Install the downloaded update
  Future<void> installUpdate(File updateFile) async {
    try {
      // Open the downloaded file (for Android, this will prompt the user to install)
      final result = await OpenFile.open(updateFile.path);
      debugPrint('Result: ${result.type} ${result.message}');
    } catch (e) {
      debugPrint('Error installing update: $e');
    }
  }

  // Open update page in Google Drive (fallback)
  Future<void> openUpdatePage(String fileId) async {
    try {
      final url = 'https://drive.google.com/file/d/$fileId/view';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error opening update page: $e');
    }
  }
}