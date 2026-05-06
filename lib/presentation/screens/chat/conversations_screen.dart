import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../providers/booking/booking_provider.dart';
import 'chat_screen.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState.user;
    final isTourGuide = currentUser?.role == 'TourGuide';
    final bookingsState = ref.watch(isTourGuide ? allBookingsProvider : bookingNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.messages,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Search Bar (Refined) ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Conversations List ──────────────────────────────────────────
              Expanded(
                child: bookingsState.when(
                  data: (bookings) {
                    if (bookings.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    // ── Grouping & Sorting Logic ─────────────────────────────
                    // Filter and group bookings to ensure chat is between real accounts
                    final Map<String, dynamic> uniqueConversations = {};
                    
                    for (var b in bookings) {
                      // Determine the other party
                      final otherParty = (currentUser?.id == b.user?.id) 
                          ? b.tourGuide  // I am the traveler, other is the guide
                          : b.user;      // I am the guide, other is the traveler

                      // Only include if the other party is a real user with a valid role
                      if (otherParty != null) {
                        final id = otherParty.id;
                        
                        if (!uniqueConversations.containsKey(id) || 
                            b.createdAt.isAfter(uniqueConversations[id].createdAt)) {
                          uniqueConversations[id] = b;
                        }
                      }
                    }

                    // Convert map back to list and sort by most recent
                    final sortedConversations = uniqueConversations.values.toList()
                      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: sortedConversations.length,
                      itemBuilder: (context, index) {
                        final booking = sortedConversations[index];
                        return _ConversationCard(
                          booking: booking,
                          isMe: currentUser?.id == booking.user?.id,
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error loading chats',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a tour to start chatting!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final dynamic booking; // Use Booking type when imported correctly
  final bool isMe;

  const _ConversationCard({required this.booking, required this.isMe});

  @override
  Widget build(BuildContext context) {
    // Determine the other party
    final otherParty = isMe ? booking.tourGuide : booking.user;

    final String displayName = otherParty?.name ?? 'Unknown User';
    final String? avatarUrl = otherParty?.avatar;
    final String subtitle = booking.tourismService.title;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(booking: booking),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar with Glass Effect
                      Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.4),
                                  AppColors.secondary.withValues(alpha: 0.2),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildInitial(displayName),
                                    ),
                                  )
                                : _buildInitial(displayName),
                          ),
                          // Online Status Dot (Optional/Fake for now)
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Just now', // Placeholder as discussed
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Trailing Arrow
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitial(String name) {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
