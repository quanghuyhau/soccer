import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/base_screen.dart';
import '../bookings/my_bookings_screen.dart';
import '../venues/venue_detail_screen.dart';
import 'owner_controller.dart';
import 'venue_dialog.dart';

class OwnerScreen extends ConsumerWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(ownerDashboardControllerProvider);
    final statusState = ref.watch(bookingStatusControllerProvider);
    final venueMutationState = ref.watch(venueMutationControllerProvider);

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

    ref.listen(venueMutationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (value) {
          if (value != null && previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật cụm sân')),
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

    return BaseAsyncScreen<OwnerDashboardData>(
      title: 'Quản lý',
      value: dashboardState,
      onRetry: () => ref.invalidate(ownerDashboardControllerProvider),
      onRefresh: () async => ref.invalidate(ownerDashboardControllerProvider),
      actions: [
        IconButton(
          tooltip: 'Thêm cụm sân',
          onPressed: venueMutationState.isLoading
              ? null
              : () => showVenueDialog(context: context),
          icon: const Icon(Icons.add_business),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () => ref.invalidate(ownerDashboardControllerProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
      data: (dashboard) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AppHeroPanel(
              title: 'Bảng điều hành',
              subtitle: 'Theo dõi sân và xử lý booking',
              icon: Icons.admin_panel_settings,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.stadium,
                    label: 'Cụm sân',
                    value: dashboard.venues.length.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.event_note,
                    label: 'Booking',
                    value: dashboard.bookings.length.toString(),
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Cụm sân của tôi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            AppButton.primary(
              label: 'Tạo cụm sân',
              icon: const Icon(Icons.add_business),
              isLoading: venueMutationState.isLoading,
              isExpanded: true,
              onPressed: () => showVenueDialog(context: context),
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
                (venue) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                VenueDetailScreen(venueId: venue.id),
                          ),
                        );
                      },
                      leading: const Icon(Icons.stadium),
                      title: Text(venue.name),
                      subtitle: Text(venue.address),
                      trailing: Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppStatusPill(
                            label: venue.status,
                            color: venue.status == 'ACTIVE'
                                ? AppColors.teal
                                : AppColors.coral,
                          ),
                          PopupMenuButton<_VenueAction>(
                            tooltip: 'Tuỳ chọn',
                            onSelected: (action) {
                              switch (action) {
                                case _VenueAction.edit:
                                  showVenueDialog(
                                    context: context,
                                    venue: venue,
                                  );
                                case _VenueAction.delete:
                                  confirmDeleteVenue(context, ref, venue);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: _VenueAction.edit,
                                child: Text('Sửa'),
                              ),
                              PopupMenuItem(
                                value: _VenueAction.delete,
                                child: Text('Xoá'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                          onPressed: canConfirm ? () => _update(ref, booking.id, 'CONFIRMED') : null,
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
    );
  }

  void _update(WidgetRef ref, String bookingId, String status) {
    ref.read(bookingStatusControllerProvider.notifier).update(bookingId: bookingId, status: status);
  }
}

enum _VenueAction { edit, delete }
