import 'package:flutter_mvvm_posts/data/services/posts_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('fetchPosts converte resposta da API em lista de posts', () async {
    final service = PostsApiService(
      MockClient((request) async {
        expect(request.method, 'GET');
        return http.Response(
          '[{"userId":1,"id":1,"title":"Titulo","body":"Descricao"}]',
          200,
        );
      }),
    );

    final posts = await service.fetchPosts();

    expect(posts, hasLength(1));
    expect(posts.first.title, 'Titulo');
    expect(posts.first.body, 'Descricao');
  });

  test('createPost envia JSON e retorna post criado', () async {
    final service = PostsApiService(
      MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.headers['Content-Type'], contains('application/json'));
        expect(request.body, contains('Titulo'));

        return http.Response(
          '{"userId":1,"id":101,"title":"Titulo","body":"Descricao"}',
          201,
        );
      }),
    );

    final post = await service.createPost(
      title: 'Titulo',
      body: 'Descricao',
    );

    expect(post.id, 101);
    expect(post.title, 'Titulo');
  });
}
