import 'package:flutter/material.dart';

import '../../domain/entities/car.dart';
import 'car_type_selector.dart';

class CarForm extends StatefulWidget {
  const CarForm({
    super.key,
    required this.onSubmit,
    this.car,
    this.isLoading = false,
    this.submitButtonText = 'Save',
  });

  final Function(Car car) onSubmit;
  final Car? car;
  final bool isLoading;
  final String submitButtonText;

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _nicknameController = TextEditingController();

  CarType _selectedType = CarType.sedan;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.car != null) {
      final car = widget.car!;
      _makeController.text = car.make;
      _modelController.text = car.model;
      _yearController.text = car.year.toString();
      _colorController.text = car.color;
      _licensePlateController.text = car.licensePlate;
      _nicknameController.text = car.nickname ?? '';
      _selectedType = car.type;
      _isDefault = car.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car Type Selector
            CarTypeSelector(
              selectedType: _selectedType,
              onTypeSelected: (type) => setState(() => _selectedType = type),
            ),

            const SizedBox(height: 24),

            // Make field
            TextFormField(
              controller: _makeController,
              decoration: const InputDecoration(
                labelText: 'Make *',
                hintText: 'e.g., Toyota, Honda, BMW',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the car make';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Model field
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model *',
                hintText: 'e.g., Camry, Accord, X5',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the car model';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Year field
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Year *',
                hintText: 'e.g., 2020',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the manufacturing year';
                }

                final year = int.tryParse(value);
                if (year == null) {
                  return 'Please enter a valid year';
                }

                final currentYear = DateTime.now().year;
                if (year < 1990 || year > currentYear + 1) {
                  return 'Please enter a year between 1990 and ${currentYear + 1}';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // Color field
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color *',
                hintText: 'e.g., Black, White, Silver',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.palette),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the car color';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // License Plate field
            TextFormField(
              controller: _licensePlateController,
              decoration: const InputDecoration(
                labelText: 'License Plate *',
                hintText: 'e.g., ABC-1234',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the license plate number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Nickname field (optional)
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname (Optional)',
                hintText: 'e.g., My Car, Family Car',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            // Default car switch
            SwitchListTile(
              title: const Text('Set as Default Car'),
              subtitle: const Text(
                'This will be selected automatically for new bookings',
              ),
              value: _isDefault,
              onChanged: (value) => setState(() => _isDefault = value),
              secondary: const Icon(Icons.star),
            ),

            const SizedBox(height: 32),

            // Submit button
            ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.submitButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 16),

            // Required fields note
            Text(
              '* Required fields',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final car = Car(
      id: widget.car?.id ?? '', // Will be generated in data source for new cars
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      color: _colorController.text.trim(),
      licensePlate: _licensePlateController.text.trim().toUpperCase(),
      nickname: _nicknameController.text.trim().isEmpty
          ? null
          : _nicknameController.text.trim(),
      type: _selectedType,
      isDefault: _isDefault,
      createdAt: widget.car?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSubmit(car);
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
}
