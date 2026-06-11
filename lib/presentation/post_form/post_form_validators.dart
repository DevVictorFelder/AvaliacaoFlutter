class PostFormValidators {
  const PostFormValidators._();

  static const int titleMaxLength = 80;
  static const int bodyMaxLength = 240;

  static String? title(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe um titulo.';
    if (text.length > titleMaxLength) {
      return 'Use no maximo $titleMaxLength caracteres.';
    }
    return null;
  }

  static String? body(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe uma descricao.';
    if (text.length > bodyMaxLength) {
      return 'Use no maximo $bodyMaxLength caracteres.';
    }
    return null;
  }
}
