import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/time_slot.dart';
import '../../../../core/services/time_slot_service.dart';
import '../../domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/wash_type.dart';

class TimeSlotSelectionPage extends StatefulWidget {
  final Service service;
  final Car car;
  final WashType washType;

  const TimeSlotSelectionPage({
    Key? key,
    required this.service,
    required this.car,
    required this.washType,
  }) : super(key: key);

  @override
  State<TimeSlotSelectionPage> createState() => _TimeSlotSelectionPageState();
}

class _TimeSlotSelectionPageState extends State<TimeSlotSelectionPage>
    with TickerProviderStateMixin {
  final TimeSlotService _timeSlotService = TimeSlotService();
  
  DateTime? _selectedDate;
  TimeSlot? _selectedSlot;
  late List<DateTime> _availableDates;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  @override
  void initState() {
    super.initState();
    _availableDates = _timeSlotService.getAvailableDates();
    _selectedDate = _availableDates.first;
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideController.forward();
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Select Slot'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOutBack,
        )),
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateSelectionSection(theme),
                      const SizedBox(height: 30),
                      _buildTimeSlotSection(theme),
                      const SizedBox(height: 20),
                      _buildTermsSection(theme),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
              _buildBottomActionBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select the Date for your Service',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _availableDates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final date = _availableDates[index];
              final isSelected = _selectedDate?.day == date.day && 
                                _selectedDate?.month == date.month;
              final availableCount = _timeSlotService.getAvailableSlotCount(date);
              
              return _buildDateCard(date, isSelected, availableCount, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(DateTime date, bool isSelected, int availableCount, ThemeData theme) {
    final isToday = DateTime.now().day == date.day && 
                    DateTime.now().month == date.month &&
                    DateTime.now().year == date.year;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _selectedSlot = null; // Reset slot selection when date changes
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Availability indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: availableCount > 0 
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                availableCount > 0 ? Icons.check : Icons.close,
                size: 12,
                color: availableCount > 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM').format(date).toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
            Text(
              date.day.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
            Text(
              isToday ? 'MON' : DateFormat('EEE').format(date).toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection(ThemeData theme) {
    if (_selectedDate == null) return const SizedBox.shrink();
    
    final todaySlots = _timeSlotService.getSlotsForDate(_selectedDate!);
    final tomorrowDate = _selectedDate!.add(const Duration(days: 1));
    final tomorrowSlots = _timeSlotService.getSlotsForDate(tomorrowDate);
    
    final availableTodaySlots = todaySlots.where((slot) => slot.isAvailable).toList();
    final availableTomorrowSlots = tomorrowSlots.where((slot) => slot.isAvailable).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select the start time for your service',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        Text(
          'Your service will take approximately ${widget.service.estimatedDurationInMinutes} minutes',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        
        // Today's slots
        _buildSlotSection(
          'Today (${availableTodaySlots.length} slots available)',
          availableTodaySlots,
          theme,
        ),
        
        const SizedBox(height: 20),
        
        // Tomorrow's slots  
        _buildSlotSection(
          'Tomorrow (${availableTomorrowSlots.length} slots available)',
          availableTomorrowSlots,
          theme,
        ),
        
        const SizedBox(height: 16),
        
        // Suggestion box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cannot find Preferred Slots?',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try other days for more options!',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlotSection(String title, List<TimeSlot> slots, ThemeData theme) {
    if (slots.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'No time slots available for today.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Please select another date!',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots.map((slot) => _buildTimeSlotCard(slot, theme)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotCard(TimeSlot slot, ThemeData theme) {
    final isSelected = _selectedSlot == slot;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSlot = slot;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (slot.discount != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${slot.discount!.toInt()}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              slot.shortTimeRange,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected 
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'By proceeding further you agree to our service Terms and Conditions',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(ThemeData theme) {
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
        child: Row(
          children: [
            // Left side - Price and duration
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${widget.service.price}',
                    style: theme.textTheme.headlineSmall?.copyWith(
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
            
            // Right side - Checkout button
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: _selectedSlot != null 
                    ? () => _proceedToCheckout(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: _selectedSlot != null 
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: _selectedSlot != null 
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) async {
    if (_selectedSlot == null) return;
    
    final cartCubit = context.read<CartCubit>();
    
    try {
      await cartCubit.addToCart(service: widget.service, car: widget.car);
      
      if (context.mounted) {
        // Navigate back to home and show success
        Navigator.popUntil(context, (route) => route.isFirst);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.service.title} scheduled for ${_selectedSlot!.dayLabel} ${_selectedSlot!.timeRange}',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.only(
              bottom: 120, // Just above the cart bar
              left: 16,
              right: 16,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule service: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              bottom: 120, // Just above the cart bar
              left: 16,
              right: 16,
            ),
          ),
        );
      }
    }
  }
}
