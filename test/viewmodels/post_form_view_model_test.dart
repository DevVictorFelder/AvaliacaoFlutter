import 'package:flutter_mvvm_posts/data/models/post.dart';
import 'package:flutter_mvvm_posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_posts/presentation/post_form/post_form_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('envia formulario e retorna post criado', () async {
    final viewModel = PostFormViewModel(_FakePostsRepository());

    final post = await viewModel.submit(
      title: '  Titulo  ',
      body: '  Descricao  ',
    );

    expect(viewModel.isSubmitting, false);
    expect(viewModel.errorMessage, isNull);
    expect(post?.title, 'Titulo');
    expect(post?.body, 'Descricao');
  });
}

class _FakePostsRepository implements PostsRepository {
  @override
  Future<Post> addPost({
    required String title,
    required String body,
  }) async {
    return Post(id: 1, userId: 1, title: title, body: body, isLocal: true);
  }

  @override
  Future<List<Post>> getPosts({bool forceRefresh = false}) async => const [];
}
