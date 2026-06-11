import 'package:flutter/material.dart';

import '../../data/models/post.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.article_rounded,
                    color: colorScheme.onPrimary,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Post #${post.id}',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (post.isLocal)
                    Chip(
                      label: const Text('Novo'),
                      backgroundColor: colorScheme.tertiaryContainer,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.body,
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded),
                    const SizedBox(width: 12),
                    Text(
                      'Usuario ${post.userId}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
