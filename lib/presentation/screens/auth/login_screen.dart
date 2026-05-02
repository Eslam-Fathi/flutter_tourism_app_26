import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/utils/app_enums.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSignUp = false;
  // Valid backend roles (Admin is assigned server-side, not self-registered)
  static const List<Map<String, dynamic>> _roles = [
    {'value': 'User',      'label': 'Traveller',  'icon': Icons.person_outline},
    {'value': 'Manager',   'label': 'Manager',    'icon': Icons.business_center_outlined},
    {'value': 'TourGuide', 'label': 'Tour Guide', 'icon': Icons.map_outlined},
  ];
  int _selectedRoleIndex = 0; // default: User/Traveller
  final _companyNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  String _companyCategory = CompanyCategory.tours.value; // default: 'Tours'


  final _nameController = TextEditingController();

  late final AnimationController _enterController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
        parent: _enterController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _enterController, curve: Curves.easeOutCubic));
    _enterController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _companyNameController.dispose();
    _companyDescriptionController.dispose();
    _companyAddressController.dispose();
    _companyPhoneController.dispose();
    _enterController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    // Use isSubmitting (not AuthStatus.loading) so only the button shows a
    // spinner during login/register — no full-screen loading scaffold.
    final isLoading = authState.isSubmitting;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFFE0E7FF)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.travel_explore,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Tagline
                          Text(
                            'Discover\nthe World',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 46,
                                  height: 1.05,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isSignUp
                                ? 'Create an account to start your journey.'
                                : 'Sign in to start your next adventure\nwith SeYaha.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Sign In / Sign Up toggle
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 6, sigmaY: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _tabButton('Sign In', !_isSignUp,
                                        () => setState(
                                            () => _isSignUp = false)),
                                    _tabButton('Sign Up', _isSignUp,
                                        () => setState(
                                            () => _isSignUp = true)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form Card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 16, sigmaY: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                                  borderRadius:
                                      BorderRadius.circular(24),
                                  border: Border.all(
                                    color:
                                        Colors.white.withOpacity(0.6),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withOpacity(0.08),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: AnimatedSize(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isSignUp) ...[
                                        _formField(
                                          controller: _nameController,
                                          hint: 'Full name',
                                          icon: Icons.person_outline,
                                        ),
                                        _divider(),
                                        // ── Role selector ────────────────
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            children: [
                                              Icon(Icons.badge_outlined, size: 20, color: AppColors.primary),
                                              const SizedBox(width: 12),
                                              Text('Register as', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                                              const Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withValues(alpha: 0.08),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: List.generate(_roles.length, (i) {
                                                    final role = _roles[i];
                                                    return _roleChip(
                                                      role['label'] as String,
                                                      _selectedRoleIndex == i,
                                                      () => setState(() => _selectedRoleIndex = i),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // ── Company fields (Manager only) ──
                                        if (_selectedRoleIndex == 1) ...[
                                          _divider(),
                                          _formField(
                                            controller: _companyNameController,
                                            hint: 'Company name',
                                            icon: Icons.business_outlined,
                                          ),
                                          _divider(),
                                          _formField(
                                            controller: _companyDescriptionController,
                                            hint: 'Company description',
                                            icon: Icons.description_outlined,
                                          ),
                                          _divider(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                            child: DropdownButtonFormField<String>(
                                              value: _companyCategory,
                                              decoration: const InputDecoration(
                                                prefixIcon: Icon(Icons.category_outlined, color: AppColors.primary, size: 20),
                                                hintText: 'Category',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                                              ),
                                              items: CompanyCategory.values
                                                  .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                                                  .toList(),
                                              onChanged: (v) => setState(() => _companyCategory = v!),
                                            ),
                                          ),
                                          _divider(),
                                          _formField(
                                            controller: _companyAddressController,
                                            hint: 'Company Address',
                                            icon: Icons.location_on_outlined,
                                          ),
                                          _divider(),
                                          _formField(
                                            controller: _companyPhoneController,
                                            hint: 'Company Phone',
                                            icon: Icons.phone_outlined,
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ],
                                        _divider(),


                                      ],
                                      _formField(
                                        controller: _emailController,
                                        hint: 'Email address',
                                        icon: Icons.mail_outline,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      _divider(),
                                      _formField(
                                        controller: _passwordController,
                                        hint: 'Password',
                                        icon: Icons.lock_outline,
                                        obscureText: _obscurePassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons
                                                    .visibility_off_outlined,
                                            size: 20,
                                            color: AppColors.textMuted,
                                          ),
                                          onPressed: () => setState(() =>
                                              _obscurePassword =
                                                  !_obscurePassword),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Error message
                          if (authState.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.error.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.error
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: AppColors.error, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authState.errorMessage!,
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Primary CTA button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6809CE),
                                    Color(0xFF4338CA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(24),
                                  ),
                                  minimumSize: const Size(
                                      double.infinity, 58),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_isSignUp) {
                                          final roleValue = _roles[_selectedRoleIndex]['value'] as String;
                                          if (_selectedRoleIndex == 1) {
                                            // Manager: register + create company
                                            ref.read(authNotifierProvider.notifier).registerAsCompany(
                                              _nameController.text.trim(),
                                              _emailController.text.trim(),
                                              _passwordController.text,
                                              _companyNameController.text.trim(),
                                              _companyDescriptionController.text.trim(),
                                              _companyCategory,
                                              _companyAddressController.text.trim(),
                                              _companyPhoneController.text.trim(),
                                            );
                                          } else {
                                            // User or TourGuide: plain register
                                            ref.read(authNotifierProvider.notifier).register(
                                              _nameController.text.trim(),
                                              _emailController.text.trim(),
                                              _passwordController.text,
                                              role: roleValue,
                                            );
                                          }
                                        } else {
                                          ref
                                              .read(authNotifierProvider.notifier)
                                              .login(
                                                _emailController.text.trim(),
                                                _passwordController.text,
                                              );
                                        }
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        _isSignUp
                                            ? 'Create Account'
                                            : 'Continue',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Guest access
                          Center(
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(authNotifierProvider.notifier)
                                  .continueAsGuest(),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color:
                                        Colors.white.withOpacity(0.75),
                                    fontSize: 14,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Just browsing? '),
                                    TextSpan(
                                      text: 'Continue as Guest',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                            TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleChip(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _tabButton(
      String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? AppColors.primary : Colors.white70,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: AppColors.textBody, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
        suffixIcon: suffixIcon,
        fillColor: Colors.transparent,
        filled: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.15));
  }
}
