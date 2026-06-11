import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/posts_repository.dart';
import 'data/services/posts_api_service.dart';
import 'data/services/posts_cache_service.dart';
import 'presentation/post_form/post_form_view_model.dart';
import 'presentation/posts/posts_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = JsonPlaceholderPostsRepository(
    apiService: PostsApiService(http.Client()),
    cacheService: PostsCacheService(),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<PostsRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => PostsViewModel(repository)..loadPosts(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostFormViewModel(repository),
        ),
      ],
      child: const PostsApp(),
    ),
  );
}
