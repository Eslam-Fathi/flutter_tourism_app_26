import '../../data/models/service_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/company_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/user_model.dart';

class PlaceholderData {
  static final List<TourismService> mockServices = [
    const TourismService(
      id: 'mock_1',
      title: 'Bali Island Retreat',
      price: 1200.0,
      location: 'Bali, Indonesia',
      category: 'Tropical',
      company: 'company_1',
      description: 'Experience the magic of Bali with pristine beaches and ancient temples.',
      images: ['assets/images/bali.png'],
      rating: 4.8,
      reviewsCount: 124,
    ),
    const TourismService(
      id: 'mock_2',
      title: 'Kyoto Cultural Tour',
      price: 850.0,
      location: 'Kyoto, Japan',
      category: 'Cultural',
      company: 'company_2',
      description: 'Discover the ancient capital with guided temple and shrine visits.',
      images: ['assets/images/kyoto.png'],
      rating: 4.9,
      reviewsCount: 312,
    ),
  ];

  static final List<Booking> mockBookings = [
    Booking(
      id: 'b_mock_1',
      tourismService: mockServices[0],
      user: 'u_mock_1',
      dates: BookingDates(
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 12)),
      ),
      status: 'confirmed',
      totalPrice: 1200.0,
      createdAt: DateTime.now(),
    ),
    Booking(
      id: 'b_mock_2',
      tourismService: mockServices[1],
      user: 'u_mock_1',
      dates: BookingDates(
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        endDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      status: 'completed',
      totalPrice: 850.0,
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Company> mockCompanies = [
    Company(
      id: 'company_1',
      name: 'Island Escapes Ltd',
      category: 'Tropical',
      approved: true,
      description: 'Specialists in tropical island resorts.',
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    ),
    Company(
      id: 'company_2',
      name: 'Nippon Tours',
      category: 'Cultural',
      approved: false,
      description: 'Authentic cultural guiding across Japan.',
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
  ];

  static final List<ChatMessage> mockMessages = [
    ChatMessage(
      id: 'msg_1',
      booking: 'b_mock_1',
      content: 'Hello! Thanks for booking with Island Escapes. Can we confirm your time of arrival?',
      sender: const User(id: 'company_1', name: 'Island Escapes Ltd', email: 'contact@islandescapes.com', role: 'Company'),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    ChatMessage(
      id: 'msg_2',
      booking: 'b_mock_1',
      content: 'Hi! Yes, my flight arrives at 14:00 local time.',
      sender: const User(id: 'u_mock_1', name: 'Guest Explorer', email: 'guest@example.com', role: 'User'),
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    ),
    ChatMessage(
      id: 'msg_3',
      booking: 'b_mock_1',
      content: 'Perfect. Our driver will be waiting at Terminal 2 with a sign. See you soon!',
      sender: const User(id: 'company_1', name: 'Island Escapes Ltd', email: 'contact@islandescapes.com', role: 'Company'),
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];
}
