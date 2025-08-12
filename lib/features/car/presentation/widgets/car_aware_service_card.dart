import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../domain/entities/car.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarAwareServiceCard extends StatelessWidget {
  const CarAwareServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CarCubit>()..loadCars(),
      child: BlocBuilder<CarCubit, CarState>(
        builder: (context, state) {
          Car? defaultCar;
          if (state is CarLoaded) {
            defaultCar = context.read<CarCubit>().defaultCar;
          }

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Service image
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image: AssetImage(service.bannerImagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Service details
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service title
                          Text(
                            service.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // Service description
                          Text(
                            service.description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          // Price with car type consideration
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Car type indicator (if available)
                              if (defaultCar != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        defaultCar.type.icon,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        defaultCar.type.displayName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Price
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[600],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '\$${_calculatePrice(service.price, defaultCar?.type).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
          );
        },
      ),
    );
  }

  double _calculatePrice(double basePrice, CarType? carType) {
    if (carType == null) {
      return basePrice;
    }
    return carType.calculatePrice(basePrice);
  }
}
