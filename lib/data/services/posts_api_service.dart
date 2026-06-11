import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostsApiException implements Exception {
  const PostsApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PostsApiService {
  PostsApiService(this._client);

  static final Uri _postsUri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  final http.Client _client;

  Future<List<Post>> fetchPosts() async {
    final response = await _client.get(_postsUri);

    if (response.statusCode != 200) {
      throw const PostsApiException('Nao foi possivel carregar os posts.');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Post> createPost({
    required String title,
    required String body,
  }) async {
    final response = await _client.post(
      _postsUri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode != 201) {
      throw const PostsApiException('Nao foi possivel cadastrar o post.');
    }

    return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
