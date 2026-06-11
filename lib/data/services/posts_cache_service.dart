import '../models/post.dart';

class PostsCacheService {
  List<Post> _posts = const [];

  Future<void> savePosts(List<Post> posts) async {
    _posts = List.unmodifiable(posts);
  }

  List<Post> readPosts() {
    return _posts;
  }
}
