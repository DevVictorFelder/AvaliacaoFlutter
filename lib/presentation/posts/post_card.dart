import 'package:flutter/material.dart';

import '../../data/models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onTap,
    super.key,
  });

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${post.id}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (post.isLocal) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Criado nesta sessao',
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: colorScheme.tertiary,
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
