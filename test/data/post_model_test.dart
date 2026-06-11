import 'package:flutter_mvvm_posts/data/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializa e desserializa post', () {
    const post = Post(
      id: 7,
      userId: 1,
      title: 'Titulo',
      body: 'Descricao',
      isLocal: true,
    );

    final json = post.toJson();
    final restored = Post.fromJson(json);

    expect(restored.id, 7);
    expect(restored.userId, 1);
    expect(restored.title, 'Titulo');
    expect(restored.body, 'Descricao');
    expect(restored.isLocal, true);
  });
}
