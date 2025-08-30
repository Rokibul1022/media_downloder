import 'package:flutter/material.dart';
import '../widgets/platform_card.dart';
import '../constants/app_constants.dart';

class PlatformGridScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const PlatformGridScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade400, Colors.purple.shade300],
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
                      Icon(Icons.download_rounded, size: 32, color: Colors.indigo.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Platform',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              'Choose your social media platform',
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
                      const SizedBox(width: 8),
                      Card(
                        color: Colors.green.shade50,
                        child: IconButton(
                          icon: Icon(Icons.history, color: Colors.green.shade700),
                          onPressed: () => Navigator.pushNamed(context, '/history'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: AppConstants.supportedPlatforms.length,
                        itemBuilder: (context, index) {
                          final platform = AppConstants.supportedPlatforms[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: PlatformCard(
                              name: platform['name'],
                              icon: platform['icon'],
                              color: platform['color'],
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/download',
                                arguments: platform['name'],
                              ),
                            ),
                          );
                        },
                      ),
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
}