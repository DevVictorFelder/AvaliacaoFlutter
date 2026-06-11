import '../models/post.dart';
import '../services/posts_api_service.dart';
import '../services/posts_cache_service.dart';

abstract class PostsRepository {
  Future<List<Post>> getPosts({bool forceRefresh = false});

  Future<Post> addPost({
    required String title,
    required String body,
  });
}

class JsonPlaceholderPostsRepository implements PostsRepository {
  JsonPlaceholderPostsRepository({
    required PostsApiService apiService,
    required PostsCacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  final PostsApiService _apiService;
  final PostsCacheService _cacheService;

  List<Post> _memoryPosts = const [];

  @override
  Future<List<Post>> getPosts({bool forceRefresh = false}) async {
    if (_memoryPosts.isNotEmpty && !forceRefresh) {
      return _memoryPosts;
    }

    final cachedPosts = _cacheService.readPosts();
    if (cachedPosts.isNotEmpty && !forceRefresh) {
      _memoryPosts = cachedPosts;
      return cachedPosts;
    }

    try {
      final apiPosts = await _apiService.fetchPosts();
      _memoryPosts = apiPosts;
      await _cacheService.savePosts(apiPosts);
      return apiPosts;
    } catch (_) {
      if (cachedPosts.isNotEmpty) {
        _memoryPosts = cachedPosts;
        return cachedPosts;
      }
      rethrow;
    }
  }

  @override
  Future<Post> addPost({
    required String title,
    required String body,
  }) async {
    final created = await _apiService.createPost(title: title, body: body);
    final nextId = _nextLocalId();
    final post = created.copyWith(
      id: created.id == 0 ? nextId : created.id,
      isLocal: true,
    );

    _memoryPosts = [post, ..._memoryPosts];
    await _cacheService.savePosts(_memoryPosts);
    return post;
  }

  int _nextLocalId() {
    if (_memoryPosts.isEmpty) return 101;
    final highestId = _memoryPosts.map((post) => post.id).reduce(
          (current, next) => current > next ? current : next,
        );
    return highestId + 1;
  }
}
