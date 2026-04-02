import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ride_sharing/feature/driver/homepage/controller/driver_home_controller.dart';
import 'package:ride_sharing/feature/driver/trip_flow/view/trip_completion_payment_dialogs.dart';
import 'package:ride_sharing/services/socket_services.dart';

// ---------------------------------------------------------------------------
// Minimal mock — captures the incompleted-ride handler so we can trigger it,
// and records emitConfirmPayment calls for assertion.
// ---------------------------------------------------------------------------
class MockSocketIoService extends SocketIoService {
  @override
  final RxBool isConnected = true.obs;
  @override
  bool get isSocketReady => true;

  Function(dynamic)? _incompletedRideHandler;

  /// Recorded rideId from the last emitConfirmPayment call.
  String? lastConfirmedRideId;

  // ── listeners the controller registers ────────────────────────────────────
  @override
  void onIncompletedRide(Function(dynamic) handler) {
    _incompletedRideHandler = handler;
  }

  @override
  void offIncompletedRide() => _incompletedRideHandler = null;

  // no-ops — controller registers these but we don't need them for this test
  @override
  void onRideRequest(Function(dynamic) _) {}
  @override
  void onRideAccepted(Function(dynamic) _) {}
  @override
  void onRidePickedUp(Function(dynamic) _) {}
  @override
  void onPaymentConfirmed(Function(dynamic) _) {}

  @override
  Future<void> connect() async {}

  // ── emits ─────────────────────────────────────────────────────────────────
  @override
  Future<void> emitConfirmPayment({required String rideId}) async {
    lastConfirmedRideId = rideId;
  }

  // ── test helper ───────────────────────────────────────────────────────────
  /// Simulates the server firing the incompleted-ride socket event.
  void triggerIncompletedRide(Map<String, dynamic> data) {
    _incompletedRideHandler?.call(data);
  }
}

// ---------------------------------------------------------------------------
// Shared test payload
// ---------------------------------------------------------------------------
// Matches the real server incompleted-ride payload shape
const _completedUnpaidPayload = {
  '_id': 'ride-abc-123',
  'status': 'COMPLETED',
  'isPaymentCompleted': false,
  'paymentMethod': 'CASH',
  'riderId': 'rider-xyz',
  'driverId': 'driver-xyz',
  'distance': 10.42,
  'fare': 27.67,
  'pickUp': {'name': '43, Mohakhali C/A, Dhaka', 'coordinates': [90.4, 23.78]},
  'destination': {'name': 'Ibn Sina Hospital', 'coordinates': [90.36, 23.77]},
};

// ---------------------------------------------------------------------------
// Helper — pumps a minimal GetMaterialApp that hosts the driver controller.
// ---------------------------------------------------------------------------
Future<void> _pumpDriverApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      // Match the default Flutter test viewport so ScreenUtil scaling factor
      // is 1.0 and dialog sizes stay predictable.
      designSize: const Size(800, 600),
      child: GetMaterialApp(
        home: Scaffold(
          body: GetBuilder<DriverHomeScreenController>(
            init: DriverHomeScreenController(),
            builder: (_) => const SizedBox(),
          ),
        ),
      ),
    ),
  );
  // Let all async onInit tasks (socket setup, map init, etc.) settle.
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late MockSocketIoService mockSocket;

  setUp(() async {
    Get.reset();

    SharedPreferences.setMockInitialValues({
      'accessToken': 'fake_driver_token_for_testing',
    });

    mockSocket = MockSocketIoService();
    Get.put<SocketIoService>(mockSocket, permanent: true);

    // Dialogs rendered in a test viewport overflow at 800x600.
    // Suppress overflow errors so async callbacks inside dialog actions
    // can complete before assertions run.
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      FlutterError.presentError(details);
    };
  });

  tearDown(() {
    FlutterError.onError = FlutterError.presentError;
    Get.reset();
  });

  // ── 1 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'shows PaymentConfirmationDialog when status is COMPLETED and payment is not completed',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide(_completedUnpaidPayload);
      await tester.pumpAndSettle();

      expect(
        find.text('Did you receive the payment for this trip?'),
        findsOneWidget,
      );
      expect(find.text('Yes, payment received'), findsOneWidget);
      expect(find.text('No, or received\ndifferent amount'), findsOneWidget);
    },
  );

  // ── 2 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'does NOT show dialog when isPaymentCompleted is true',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide({
        ..._completedUnpaidPayload,
        'isPaymentCompleted': true,
      });
      await tester.pumpAndSettle();

      expect(
        find.text('Did you receive the payment for this trip?'),
        findsNothing,
      );
    },
  );

  // ── 3 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'does NOT show dialog when status is not COMPLETED',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide({
        ..._completedUnpaidPayload,
        'status': 'ONGOING',
      });
      await tester.pumpAndSettle();

      expect(
        find.text('Did you receive the payment for this trip?'),
        findsNothing,
      );
    },
  );

  // ── 4 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'tapping "Yes, payment received" emits confirm-payment with the correct rideId',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide(_completedUnpaidPayload);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes, payment received'));
      await tester.pumpAndSettle();

      expect(mockSocket.lastConfirmedRideId, equals('ride-abc-123'));
    },
  );

  // ── 5 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'shows TripCompletionDialog after tapping "Yes, payment received"',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide(_completedUnpaidPayload);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes, payment received'));
      await tester.pumpAndSettle();

      expect(
        find.text("Congratulations, you've completed another trip."),
        findsOneWidget,
      );
    },
  );

  // ── 6 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'shows StayOnlineDialog after tapping "Back to Home" on TripCompletionDialog',
    (tester) async {
      // StayOnlineDialog needs more vertical space — give it a taller surface.
      await tester.binding.setSurfaceSize(const Size(800, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide(_completedUnpaidPayload);
      await tester.pumpAndSettle();

      // PaymentConfirmationDialog → yes
      await tester.tap(find.text('Yes, payment received'));
      await tester.pumpAndSettle();

      // TripCompletionDialog → back to home
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();

      expect(find.text('Keep online,'), findsOneWidget);
      expect(find.text('Stay online'), findsOneWidget);
      expect(find.text('Go offline'), findsOneWidget);
    },
  );

  // ── 7 ─────────────────────────────────────────────────────────────────────
  testWidgets(
    'tapping "No, or received different amount" dismisses the dialog without emitting confirm-payment',
    (tester) async {
      await _pumpDriverApp(tester);

      mockSocket.triggerIncompletedRide(_completedUnpaidPayload);
      await tester.pumpAndSettle();

      await tester.tap(find.text('No, or received\ndifferent amount'));
      await tester.pumpAndSettle();

      expect(mockSocket.lastConfirmedRideId, isNull);
      expect(
        find.text('Did you receive the payment for this trip?'),
        findsNothing,
      );
    },
  );
}
