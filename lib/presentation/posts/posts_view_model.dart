import 'package:flutter/foundation.dart';

import '../../data/models/post.dart';
import '../../data/repositories/posts_repository.dart';

enum PostsStatus { idle, loading, ready, empty, failure }

class PostsViewModel extends ChangeNotifier {
  PostsViewModel(this._repository);

  final PostsRepository _repository;

  PostsStatus _status = PostsStatus.idle;
  List<Post> _posts = const [];
  String _query = '';
  String? _errorMessage;

  PostsStatus get status => _status;
  List<Post> get posts => _posts;
  String get query => _query;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == PostsStatus.loading;

  List<Post> get visiblePosts {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _posts;

    return _posts.where((post) {
      return post.title.toLowerCase().contains(normalizedQuery) ||
          post.body.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  Future<void> loadPosts({bool forceRefresh = false}) async {
    _status = PostsStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _repository.getPosts(forceRefresh: forceRefresh);
      _status = _posts.isEmpty ? PostsStatus.empty : PostsStatus.ready;
    } catch (_) {
      _status = PostsStatus.failure;
      _errorMessage = 'Nao foi possivel carregar os posts.';
    } finally {
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void prependPost(Post post) {
    _posts = [post, ..._posts.where((item) => item.id != post.id)];
    _status = PostsStatus.ready;
    notifyListeners();
  }
}
