import 'package:flutter/material.dart';

class TagSection extends StatelessWidget {
  final List<String> tags;
  final Function(String) onAddTag;
  final Function(String) onRemoveTag;

  const TagSection({
    super.key,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) onAddTag(val.trim());
                  _controller.clear();
                },
                decoration: InputDecoration(
                  hintText: 'Tambah tag...',
                  prefixIcon: const Icon(Icons.tag_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  onAddTag(_controller.text.trim());
                  _controller.clear();
                }
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: tags
              .map((tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => onRemoveTag(tag),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
