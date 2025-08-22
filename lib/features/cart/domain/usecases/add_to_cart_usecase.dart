import 'package:injectable/injectable.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';
import '../../../profile/domain/usecases/get_user_profile_usecase.dart';

/// Use case for adding an item to the cart
@injectable
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(CartItem item) async {
    await repository.addItem(item);
  }
}

/// Use case for creating a booking from cart items
@injectable
class CreateBookingUseCase {
  final BookingRepository bookingRepository;
  final CartRepository cartRepository;

  CreateBookingUseCase({
    required this.bookingRepository,
    required this.cartRepository,
  });

  /// Create a booking from current cart
  Future<Booking> call({
    required String userId,
    String? paymentId,
    String? notes,
  }) async {
    // Get current cart
    final cart = await cartRepository.getCart();

    if (cart.isEmpty) {
      throw Exception('Cannot create booking: Cart is empty');
    }

    // Create booking
    final booking = await bookingRepository.createBooking(
      userId: userId,
      items: cart.items,
      totalPrice: cart.totalPrice,
      paymentId: paymentId,
      notes: notes,
    );

    // Clear cart after successful booking
    await cartRepository.clearCart();

    return booking;
  }
}

/// Checkout result with success/failure information
class CheckoutResult {
  final bool isSuccess;
  final String? message;
  final Booking? booking;
  final CheckoutFailureReason? failureReason;

  const CheckoutResult._({
    required this.isSuccess,
    this.message,
    this.booking,
    this.failureReason,
  });

  factory CheckoutResult.success(Booking booking) {
    return CheckoutResult._(
      isSuccess: true,
      booking: booking,
      message: 'Booking created successfully!',
    );
  }

  factory CheckoutResult.failure(CheckoutFailureReason reason, String message) {
    return CheckoutResult._(
      isSuccess: false,
      failureReason: reason,
      message: message,
    );
  }
}

/// Types of checkout failures
enum CheckoutFailureReason {
  emptyCart,
  incompleteProfile,
  paymentFailed,
  networkError,
  unknownError,
}

/// Use case for complete checkout process with simulation
@injectable
class CheckoutUseCase {
  final CheckProfileCompletionUseCase checkProfileUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final CartRepository cartRepository;

  CheckoutUseCase({
    required this.checkProfileUseCase,
    required this.createBookingUseCase,
    required this.cartRepository,
  });

  /// Execute complete checkout process
  Future<CheckoutResult> call({
    required String userId,
    String? notes,
    bool simulatePaymentFailure = false,
  }) async {
    try {
      // 1. Check if cart has items
      final cart = await cartRepository.getCart();
      if (cart.isEmpty) {
        return CheckoutResult.failure(
          CheckoutFailureReason.emptyCart,
          'Your cart is empty. Please add items before checkout.',
        );
      }

      // 2. Validate profile completion
      final profileResult = await checkProfileUseCase(userId);

      return profileResult.fold(
            (failure) => CheckoutResult.failure(
              CheckoutFailureReason.networkError,
              'Unable to verify profile completion: ${failure.message}',
            ),
            (isProfileComplete) {
              if (!isProfileComplete) {
                return CheckoutResult.failure(
                  CheckoutFailureReason.incompleteProfile,
                  'Please complete your profile before proceeding with checkout.',
                );
              }
              return null; // Continue to next step
            },
          ) ??
          await _processPaymentAndBooking(
            cart,
            userId,
            notes,
            simulatePaymentFailure,
          );
    } catch (e) {
      return CheckoutResult.failure(
        CheckoutFailureReason.networkError,
        'Network error occurred during checkout: ${e.toString()}',
      );
    }
  }

  /// Process payment and booking creation
  Future<CheckoutResult> _processPaymentAndBooking(
    Cart cart,
    String userId,
    String? notes,
    bool simulatePaymentFailure,
  ) async {
    try {
      // 3. Simulate payment processing
      final paymentResult = await _simulatePayment(
        cart.totalPrice,
        simulateFailure: simulatePaymentFailure,
      );

      if (!paymentResult.isSuccess) {
        return CheckoutResult.failure(
          CheckoutFailureReason.paymentFailed,
          paymentResult.message ?? 'Payment processing failed.',
        );
      }

      // 4. Create booking
      final booking = await createBookingUseCase(
        userId: userId,
        paymentId: paymentResult.paymentId,
        notes: notes,
      );

      return CheckoutResult.success(booking);
    } catch (e) {
      return CheckoutResult.failure(
        CheckoutFailureReason.networkError,
        'Error creating booking: ${e.toString()}',
      );
    }
  }

  /// Simulate payment processing with configurable success/failure
  Future<PaymentResult> _simulatePayment(
    double amount, {
    bool simulateFailure = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (simulateFailure) {
      return PaymentResult.failure(
        'Payment declined. Please try a different payment method.',
      );
    }

    // Generate mock payment ID
    final paymentId = 'pay_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentResult.success(paymentId);
  }
}

/// Payment processing result
class PaymentResult {
  final bool isSuccess;
  final String? message;
  final String? paymentId;

  const PaymentResult._({
    required this.isSuccess,
    this.message,
    this.paymentId,
  });

  factory PaymentResult.success(String paymentId) {
    return PaymentResult._(
      isSuccess: true,
      paymentId: paymentId,
      message: 'Payment processed successfully',
    );
  }

  factory PaymentResult.failure(String message) {
    return PaymentResult._(isSuccess: false, message: message);
  }
}
