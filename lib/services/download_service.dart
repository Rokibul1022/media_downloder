import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadService {
  static const String _backendUrl = 'http://10.0.2.2:3000';

  static Future<Map<String, dynamic>> getVideoInfo(String url) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );
      final response = await dio.post(
        '$_backendUrl/info',
        data: {'url': url},
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get info from server: Status ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to dummy info if server fails
      String title = _extractTitleFromUrl(url);
      String uploader = 'Unknown';
      int duration = 180;

      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        uploader = 'YouTube Creator';
      } else if (url.contains('tiktok.com')) {
        uploader = 'TikTok User';
        duration = 30;
      }

      return {
        'title': title,
        'uploader': uploader,
        'duration': duration,
      };
    }
  }

  static Future<String> downloadContent({
    required String url,
    required String format,
    required String platform,
    String? title,
    String? quality,
  }) async {
    // Request appropriate storage permission based on Android version
    PermissionStatus permissionStatus;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 30) {
        // Android 11+ (API 30+): Request manageExternalStorage
        permissionStatus = await Permission.manageExternalStorage.request();
      } else {
        // Android 10 or below: Request storage permission
        permissionStatus = await Permission.storage.request();
      }
    } else {
      // iOS: Request storage permission (usually not needed, but check for consistency)
      permissionStatus = await Permission.storage.request();
    }

    // Handle permission status
    if (!permissionStatus.isGranted) {
      if (permissionStatus.isPermanentlyDenied) {
        throw Exception(
            'Storage permission is permanently denied. Please enable it in app settings.');
      } else {
        throw Exception('Storage permission denied. Please grant permission to save files.');
      }
    }

    // Get Downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    // Create filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = format == 'video' ? 'mp4' : 'mp3';
    final safeTitle = (title ?? _extractTitleFromUrl(url))
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final filename = '${safeTitle}_$timestamp.$extension';
    final filePath = '${downloadsDir.path}/$filename';

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
    try {
      final response = await dio.post(
        '$_backendUrl/download',
        data: {
          'url': url,
          'format': format,
          'quality': quality,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final file = File(filePath);
        await file.writeAsBytes(response.data);
      } else {
        throw Exception('Server returned invalid response: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to download content from server. Ensure the server is running at $_backendUrl and accessible. Error: $e');
    }

    // Save to Firestore with file path
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('downloads')
          .add({
        'url': url,
        'platform': platform,
        'format': format,
        'timestamp': FieldValue.serverTimestamp(),
        'title': title ?? _extractTitleFromUrl(url),
        'filePath': filePath,
      });
    }

    return filePath;
  }

  static String _extractTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (url.contains('youtube.com/watch')) {
        final videoId = uri.queryParameters['v'];
        return videoId != null ? 'YouTube Video ($videoId)' : 'YouTube Video';
      } else if (url.contains('youtu.be/')) {
        final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
        return videoId != null ? 'YouTube Video ($videoId)' : 'YouTube Video';
      } else if (url.contains('tiktok.com')) {
        final pathParts = uri.pathSegments;
        if (pathParts.length >= 3 && pathParts[1] == 'video') {
          return 'TikTok Video (${pathParts[2]})';
        }
        return 'TikTok Video';
      } else if (url.contains('instagram.com')) {
        final pathParts = uri.pathSegments;
        if (pathParts.isNotEmpty) {
          final type = pathParts[0];
          if (type == 'p' || type == 'reel') {
            final id = pathParts.length > 1 ? pathParts[1] : null;
            return id != null
                ? 'Instagram ${type == 'reel' ? 'Reel' : 'Post'} ($id)'
                : 'Instagram Content';
          }
        }
        return 'Instagram Content';
      } else if (url.contains('facebook.com')) {
        return 'Facebook Video';
      } else if (url.contains('twitter.com') || url.contains('x.com')) {
        final pathParts = uri.pathSegments;
        if (pathParts.length >= 3 && pathParts[1] == 'status') {
          return 'Twitter/X Post (${pathParts[2]})';
        }
        return 'Twitter/X Post';
      }
      return 'Media Content';
    } catch (e) {
      return 'Media Content';
    }
  }
}