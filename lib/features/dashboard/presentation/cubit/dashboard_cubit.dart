import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_services_usecase.dart';
import '../../domain/entities/service.dart';
import '../../../cart/domain/repositories/cart_repository.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final GetServicesUseCase getServicesUseCase;
  final BookingRepository bookingRepository;
  final ReviewRepository reviewRepository;

  DashboardCubit({
    required this.getServicesUseCase,
    required this.bookingRepository,
    required this.reviewRepository,
  }) : super(const DashboardState());

  Future<void> loadServices() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final services = await getServicesUseCase();
      emit(state.copyWith(services: services, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void updateBottomNavIndex(int index) {
    emit(state.copyWith(selectedBottomNavIndex: index));

    // Load orders when orders tab is selected
    if (index == 1) {
      loadOrders();
    }
  }

  /// Load user orders
  Future<void> loadOrders() async {
    emit(state.copyWith(isLoadingOrders: true, ordersError: null));

    try {
      // For demo purposes, using a hardcoded user ID
      const String userId = 'demo_user_123';
      final orders = await bookingRepository.getUserBookings(userId);
      emit(state.copyWith(orders: orders, isLoadingOrders: false));
    } catch (e) {
      emit(state.copyWith(isLoadingOrders: false, ordersError: e.toString()));
    }
  }

  /// Create a review for a completed booking
  Future<void> createReview({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    try {
      // For demo purposes, using hardcoded IDs
      const String clientId = 'demo_user_123';
      const String workerId = 'demo_worker_123';

      await reviewRepository.createReview(
        bookingId: bookingId,
        clientId: clientId,
        workerId: workerId,
        rating: rating,
        comment: comment,
        serviceName: 'Car Wash Service',
        clientName: 'Demo User',
        workerName: 'Demo Worker',
      );

      // Reload orders to update review status
      await loadOrders();
    } catch (e) {
      emit(state.copyWith(ordersError: 'Failed to create review: $e'));
    }
  }

  /// Check if a booking has been reviewed
  Future<bool> hasBookingBeenReviewed(String bookingId) async {
    try {
      const String clientId = 'demo_user_123';
      return await reviewRepository.hasClientReviewedBooking(
        bookingId,
        clientId,
      );
    } catch (e) {
      return false;
    }
  }

  void navigateToAddVehicle() {
    // TODO: Implement navigation to add vehicle page
  }

  void navigateToAddAddress() {
    // TODO: Implement navigation to add address page
  }

  void selectService(String serviceId) {
    emit(state.copyWith(selectedServiceId: serviceId));
  }

  Service? getServiceById(String serviceId) {
    try {
      return state.services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  }
}
