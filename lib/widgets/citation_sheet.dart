import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/paper.dart';

class CitationSheet extends StatelessWidget {
  final Paper paper;

  const CitationSheet({super.key, required this.paper});

  String get _apaCitation {
    final authors = paper.authors.join(', ');
    return '$authors. (${paper.publishedYear}). ${paper.title}. arXiv. ${paper.pdfUrl}';
  }

  String get _mlaCitation {
    final authors = paper.authors.join(', ');
    return '$authors. "${paper.title}." arXiv, ${paper.publishedYear}, ${paper.pdfUrl}.';
  }

  String get _chicagoCitation {
    final authors = paper.authors.join(', ');
    return '$authors. "${paper.title}." arXiv (${paper.publishedYear}). ${paper.pdfUrl}.';
  }

  void _copyToClipboard(BuildContext context, String text, String format) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$format citation copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generate Citation',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCitationItem(context, 'APA', _apaCitation),
          const SizedBox(height: 16),
          _buildCitationItem(context, 'MLA', _mlaCitation),
          const SizedBox(height: 16),
          _buildCitationItem(context, 'Chicago', _chicagoCitation),
        ],
      ),
    );
  }

  Widget _buildCitationItem(
    BuildContext context,
    String format,
    String citation,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          format,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  citation,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(context, citation, format),
                icon: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Copy',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
