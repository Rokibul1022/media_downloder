import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HistoryScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade400, Colors.cyan.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, size: 32, color: Colors.teal.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Download History',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              'Your downloaded content',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.orange.shade50,
                        child: IconButton(
                          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.orange.shade700),
                          onPressed: toggleTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: user == null
                        ? Center(
                            child: Card(
                              color: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.login, size: 64, color: Colors.red.shade400),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Please login to view download history',
                                      style: TextStyle(color: Colors.red.shade700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('downloads')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Card(
                                    color: Colors.grey.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.download_rounded, size: 64, color: Colors.grey.shade400),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No downloads yet',
                                            style: TextStyle(color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data = doc.data() as Map<String, dynamic>;
                                  final timestamp = data['timestamp'] as Timestamp?;

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            (data['format'] == 'video' ? Colors.blue : Colors.green).shade50,
                                            Colors.white,
                                          ],
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: (data['format'] == 'video' ? Colors.blue : Colors.green).shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            data['format'] == 'video' ? Icons.video_file_rounded : Icons.audio_file_rounded,
                                            color: data['format'] == 'video' ? Colors.blue.shade600 : Colors.green.shade600,
                                          ),
                                        ),
                                        title: Text(
                                          data['title'] ?? _extractTitleFromUrl(data['url'] ?? ''),
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple.shade100,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    data['platform'] ?? 'Unknown',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.purple.shade700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: (data['format'] == 'video' ? Colors.blue : Colors.green).shade100,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    data['format']?.toUpperCase() ?? '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: data['format'] == 'video' ? Colors.blue.shade700 : Colors.green.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              data['url'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                            ),
                                            if (timestamp != null)
                                              Text(
                                                'Downloaded: ${_formatDate(timestamp.toDate())}',
                                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                              ),
                                          ],
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: (data['format'] == 'video' ? Colors.blue : Colors.green).shade50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            data['format'] == 'video' ? Icons.video_file_rounded : Icons.audio_file_rounded,
                                            color: data['format'] == 'video' ? Colors.blue.shade600 : Colors.green.shade600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
  
  String _extractTitleFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      if (url.contains('youtube.com/watch')) {
        final videoId = uri.queryParameters['v'];
        return videoId != null ? 'YouTube Video ($videoId)' : 'YouTube Video';
      } else if (url.contains('youtu.be/')) {
        final videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
        return videoId != null ? 'YouTube Video ($videoId)' : 'YouTube Video';
      } else if (url.contains('tiktok.com')) {
        return 'TikTok Video';
      } else if (url.contains('instagram.com')) {
        return 'Instagram Content';
      } else if (url.contains('facebook.com')) {
        return 'Facebook Video';
      } else if (url.contains('twitter.com') || url.contains('x.com')) {
        return 'Twitter/X Post';
      }
      
      return 'Media Content';
    } catch (e) {
      return 'Media Content';
    }
  }
}