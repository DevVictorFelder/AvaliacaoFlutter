import 'package:flutter_mvvm_posts/data/models/post.dart';
import 'package:flutter_mvvm_posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_posts/presentation/posts/posts_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('carrega posts e filtra por busca', () async {
    final viewModel = PostsViewModel(_FakePostsRepository());

    await viewModel.loadPosts();
    viewModel.setQuery('flutter');

    expect(viewModel.status, PostsStatus.ready);
    expect(viewModel.posts, hasLength(2));
    expect(viewModel.visiblePosts, hasLength(1));
    expect(viewModel.visiblePosts.first.title, contains('Flutter'));
  });

  test('adiciona novo post no topo', () async {
    final viewModel = PostsViewModel(_FakePostsRepository());
    await viewModel.loadPosts();

    const post = Post(id: 99, userId: 1, title: 'Novo', body: 'Criado');
    viewModel.prependPost(post);

    expect(viewModel.posts.first.id, 99);
    expect(viewModel.posts, hasLength(3));
  });
}

class _FakePostsRepository implements PostsRepository {
  @override
  Future<Post> addPost({
    required String title,
    required String body,
  }) async {
    return Post(id: 3, userId: 1, title: title, body: body, isLocal: true);
  }

  @override
  Future<List<Post>> getPosts({bool forceRefresh = false}) async {
    return const [
      Post(id: 1, userId: 1, title: 'Flutter MVVM', body: 'Arquitetura limpa'),
      Post(id: 2, userId: 1, title: 'API', body: 'Consumo HTTP'),
    ];
  }
}
