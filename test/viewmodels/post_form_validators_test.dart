import 'package:flutter_mvvm_posts/presentation/post_form/post_form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostFormValidators', () {
    test('valida titulo obrigatorio', () {
      expect(PostFormValidators.title(''), isNotNull);
      expect(PostFormValidators.title('Um titulo'), isNull);
    });

    test('valida descricao obrigatoria', () {
      expect(PostFormValidators.body(''), isNotNull);
      expect(PostFormValidators.body('Uma descricao'), isNull);
    });

    test('valida tamanho maximo', () {
      final longTitle = 'a' * (PostFormValidators.titleMaxLength + 1);
      final longBody = 'a' * (PostFormValidators.bodyMaxLength + 1);

      expect(PostFormValidators.title(longTitle), isNotNull);
      expect(PostFormValidators.body(longBody), isNotNull);
    });
  });
}
