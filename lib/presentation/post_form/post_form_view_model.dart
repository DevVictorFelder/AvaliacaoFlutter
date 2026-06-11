import 'package:flutter/foundation.dart';

import '../../data/models/post.dart';
import '../../data/repositories/posts_repository.dart';

class PostFormViewModel extends ChangeNotifier {
  PostFormViewModel(this._repository);

  final PostsRepository _repository;

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<Post?> submit({
    required String title,
    required String body,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await _repository.addPost(
        title: title.trim(),
        body: body.trim(),
      );
    } catch (_) {
      _errorMessage = 'Nao foi possivel cadastrar agora. Tente novamente.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
