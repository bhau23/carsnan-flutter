import '../../domain/entities/service.dart';

class DashboardState {
  final List<Service> services;
  final bool isLoading;
  final String? error;
  final int selectedBottomNavIndex;
  final String? selectedServiceId;

  const DashboardState({
    this.services = const [],
    this.isLoading = false,
    this.error,
    this.selectedBottomNavIndex = 0,
    this.selectedServiceId,
  });

  DashboardState copyWith({
    List<Service>? services,
    bool? isLoading,
    String? error,
    int? selectedBottomNavIndex,
    String? selectedServiceId,
  }) {
    return DashboardState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedBottomNavIndex: selectedBottomNavIndex ?? this.selectedBottomNavIndex,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
    );
  }
}
