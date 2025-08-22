import '../../domain/entities/service.dart';
import '../../../cart/domain/entities/cart.dart';

class DashboardState {
  final List<Service> services;
  final bool isLoading;
  final String? error;
  final int selectedBottomNavIndex;
  final String? selectedServiceId;

  // Orders related state
  final List<Booking> orders;
  final bool isLoadingOrders;
  final String? ordersError;

  const DashboardState({
    this.services = const [],
    this.isLoading = false,
    this.error,
    this.selectedBottomNavIndex = 0,
    this.selectedServiceId,
    this.orders = const [],
    this.isLoadingOrders = false,
    this.ordersError,
  });

  DashboardState copyWith({
    List<Service>? services,
    bool? isLoading,
    String? error,
    int? selectedBottomNavIndex,
    String? selectedServiceId,
    List<Booking>? orders,
    bool? isLoadingOrders,
    String? ordersError,
  }) {
    return DashboardState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedBottomNavIndex:
          selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
      orders: orders ?? this.orders,
      isLoadingOrders: isLoadingOrders ?? this.isLoadingOrders,
      ordersError: ordersError ?? this.ordersError,
    );
  }
}
