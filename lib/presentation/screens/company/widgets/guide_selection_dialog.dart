import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../providers/user/user_provider.dart';

class GuideSelectionDialog extends ConsumerStatefulWidget {
  final User? initialSelectedGuide;

  const GuideSelectionDialog({
    super.key,
    this.initialSelectedGuide,
  });

  @override
  ConsumerState<GuideSelectionDialog> createState() => _GuideSelectionDialogState();
}

class _GuideSelectionDialogState extends ConsumerState<GuideSelectionDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(tourGuidesProvider);

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Tour Guide',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search guides...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: guidesAsync.when(
                data: (guides) {
                  final filteredGuides = guides
                      .where((g) =>
                          g.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();

                  if (filteredGuides.isEmpty) {
                    return const Center(
                      child: Text('No guides found',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredGuides.length,
                    itemBuilder: (context, index) {
                      final guide = filteredGuides[index];
                      final isSelected = widget.initialSelectedGuide?.id == guide.id;

                      return ListTile(
                        onTap: () => Navigator.pop(context, guide),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        leading: CircleAvatar(
                          backgroundImage: (guide.avatar != null && guide.avatar!.isNotEmpty)
                              ? NetworkImage(guide.avatar!)
                              : null,
                          child: (guide.avatar == null || guide.avatar!.isEmpty)
                              ? Text(guide.name[0].toUpperCase())
                              : null,
                        ),
                        title: Text(
                          guide.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          guide.email,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),

                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.primary)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error: $err',
                      style: const TextStyle(color: Colors.red)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
