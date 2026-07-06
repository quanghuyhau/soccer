import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/base_screen.dart';
import 'bookings_controller.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsState = ref.watch(myBookingsControllerProvider);

    return BaseAsyncScreen<List<Booking>>(
      title: 'Lịch đặt của tôi',
      value: bookingsState,
      onRetry: () => ref.invalidate(myBookingsControllerProvider),
      actions: [
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () => ref.invalidate(myBookingsControllerProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
      data: (bookings) {
        final pending = bookings
            .where((booking) => booking.status == 'PENDING')
            .length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AppHeroPanel(
              title: 'Lịch đặt của tôi',
              subtitle: 'Theo dõi lịch và trạng thái đặt sân',
              icon: Icons.event_available,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Tổng booking',
                    value: bookings.length.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.pending_actions,
                    label: 'Đang chờ',
                    value: pending.toString(),
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (bookings.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Chưa có booking'),
                ),
              )
            else
              ...bookings.map(
                (booking) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookingCard(booking: booking),
                ),
              ),
          ],
        );
      },
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.event_note, color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.pitchName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(booking.venueName),
                    ],
                  ),
                ),
                AppStatusPill(label: booking.status, color: statusColor),
              ],
            ),
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
