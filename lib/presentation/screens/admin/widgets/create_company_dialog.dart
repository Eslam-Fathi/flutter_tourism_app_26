import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/utils/app_enums.dart';
import 'package:flutter_tourism_app_26/presentation/providers/company/company_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'package:flutter_tourism_app_26/data/models/auth_models.dart';
import '../../../../../core/theme/app_colors.dart';

class CreateCompanyDialog extends ConsumerStatefulWidget {
  const CreateCompanyDialog({super.key});

  @override
  ConsumerState<CreateCompanyDialog> createState() =>
      _CreateCompanyDialogState();
}

class _CreateCompanyDialogState extends ConsumerState<CreateCompanyDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  CompanyCategory? _selectedCategory;
  final _descController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create the Auth Account (Admin creates Company user)
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerAccountOnly(
        RegisterRequest(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: 'company',
        ),
      );

      // 2. Create the Company Profile
      await ref.read(companyNotifierProvider.notifier).createCompany({
        'name': _nameController.text.trim(),
        'category': _selectedCategory!.label,
        'description': _descController.text.trim(),
        'approved': true, // Auto-approve created by admin
      });
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Company Account & Profile Created successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
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
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: const SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.business, color: Colors.redAccent, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'New Company',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField('Company Name*', _nameController),
                      const SizedBox(height: 16),
                      _buildTextField('Email Address*', _emailController,
                          isEmail: true),
                      const SizedBox(height: 16),
                      _buildTextField('Password*', _passwordController,
                          obscureText: true),
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                       _buildTextField(
                        'Description (Optional)',
                        _descController,
                        maxLines: 3,
                        maxLength: 1000,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Create',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<CompanyCategory>(
      initialValue: _selectedCategory,
      dropdownColor: AppColors.surfaceDark,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Select Category*',
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: CompanyCategory.values.map((cat) {
        return DropdownMenuItem(
          value: cat,
          child: Text(cat.label),
        );
      }).toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool obscureText = false,
    bool isEmail = false,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength ?? 100,
      obscureText: obscureText,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        counterStyle: const TextStyle(color: Colors.white54, fontSize: 10),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
