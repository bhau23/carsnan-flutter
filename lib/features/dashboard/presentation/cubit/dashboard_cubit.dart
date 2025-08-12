import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_services_usecase.dart';
import '../../domain/entities/service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetServicesUseCase getServicesUseCase;

  DashboardCubit({
    required this.getServicesUseCase,
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
  }

  void navigateToAddVehicle() {
    // TODO: Implement navigation to add vehicle page
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
