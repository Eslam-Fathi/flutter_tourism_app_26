import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/interaction_model.dart';
import '../base/base_providers.dart';

part 'review_provider.g.dart';

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  FutureOr<List<Review>> build(String serviceId) async {
    final repo = ref.read(interactionRepositoryProvider);
    return repo.getServiceReviews(serviceId);
  }

  Future<void> submitReview({
    required String serviceId,
    required int rating,
    required String comment,
  }) async {
    final repo = ref.read(interactionRepositoryProvider);
    
    // Optimistic UI could be added here, but reviews often need server-side validation
    // (e.g., checking if user actually booked the service)
    await repo.addReview({
      'service': serviceId,
      'rating': rating,
      'comment': comment,
    });
    
    // Refresh the list after successful submission
    ref.invalidateSelf();
  }
}
