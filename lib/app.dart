import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/posts/posts_page.dart';

class PostsApp extends StatelessWidget {
  const PostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts MVVM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PostsPage(),
    );
  }
}
