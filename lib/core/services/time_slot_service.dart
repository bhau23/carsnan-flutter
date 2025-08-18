import 'dart:math';
import '../models/time_slot.dart';

class TimeSlotService {
  static const int _workingStartHour = 6; // 6 AM
  static const int _workingEndHour = 18; // 6 PM
  static const int _slotDurationHours = 1;

  /// Generate available time slots for the next 5 days
  List<TimeSlot> getAvailableSlots() {
    final List<TimeSlot> slots = [];
    final now = DateTime.now();
    
    for (int dayOffset = 0; dayOffset < 5; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));
      final daySlots = _generateSlotsForDate(date);
      slots.addAll(daySlots);
    }
    
    return slots;
  }

  /// Get slots for a specific date
  List<TimeSlot> getSlotsForDate(DateTime date) {
    return _generateSlotsForDate(date);
  }

  /// Get slots for today
  List<TimeSlot> getTodaySlots() {
    return getSlotsForDate(DateTime.now());
  }

  /// Get slots for tomorrow
  List<TimeSlot> getTomorrowSlots() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return getSlotsForDate(tomorrow);
  }

  /// Get available dates (today + next 4 days)
  List<DateTime> getAvailableDates() {
    final List<DateTime> dates = [];
    final now = DateTime.now();
    
    for (int dayOffset = 0; dayOffset < 5; dayOffset++) {
      final date = now.add(Duration(days: dayOffset));
      dates.add(DateTime(date.year, date.month, date.day));
    }
    
    return dates;
  }

  /// Generate slots for a specific date with sample availability
  List<TimeSlot> _generateSlotsForDate(DateTime date) {
    final List<TimeSlot> slots = [];
    final random = Random(date.day + date.month + date.year); // Consistent random for same date
    final now = DateTime.now();
    
    for (int hour = _workingStartHour; hour < _workingEndHour; hour++) {
      final slotDate = DateTime(date.year, date.month, date.day);
      final slotStartTime = DateTime(date.year, date.month, date.day, hour);
      
      // Skip past slots for today
      bool isAvailable = true;
      double? discount;
      
      if (date.day == now.day && date.month == now.month && date.year == now.year) {
        // For today, skip past hours
        if (slotStartTime.isBefore(now.add(const Duration(hours: 1)))) {
          isAvailable = false;
        } else {
          // Random availability for today (70% chance)
          isAvailable = random.nextDouble() > 0.3;
        }
      } else {
        // For future days, more availability (85% chance)
        isAvailable = random.nextDouble() > 0.15;
        
        // Add random discounts for some slots
        if (isAvailable && random.nextDouble() > 0.8) {
          discount = random.nextDouble() > 0.5 ? 10.0 : 15.0;
        }
      }

      final slot = TimeSlot(
        date: slotDate,
        startHour: hour,
        endHour: hour + _slotDurationHours,
        isAvailable: isAvailable,
        discount: discount,
      );

      slots.add(slot);
    }
    
    return slots;
  }

  /// Get count of available slots for a date
  int getAvailableSlotCount(DateTime date) {
    final slots = getSlotsForDate(date);
    return slots.where((slot) => slot.isAvailable).length;
  }

  /// Check if a specific slot is available
  bool isSlotAvailable(DateTime date, int startHour) {
    final slots = getSlotsForDate(date);
    final slot = slots.firstWhere(
      (s) => s.startHour == startHour,
      orElse: () => TimeSlot(date: date, startHour: startHour, endHour: startHour + 1, isAvailable: false),
    );
    return slot.isAvailable;
  }
}
