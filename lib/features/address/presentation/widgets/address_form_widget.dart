import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/address.dart';

class AddressFormWidget extends StatefulWidget {
  final LocationResult? location;
  final Function(Address) onSave;
  final VoidCallback onBack;

  const AddressFormWidget({
    super.key,
    required this.location,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Controllers
  final _titleController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _buildingNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedAddressType = 'Home';
  final List<String> _addressTypes = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.location != null) {
      // Parse the address and fill fields
      final addressParts = widget.location!.address.split(', ');
      if (addressParts.isNotEmpty) {
        _streetController.text = addressParts.first;
        if (addressParts.length > 1) {
          _areaController.text = addressParts[1];
        }
        if (addressParts.length > 2) {
          _cityController.text = addressParts[2];
        }
        if (addressParts.length > 3) {
          _stateController.text = addressParts[3];
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _houseNumberController.dispose();
    _floorNumberController.dispose();
    _buildingNameController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _instructionsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Header
          _buildHeader(context, theme),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSizes.mediumPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressTypeSelector(theme),
                    const SizedBox(height: AppSizes.largePadding),
                    
                    _buildLocationInfo(theme),
                    const SizedBox(height: AppSizes.largePadding),
                    
                    _buildAddressFields(theme),
                    const SizedBox(height: AppSizes.extraLargePadding * 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Floating save button
      floatingActionButton: _buildSaveButton(context, theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: widget.onBack,
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSizes.smallPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Fill in the complete address details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save address as',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.smallPadding),
        Row(
          children: _addressTypes.map((type) {
            final isSelected = _selectedAddressType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAddressType = type;
                    _titleController.text = type;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: AppSizes.smallPadding),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.mediumPadding,
                    horizontal: AppSizes.smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
                    border: Border.all(
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForType(type),
                        color: isSelected 
                            ? theme.colorScheme.onPrimary 
                            : theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected 
                              ? theme.colorScheme.onPrimary 
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    if (widget.location == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSizes.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Location',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.location!.address,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressFields(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _houseNumberController,
                label: 'House/Flat No.',
                hint: 'e.g., 101, A-201',
                icon: Icons.home,
              ),
            ),
            const SizedBox(width: AppSizes.mediumPadding),
            Expanded(
              child: _buildTextField(
                controller: _floorNumberController,
                label: 'Floor (Optional)',
                hint: 'e.g., 2nd Floor',
                icon: Icons.layers,
                isRequired: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _buildingNameController,
          label: 'Building/Society Name (Optional)',
          hint: 'e.g., Shanti Apartments',
          icon: Icons.business,
          isRequired: false,
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _streetController,
          label: 'Street/Road',
          hint: 'e.g., MG Road',
          icon: Icons.add_road,
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _areaController,
          label: 'Area/Locality',
          hint: 'e.g., Shankar Nagar',
          icon: Icons.location_city,
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _landmarkController,
          label: 'Landmark (Optional)',
          hint: 'e.g., Near City Mall',
          icon: Icons.place,
          isRequired: false,
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'e.g., Raipur',
                icon: Icons.location_city,
              ),
            ),
            const SizedBox(width: AppSizes.mediumPadding),
            Expanded(
              child: _buildTextField(
                controller: _pincodeController,
                label: 'Pincode',
                hint: '492001',
                icon: Icons.pin_drop,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _stateController,
          label: 'State',
          hint: 'e.g., Chhattisgarh',
          icon: Icons.map,
        ),
        const SizedBox(height: AppSizes.mediumPadding),
        
        _buildTextField(
          controller: _instructionsController,
          label: 'Delivery Instructions (Optional)',
          hint: 'e.g., Ring the bell twice, park in front',
          icon: Icons.notes,
          maxLines: 3,
          isRequired: false,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
      validator: isRequired ? (value) {
        if (value?.isEmpty ?? true) {
          return 'This field is required';
        }
        return null;
      } : null,
    );
  }

  Widget _buildSaveButton(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.mediumPadding),
      child: FloatingActionButton.extended(
        onPressed: _saveAddress,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 8,
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.save),
            SizedBox(width: 8),
            Text('Save Address'),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Home':
        return Icons.home;
      case 'Work':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _selectedAddressType,
        fullAddress: _buildFullAddress(),
        street: _streetController.text.trim(),
        area: _areaController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        latitude: widget.location?.latitude ?? 0.0,
        longitude: widget.location?.longitude ?? 0.0,
        landmark: _landmarkController.text.trim().isEmpty 
            ? null 
            : _landmarkController.text.trim(),
        houseNumber: _houseNumberController.text.trim().isEmpty 
            ? null 
            : _houseNumberController.text.trim(),
        floorNumber: _floorNumberController.text.trim().isEmpty 
            ? null 
            : _floorNumberController.text.trim(),
        buildingName: _buildingNameController.text.trim().isEmpty 
            ? null 
            : _buildingNameController.text.trim(),
        instructions: _instructionsController.text.trim().isEmpty 
            ? null 
            : _instructionsController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(address);
    }
  }

  String _buildFullAddress() {
    final parts = <String>[];
    
    if (_houseNumberController.text.trim().isNotEmpty) {
      parts.add(_houseNumberController.text.trim());
    }
    if (_buildingNameController.text.trim().isNotEmpty) {
      parts.add(_buildingNameController.text.trim());
    }
    if (_streetController.text.trim().isNotEmpty) {
      parts.add(_streetController.text.trim());
    }
    if (_areaController.text.trim().isNotEmpty) {
      parts.add(_areaController.text.trim());
    }
    if (_cityController.text.trim().isNotEmpty) {
      parts.add(_cityController.text.trim());
    }
    if (_stateController.text.trim().isNotEmpty) {
      parts.add(_stateController.text.trim());
    }
    if (_pincodeController.text.trim().isNotEmpty) {
      parts.add(_pincodeController.text.trim());
    }
    
    return parts.join(', ');
  }
}
