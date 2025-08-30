class DownloadItem {
  final String id;
  final String url;
  final String platform;
  final String format;
  final DateTime timestamp;
  final String? fileName;
  final String status;

  DownloadItem({
    required this.id,
    required this.url,
    required this.platform,
    required this.format,
    required this.timestamp,
    this.fileName,
    this.status = 'completed',
  });

  factory DownloadItem.fromMap(Map<String, dynamic> map, String id) {
    return DownloadItem(
      id: id,
      url: map['url'] ?? '',
      platform: map['platform'] ?? '',
      format: map['format'] ?? '',
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      fileName: map['fileName'],
      status: map['status'] ?? 'completed',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'platform': platform,
      'format': format,
      'timestamp': timestamp,
      'fileName': fileName,
      'status': status,
    };
  }
}