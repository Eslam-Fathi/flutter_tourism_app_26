import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/supabase_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/admin/article_management_provider.dart';

class CreateArticleDialog extends ConsumerStatefulWidget {
  const CreateArticleDialog({super.key});

  @override
  ConsumerState<CreateArticleDialog> createState() => _CreateArticleDialogState();
}

class _CreateArticleDialogState extends ConsumerState<CreateArticleDialog> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  XFile? _pickedFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _pickedFile == null ||
        _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = SupabaseConfig.client;

      // 1. Upload Image bytes (works on both web and mobile)
      final fileExtension = _pickedFile!.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final path = 'article_images/$fileName';

      await supabase.storage.from('articles').uploadBinary(
            path,
            _imageBytes!,
            fileOptions: FileOptions(contentType: 'image/$fileExtension'),
          );

      // 2. Get Public URL
      final imageUrl = supabase.storage.from('articles').getPublicUrl(path);

      // 3. Create Record in Database
      await ref.read(articleNotifierProvider.notifier).createArticle({
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'author': _authorController.text.trim(),
        'content': _contentController.text.trim(),
        'image_url': imageUrl,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Historical Article',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10, style: BorderStyle.solid),
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: Colors.white38, size: 48),
                            SizedBox(height: 12),
                            Text('Select Article Image', style: TextStyle(color: Colors.white38)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField('Article Title', _titleController, Icons.title),
              const SizedBox(height: 16),
              _buildTextField('Author Name', _authorController, Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField('Location (e.g. Giza, Egypt)', _locationController, Icons.location_on_outlined),
              const SizedBox(height: 16),
              _buildTextField('Article Content', _contentController, Icons.article_outlined, maxLines: 5),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Publish Article',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7), size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// Extension to fix the rounded button style issue seen before
extension RoundedRectangleType on RoundedRectangleBorder {
  static RoundedRectangleBorder rounded(double radius) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
}
