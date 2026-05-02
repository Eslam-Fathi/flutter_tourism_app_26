import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/utils/app_enums.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'package:flutter_tourism_app_26/presentation/providers/company/company_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aurora_background.dart';

class CompanyServicesScreen extends ConsumerWidget {
  const CompanyServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesState = ref.watch(companyServicesProvider);
    final myCompanyAsync = ref.watch(myCompanyProvider);
    final isApproved = myCompanyAsync.valueOrNull?.approved ?? false;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: Responsive.isDesktop(context) ? 0 : 90,
        ),
        child: FloatingActionButton.extended(
          onPressed: isApproved
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => const _CreateServiceDialog(),
                  );
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your company is pending admin approval. You cannot add services yet.'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
          backgroundColor: isApproved ? Colors.blueAccent : Colors.grey,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Trip Plan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  'My Trip Plans',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                floating: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: servicesState.when(
                  data: (services) {
                    if (services.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'There is no data. Add your first trip plan!',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final service = services[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.blueAccent.withValues(
                                    alpha: 0.2,
                                  ),
                                  image: service.images.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            service.images.first,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: service.images.isEmpty
                                    ? const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white54,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      service.location,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${service.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: services.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading services: $error',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateServiceDialog extends ConsumerStatefulWidget {
  const _CreateServiceDialog();

  @override
  ConsumerState<_CreateServiceDialog> createState() =>
      _CreateServiceDialogState();
}

class _CreateServiceDialogState extends ConsumerState<_CreateServiceDialog> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  ServiceCategory? _selectedCategory;
  final List<String> _imageUrls = [];
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_titleController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final myCompanyProfile = await ref.read(myCompanyProvider.future);

      if (myCompanyProfile == null) {
        throw 'Company profile not found. Please contact admin.';
      }

      final price = double.tryParse(_priceController.text.trim());
      if (price == null) throw 'Invalid price format';

      final repo = ref.read(serviceRepositoryProvider);
      await repo.createService({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': price,
        'location': _locationController.text.trim(),
        'category': _selectedCategory!.value,
        'company': myCompanyProfile.id,
        'images': _imageUrls,
      });

      // Refresh services
      ref.read(serviceNotifierProvider.notifier).refresh();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Trip Plan created successfully!',
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
            content: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
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
                          Icon(Icons.map, color: Colors.blueAccent, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'New Trip Plan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField('Title*', _titleController),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Description*',
                        _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Price*',
                        _priceController,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Location*', _locationController),
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 24),
                      const Text(
                        'Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Image URL',
                              _imageUrlController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: () {
                              final url = _imageUrlController.text.trim();
                              if (url.isNotEmpty) {
                                setState(() {
                                  _imageUrls.add(url);
                                  _imageUrlController.clear();
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _imageUrls.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                  image: DecorationImage(
                                    image: NetworkImage(_imageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageUrls.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
                              backgroundColor: Colors.blueAccent,
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
    return DropdownButtonFormField<ServiceCategory>(
      value: _selectedCategory,
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
      items: ServiceCategory.values.map((cat) {
        return DropdownMenuItem(value: cat, child: Text(cat.label));
      }).toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }
}
