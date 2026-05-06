import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/core/utils/app_enums.dart';
import 'package:flutter_tourism_app_26/core/utils/responsive.dart';
import 'package:flutter_tourism_app_26/presentation/providers/base/base_providers.dart';
import 'package:flutter_tourism_app_26/presentation/providers/company/company_provider.dart';
import 'package:flutter_tourism_app_26/presentation/providers/service/service_provider.dart';
import 'package:flutter_tourism_app_26/core/theme/app_colors.dart';
import 'package:flutter_tourism_app_26/core/widgets/aurora_background.dart';
import 'package:flutter_tourism_app_26/data/models/user_model.dart';
import 'package:flutter_tourism_app_26/presentation/providers/user/user_provider.dart';
import 'package:flutter_tourism_app_26/presentation/screens/company/widgets/guide_selection_dialog.dart';
import 'package:flutter_tourism_app_26/core/utils/location_mapper.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:flutter_tourism_app_26/presentation/widgets/service_location_map.dart';

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
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.pendingApprovalMsg,
                      ),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
          backgroundColor: isApproved ? Colors.blueAccent : Colors.grey,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.addTripPlan,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  AppLocalizations.of(context)!.myTripPlans,
                  style: const TextStyle(
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
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.noDataAddFirst,
                            style: const TextStyle(color: Colors.white70),
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
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        _CreateServiceDialog(service: service),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                tooltip: AppLocalizations.of(context)!.editTrip,
                              ),
                              IconButton(
                                onPressed: () =>
                                    _confirmDelete(context, ref, service),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                tooltip: AppLocalizations.of(
                                  context,
                                )!.deleteTrip,
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

  void _confirmDelete(BuildContext context, WidgetRef ref, dynamic service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.deleteTripQuestion,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteTripConfirm(service.title),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(serviceRepositoryProvider)
                    .deleteService(service.id);
                ref.read(serviceNotifierProvider.notifier).refresh();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.tripDeletedSuccess,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateServiceDialog extends ConsumerStatefulWidget {
  final dynamic service;
  const _CreateServiceDialog({this.service});

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
  User? _selectedGuide;
  bool _guideInitialized = false;
  bool _showMapPreview = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _titleController.text = widget.service.title;
      _priceController.text = widget.service.price.toString();
      _locationController.text = widget.service.location;
      _descriptionController.text = widget.service.cleanDescription ?? '';
      _imageUrls.addAll(List<String>.from(widget.service.images));
      _selectedCategory = ServiceCategory.values.firstWhere(
        (c) => c.value == widget.service.category,
        orElse: () => ServiceCategory.tours,
      );
    }
  }

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.allFieldsRequired),
        ),
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
      final serviceData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': price,
        'location': _locationController.text.trim(),
        'category': _selectedCategory!.value,
        'company': myCompanyProfile.id,
        'images': _imageUrls,
      };

      if (_selectedGuide != null) {
        serviceData['description'] =
            '${_descriptionController.text.trim()}\n\n[[guideId:${_selectedGuide!.id}]]';
      }

      if (widget.service != null) {
        await repo.updateService(widget.service.id, serviceData);
      } else {
        await repo.createService(serviceData);
      }

      // Refresh services
      ref.read(serviceNotifierProvider.notifier).refresh();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.service != null
                  ? AppLocalizations.of(context)!.tripPlanUpdated
                  : AppLocalizations.of(context)!.tripPlanCreated,
              style: const TextStyle(color: Colors.white),
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
                      Row(
                        children: [
                          const Icon(
                            Icons.map,
                            color: Colors.blueAccent,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.service != null
                                ? AppLocalizations.of(context)!.editTrip
                                : AppLocalizations.of(context)!.newTripPlan,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        AppLocalizations.of(context)!.titleWithStar,
                        _titleController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        AppLocalizations.of(context)!.descriptionWithStar,
                        _descriptionController,
                        maxLines: 3,
                        maxLength: 2000,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        AppLocalizations.of(context)!.priceWithStar,
                        _priceController,
                        isNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLocationPicker(),
                      if (_showMapPreview &&
                          _locationController.text.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ServiceLocationMap(
                          locationName: _locationController.text,
                          height: 150,
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      _buildGuideSelector(),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: const TextStyle(
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
                              AppLocalizations.of(context)!.imageUrl,
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
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: const TextStyle(color: Colors.white54),
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
                                : Text(
                                    widget.service != null
                                        ? AppLocalizations.of(context)!.update
                                        : AppLocalizations.of(context)!.create,
                                    style: const TextStyle(
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
      initialValue: _selectedCategory,
      dropdownColor: AppColors.surfaceDark,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.selectCategoryWithStar,
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

  Widget _buildGuideSelector() {
    // Initialize guide if editing
    if (!_guideInitialized && widget.service != null) {
      final guideId = widget.service.assignedGuideId;
      if (guideId != null) {
        final guidesAsync = ref.watch(tourGuidesProvider);
        guidesAsync.whenData((guides) {
          try {
            _selectedGuide = guides.firstWhere((g) => g.id == guideId);
            _guideInitialized = true;
            setState(() {});
          } catch (_) {}
        });
      }
    }

    return InkWell(
      onTap: () async {
        final guide = await showDialog<User>(
          context: context,
          builder: (context) =>
              GuideSelectionDialog(initialSelectedGuide: _selectedGuide),
        );
        if (guide != null) {
          setState(() => _selectedGuide = guide);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_pin, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedGuide != null
                    ? AppLocalizations.of(
                        context,
                      )!.guideLabel(_selectedGuide!.name)
                    : AppLocalizations.of(context)!.selectTourGuideOptional,
                style: TextStyle(
                  color: _selectedGuide != null ? Colors.white : Colors.white38,
                ),
              ),
            ),
            if (_selectedGuide != null)
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.white54),
                onPressed: () => setState(() => _selectedGuide = null),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              const Icon(Icons.arrow_drop_down, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: _locationController.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return LocationMapper.supportedCities.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        setState(() {
          _locationController.text = selection;
          _showMapPreview = true;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        // Sync our controller with autocomplete controller
        if (_locationController.text.isNotEmpty && controller.text.isEmpty) {
          controller.text = _locationController.text;
        }
        controller.addListener(() {
          if (_locationController.text != controller.text) {
            _locationController.text = controller.text;
          }
        });

        return TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 100,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.locationPlaceholder,
            hintStyle: const TextStyle(color: Colors.white38),
            counterText: '', // Hide counter for cleaner UI
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
            suffixIcon: IconButton(
              icon: Icon(
                _showMapPreview ? Icons.map : Icons.map_outlined,
                color: _showMapPreview ? Colors.blueAccent : Colors.white38,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _showMapPreview = !_showMapPreview),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 352, // Match dialog width minus padding
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option[0].toUpperCase() + option.substring(1),
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength ?? (isNumber ? 10 : 100),
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
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
