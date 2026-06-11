import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/models/post.dart';
import 'post_form_validators.dart';
import 'post_form_view_model.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostFormViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo post')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cadastre uma publicacao',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'O envio usa POST e o item aparece no topo da listagem.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  validator: PostFormValidators.title,
                  maxLength: PostFormValidators.titleMaxLength,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      PostFormValidators.titleMaxLength,
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  validator: PostFormValidators.body,
                  maxLines: 6,
                  maxLength: PostFormValidators.bodyMaxLength,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      PostFormValidators.bodyMaxLength,
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Descricao',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                if (viewModel.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    viewModel.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: viewModel.isSubmitting ? null : _submit,
                  icon: viewModel.isSubmitting
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    viewModel.isSubmitting ? 'Enviando...' : 'Cadastrar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final viewModel = context.read<PostFormViewModel>();
    final post = await viewModel.submit(
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (!mounted || post == null) return;
    Navigator.of(context).pop<Post>(post);
  }
}
