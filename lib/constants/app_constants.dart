import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Social Media Downloader';
  static const String appVersion = '1.0.0';
  
  // Supported platforms
  static const List<Map<String, dynamic>> supportedPlatforms = [
    {'name': 'YouTube', 'icon': Icons.play_circle_fill, 'color': Color(0xFFFF0000)},
    {'name': 'Facebook', 'icon': Icons.facebook, 'color': Color(0xFF1877F2)},
    {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Color(0xFFE4405F)},
    {'name': 'Twitter/X', 'icon': Icons.alternate_email, 'color': Color(0xFF1DA1F2)},
    {'name': 'TikTok', 'icon': Icons.music_note, 'color': Color(0xFF000000)},
    {'name': 'LinkedIn', 'icon': Icons.business, 'color': Color(0xFF0A66C2)},
    {'name': 'Telegram', 'icon': Icons.send, 'color': Color(0xFF0088CC)},
    {'name': 'WhatsApp', 'icon': Icons.chat, 'color': Color(0xFF25D366)},
  ];
  
  // Download formats
  static const List<String> downloadFormats = ['video', 'audio'];
  
  // File extensions
  static const Map<String, String> fileExtensions = {
    'video': 'mp4',
    'audio': 'mp3',
  };
}