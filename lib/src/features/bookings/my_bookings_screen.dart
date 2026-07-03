import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_state_views.dart';
import 'bookings_controller.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(myBookingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch đặt của tôi'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () => ref.invalidate(myBookingsControllerProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: bookingsState.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return const Center(child: Text('Chưa có booking'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return BookingCard(booking: bookings[index]);
              },
            );
          },
          error: (error, stackTrace) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(myBookingsControllerProvider),
          ),
          loading: () => const AppLoadingView(),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.trailing});

  final Booking booking;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final statusColor = AppFormatters.statusColor(context, booking.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    booking.pitchName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(booking.status),
                  side: BorderSide(color: statusColor),
                  labelStyle: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(booking.venueName),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${AppFormatters.dateTime(booking.startTime)}'
                    ' - ${AppFormatters.time(booking.endTime)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18),
                const SizedBox(width: 8),
                Text(AppFormatters.money(booking.totalPrice)),
              ],
            ),
            if (trailing != null) ...[const SizedBox(height: 12), trailing!],
          ],
        ),
      ),
    );
  }
}
