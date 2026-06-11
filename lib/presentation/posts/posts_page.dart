import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/post.dart';
import '../post_detail/post_detail_page.dart';
import '../post_form/post_form_page.dart';
import '../shared/section_header.dart';
import 'post_card.dart';
import 'posts_view_model.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts MVVM'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () => context.read<PostsViewModel>().loadPosts(
                  forceRefresh: true,
                ),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo post'),
      ),
      body: SafeArea(
        child: Consumer<PostsViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.status == PostsStatus.loading &&
                viewModel.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.status == PostsStatus.failure) {
              return _FailureState(
                message: viewModel.errorMessage ?? 'Erro inesperado.',
                onRetry: viewModel.loadPosts,
              );
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.loadPosts(forceRefresh: true),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'Explore ideias em tempo real',
                            subtitle:
                                'Consumo de API, cadastro validado e cache local em uma experiencia MVVM.',
                          ),
                          const SizedBox(height: 18),
                          SearchBar(
                            controller: _searchController,
                            hintText: 'Buscar por titulo ou descricao',
                            leading: const Icon(Icons.search_rounded),
                            onChanged: viewModel.setQuery,
                            trailing: viewModel.query.isEmpty
                                ? null
                                : [
                                    IconButton(
                                      tooltip: 'Limpar busca',
                                      onPressed: () {
                                        _searchController.clear();
                                        viewModel.setQuery('');
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                    ),
                                  ],
                          ),
                          const SizedBox(height: 12),
                          _SummaryStrip(
                            total: viewModel.posts.length,
                            visible: viewModel.visiblePosts.length,
                          ),
                          const SizedBox(height: 12),
                          const _ApiNotice(),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.visiblePosts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index.isOdd) {
                              return const SizedBox(height: 10);
                            }

                            final post = viewModel.visiblePosts[index ~/ 2];
                            return PostCard(
                              post: post,
                              onTap: () => _openDetails(context, post),
                            );
                          },
                          childCount: viewModel.visiblePosts.length * 2 - 1,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context) async {
    final createdPost = await Navigator.of(context).push<Post>(
      MaterialPageRoute(builder: (_) => const PostFormPage()),
    );

    if (!context.mounted || createdPost == null) return;

    context.read<PostsViewModel>().prependPost(createdPost);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post cadastrado e adicionado a lista.')),
    );
  }

  void _openDetails(BuildContext context, Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailPage(post: post),
      ),
    );
  }
}

class _ApiNotice extends StatelessWidget {
  const _ApiNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.onSecondaryContainer,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dados simulados retornados pela API JSONPlaceholder.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.total,
    required this.visible,
  });

  final int total;
  final int visible;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 8,
        children: [
          _Metric(label: 'Total', value: '$total'),
          _Metric(label: 'Exibidos', value: '$visible'),
          const _Metric(label: 'Fonte', value: 'JSONPlaceholder'),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        style: textTheme.bodyMedium,
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            const Text('Nenhum post encontrado.'),
          ],
        ),
      ),
    );
  }
}
