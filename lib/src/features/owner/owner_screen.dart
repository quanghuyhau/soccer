import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_state_views.dart';
import '../bookings/my_bookings_screen.dart';
import 'owner_controller.dart';

class OwnerScreen extends ConsumerWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(ownerDashboardControllerProvider);
    final statusState = ref.watch(bookingStatusControllerProvider);

    ref.listen(bookingStatusControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (booking) {
          if (booking != null && previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật trạng thái thành công')),
            );
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () => ref.invalidate(ownerDashboardControllerProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: dashboardState.when(
          data: (dashboard) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Cụm sân của tôi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (dashboard.venues.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Chưa có cụm sân'),
                    ),
                  )
                else
                  ...dashboard.venues.map(
                    (venue) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.stadium),
                        title: Text(venue.name),
                        subtitle: Text(venue.address),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Booking cần xử lý',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (dashboard.bookings.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Chưa có booking'),
                    ),
                  )
                else
                  ...dashboard.bookings.map((booking) {
                    final canConfirm = booking.status == 'PENDING';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BookingCard(
                        booking: booking,
                        trailing: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            AppButton.primary(
                              label: 'Xác nhận',
                              icon: const Icon(Icons.check),
                              isLoading: statusState.isLoading && canConfirm,
                              onPressed: canConfirm
                                  ? () => _update(ref, booking.id, 'CONFIRMED')
                                  : null,
                            ),
                            AppButton.outlined(
                              label: 'Hoàn tất',
                              icon: const Icon(Icons.done_all),
                              onPressed: booking.status == 'CONFIRMED'
                                  ? () => _update(ref, booking.id, 'COMPLETED')
                                  : null,
                            ),
                            AppButton.destructive(
                              label: 'Huỷ',
                              icon: const Icon(Icons.close),
                              onPressed: booking.status == 'PENDING'
                                  ? () => _update(ref, booking.id, 'CANCELLED')
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
          error: (error, stackTrace) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(ownerDashboardControllerProvider),
          ),
          loading: () => const AppLoadingView(),
        ),
      ),
    );
  }

  void _update(WidgetRef ref, String bookingId, String status) {
    ref
        .read(bookingStatusControllerProvider.notifier)
        .update(bookingId: bookingId, status: status);
  }
}
