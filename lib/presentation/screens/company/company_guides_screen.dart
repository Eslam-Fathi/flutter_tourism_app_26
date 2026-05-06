import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/data/models/service_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/aurora_background.dart';
import '../../../../data/models/user_model.dart';
import '../../providers/user/user_provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../chat/chat_screen.dart';
import '../../../../data/models/booking_model.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';

class CompanyGuidesScreen extends ConsumerWidget {
  const CompanyGuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add guide logic
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)!.appointGuide,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                  AppLocalizations.of(context)!.guides,
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
                sliver: ref
                    .watch(tourGuidesProvider)
                    .when(
                      data: (guides) {
                        if (guides.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.noGuidesFound,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return _buildGuideCard(context, ref, guides[index]);
                          }, childCount: guides.length),
                        );
                      },
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'Error: $error',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, WidgetRef ref, User guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white10,
            backgroundImage: (guide.avatar != null && guide.avatar!.isNotEmpty)
                ? NetworkImage(guide.avatar!)
                : null,
            child: (guide.avatar == null || guide.avatar!.isEmpty)
                ? Text(
                    guide.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guide.email,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTag(
                      AppLocalizations.of(context)!.certified,
                      Colors.greenAccent,
                    ),
                    const SizedBox(width: 8),
                    _buildTag('★ 4.8', Colors.amberAccent),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Create a dummy booking context for the chat
              // The backend uses the 'booking' field as a conversation ID
              // We use the guide's ID to ensure a unique thread for this guide
              final dummyBooking = Booking(
                id: guide.id, // Using guide ID as the thread ID
                user: ref.read(authNotifierProvider).user,
                tourismService: TourismService(
                  id: 'direct_chat',
                  title: AppLocalizations.of(
                    context,
                  )!.chatWithGuide(guide.name),
                  location: 'Direct Message',
                  category: 'Communication',
                  company: 'SeYaha',
                ),
                tourGuide: guide,
                dates: BookingDates(
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 1)),
                ),
                totalPrice: 0,
                status: 'active',
                createdAt: DateTime.now(),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(booking: dummyBooking, partner: guide),
                ),
              );
            },
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.blueAccent,
            ),
            tooltip: AppLocalizations.of(context)!.messageGuide,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
