import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';
import '../widgets/address_search_widget.dart';
import '../widgets/address_form_widget.dart';
import '../widgets/location_permission_widget.dart';
import '../../../../core/services/location_service.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => getIt<AddressCubit>(),
        child: const AddAddressPage(),
      ),
    );
  }

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LocationResult? _selectedLocation;
  
  // Map step or form step
  bool _showForm = false;
  late AnimationController _formAnimationController;
  late Animation<Offset> _formSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller for popup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Form animation controller
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formAnimationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          _updateMapLocation(state.location);
        } else if (state is AddressAdded) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Address saved successfully!'),
              backgroundColor: theme.colorScheme.primary,
              duration: Duration(seconds: 2),
            ),
          );
          _closeDialog();
        } else if (state is AddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      _buildMainContent(context, theme),
                      
                      // Form overlay
                      if (_showForm)
                        SlideTransition(
                          position: _formSlideAnimation,
                          child: Container(
                            color: theme.colorScheme.surface,
                            child: AddressFormWidget(
                              location: _selectedLocation,
                              onSave: (address) {
                                context.read<AddressCubit>().addAddress(address);
                              },
                              onBack: () => _hideForm(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Header
        _buildHeader(context, theme),
        
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppSizes.mediumPadding),
          child: AddressSearchWidget(
            onLocationSelected: (location) {
              _updateMapLocation(location);
            },
            onCurrentLocationTap: () {
              context.read<AddressCubit>().getCurrentLocation();
            },
          ),
        ),
        
        // Map
        Expanded(child: _buildMap(context, theme)),
        
        // Next button
        _buildNextButton(context, theme),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: theme.colorScheme.primary,
            size: AppSizes.largeIcon,
          ),
          const SizedBox(width: AppSizes.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Address',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'Search or select your location on the map',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _closeDialog(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, ThemeData theme) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is LocationLoading) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            ),
          );
        }

        if (state is AddressError && state.message.contains('permission')) {
          return LocationPermissionWidget(
            onRetry: () {
              context.read<AddressCubit>().getCurrentLocation();
            },
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(21.2514, 81.6296), // Raipur default
              zoom: 14,
            ),
            markers: _markers,
            onTap: (LatLng position) {
              _onMapTapped(position);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
        );
      },
    );
  }

  Widget _buildNextButton(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: _selectedLocation != null ? () => _showFormStep() : null,
          backgroundColor: _selectedLocation != null 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          foregroundColor: _selectedLocation != null 
              ? theme.colorScheme.onPrimary 
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          elevation: _selectedLocation != null ? 8 : 0,
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Next Step'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMapLocation(LocationResult location) {
    setState(() {
      _selectedLocation = location;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet: location.address,
          ),
        ),
      };
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        16,
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    // Get address for tapped location
    context.read<AddressCubit>().getCurrentLocation();
    
    // For now, create a simple location result
    final location = LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      address: 'Selected Location',
    );
    
    _updateMapLocation(location);
  }

  void _showFormStep() {
    setState(() {
      _showForm = true;
    });
    _formAnimationController.forward();
  }

  void _hideForm() {
    _formAnimationController.reverse().then((_) {
      setState(() {
        _showForm = false;
      });
    });
  }

  void _closeDialog() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }
}
