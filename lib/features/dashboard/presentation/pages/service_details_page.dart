import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/dynamic_pricing_service.dart';
import '../../../../core/services/vehicle_selection_service.dart';
import '../../domain/entities/service.dart';
import '../widgets/service_item_card.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../car/domain/entities/car.dart';

class ServiceDetailsPage extends StatefulWidget {
  final Service service;

  const ServiceDetailsPage({super.key, required this.service});

  static void show(BuildContext context, Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsPage(service: service),
    );
  }

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  // Multiple banner images for each service
  List<String> get _bannerImages {
    switch (widget.service.type) {
      case ServiceType.general:
        return [
          'assets/images/services/banners/general/banner1.png',
          'assets/images/services/banners/general/banner2.png',
          'assets/images/services/banners/general/banner3.png',
        ];
      case ServiceType.premium:
        return [
          'assets/images/services/banners/premium/banner1.png',
          'assets/images/services/banners/premium/banner2.png',
          'assets/images/services/banners/premium/banner3.png',
        ];
      case ServiceType.luxury:
        return [
          'assets/images/services/banners/luxury/banner1.png',
          'assets/images/services/banners/luxury/banner2.png',
          'assets/images/services/banners/luxury/banner3.png',
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background overlay
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),

        // Modal content
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: screenHeight * 0.95,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle for better UX
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Service banner
                      SliverToBoxAdapter(
                        child: _buildServiceBanner(context, theme),
                      ),

                      // Service details
                      SliverToBoxAdapter(
                        child: _buildServiceDetails(context, theme),
                      ),

                      // What's included section
                      SliverToBoxAdapter(
                        child: _buildWhatsIncludedSection(context, theme),
                      ),

                      // Bottom padding to account for fixed bottom bar
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 100),
                      ),
                    ],
                  ),
                ),

                // Fixed bottom action bar
                _buildBottomActionBar(context, theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBanner(BuildContext context, ThemeData theme) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image carousel
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: _bannerImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getServiceColor(
                              widget.service.type,
                            ).withValues(alpha: 0.8),
                            _getServiceColor(
                              widget.service.type,
                            ).withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getServiceIcon(widget.service.type),
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Image ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),

            // Highlight feature banner
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.service.highlightFeature,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Dot indicators
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bannerImages.asMap().entries.map((entry) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Left tap area for previous image (ON TOP)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 100,
              child: GestureDetector(
                onTap: () {
                  _previousImage();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Right tap area for next image (ON TOP)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 100,
              child: GestureDetector(
                onTap: () {
                  _nextImage();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextImage() {
    if (_currentImageIndex < _bannerImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // If at the last image, go to first image (loop)
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // If at the first image, go to last image (loop)
      _pageController.animateToPage(
        _bannerImages.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildServiceDetails(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service title
          Text(
            widget.service.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Price and duration row
          Row(
            children: [
              // Price
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '₹${widget.service.price.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Duration
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.service.estimatedDurationInMinutes} mins',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Service description
          Text(
            widget.service.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsIncludedSection(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is Included in my Service?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Horizontally scrollable service items
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.service.includedItems.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = widget.service.includedItems[index];
                return ServiceItemCard(
                  serviceItem: item,
                  serviceType: widget.service.type,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: StreamBuilder(
          stream: getIt<VehicleSelectionService>().selectedVehicleStream,
          initialData: getIt<VehicleSelectionService>().selectedVehicle,
          builder: (context, snapshot) {
            final selectedCar = snapshot.data;
            final pricingService = getIt<DynamicPricingService>();
            final pricingInfo = pricingService.getPricingInfo(widget.service, selectedCar);
            
            return Row(
              children: [
                // Left side - Price and duration with vehicle info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedCar != null) ...[
                        Row(
                          children: [
                            Text(
                              selectedCar.type.icon,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              selectedCar.type.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        '₹${pricingInfo.finalPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${widget.service.estimatedDurationInMinutes} mins',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right side - Add to Cart button
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: selectedCar != null 
                      ? () => _addToCartDirectly(context, selectedCar)
                      : () => _showSelectVehicleMessage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      selectedCar != null ? 'Add to Cart' : 'Select Vehicle First',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _addToCartDirectly(BuildContext context, Car selectedCar) async {
    final cartCubit = context.read<CartCubit>();
    
    try {
      await cartCubit.addToCart(service: widget.service, car: selectedCar);
      
      if (context.mounted) {
        // Close the service details modal
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.service.title} added to cart for ${selectedCar.displayName}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showSelectVehicleMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please add a vehicle first from the dashboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getServiceColor(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return const Color(0xFF4CAF50); // Green
      case ServiceType.premium:
        return const Color(0xFF2196F3); // Blue
      case ServiceType.luxury:
        return const Color(0xFFD4AF37); // Gold
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return Icons.local_car_wash;
      case ServiceType.premium:
        return Icons.car_repair;
      case ServiceType.luxury:
        return Icons.diamond;
    }
  }
}
