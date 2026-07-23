import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/domain/use_cases/app_use_case.dart';
import 'package:soccer/di/environment/app_config.dart';
import 'package:soccer/presentation/common/widgets/app_button.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';
import 'package:soccer/presentation/common/widgets/app_feedback.dart';
import 'package:soccer/presentation/common/widgets/base_screen.dart';
import 'package:soccer/presentation/screens/bookings/ui/my_bookings_screen.dart';
import 'package:soccer/presentation/screens/venues/ui/venue_detail_screen.dart';
import 'package:soccer/presentation/screens/owner/cubit/booking_status_cubit.dart';
import 'package:soccer/presentation/screens/owner/cubit/owner_dashboard_cubit.dart';
import 'package:soccer/presentation/screens/owner/cubit/owner_realtime_cubit.dart';
import 'package:soccer/presentation/screens/owner/cubit/venue_mutation_cubit.dart';
import 'package:soccer/presentation/screens/owner/state/booking_status_state.dart';
import 'package:soccer/presentation/screens/owner/state/owner_dashboard_state.dart';
import 'package:soccer/presentation/screens/owner/state/owner_realtime_state.dart';
import 'package:soccer/presentation/screens/owner/state/owner_state.dart';
import 'package:soccer/presentation/screens/owner/state/venue_mutation_state.dart';
import 'package:soccer/presentation/screens/owner/ui/venue_dialog.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<OwnerDashboardCubit>()),
        BlocProvider(
          create: (context) => OwnerRealtimeCubit(
            useCase: context.read<AppUseCase>(),
            config: context.read<AppConfig>(),
            sessionCubit: context.read<AppSessionCubit>(),
            dashboardCubit: context.read<OwnerDashboardCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => BookingStatusCubit(
            useCase: context.read<AppUseCase>(),
            dashboardCubit: context.read<OwnerDashboardCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => VenueMutationCubit(
            useCase: context.read<AppUseCase>(),
            dashboardCubit: context.read<OwnerDashboardCubit>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OwnerRealtimeCubit, OwnerRealtimeState>(
            listener: (context, state) {
              final failure = state.failureOrNull;
              if (failure != null) {
                AppToast.failure(context, failure);
              }
            },
          ),
          BlocListener<BookingStatusCubit, BookingStatusState>(
            listener: (context, state) {
              if (state.isSuccess && state.dataOrNull != null) {
                AppToast.success(context, 'Cập nhật trạng thái thành công');
              }
              final failure = state.failureOrNull;
              if (failure != null) {
                AppToast.failure(context, failure);
              }
            },
          ),
          BlocListener<VenueMutationCubit, VenueMutationState>(
            listener: (context, state) {
              if (state.isSuccess && state.dataOrNull != null) {
                AppToast.success(context, 'Đã cập nhật cụm sân');
              }
              final failure = state.failureOrNull;
              if (failure != null) {
                AppToast.failure(context, failure);
              }
            },
          ),
        ],
        child: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
          builder: (context, dashboardState) {
            final statusState = context.watch<BookingStatusCubit>().state;
            final venueMutationState = context
                .watch<VenueMutationCubit>()
                .state;
            final realtimeState = context.watch<OwnerRealtimeCubit>().state;

            return BaseAsyncScreen<OwnerDashboardData>(
              title: 'Quản lý',
              value: dashboardState,
              onRetry: () => context.read<OwnerDashboardCubit>().load(),
              onRefresh: () => context.read<OwnerDashboardCubit>().load(),
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
                  onPressed: () => context.read<OwnerDashboardCubit>().load(),
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
                    _RealtimeStatusPill(state: realtimeState),
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
                                          confirmDeleteVenue(context, venue);
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
                                  isLoading:
                                      statusState.isLoading && canConfirm,
                                  onPressed: canConfirm
                                      ? () => _update(
                                          context,
                                          booking.id,
                                          'CONFIRMED',
                                        )
                                      : null,
                                ),
                                AppButton.outlined(
                                  label: 'Hoàn tất',
                                  icon: const Icon(Icons.done_all),
                                  onPressed: booking.status == 'CONFIRMED'
                                      ? () => _update(
                                          context,
                                          booking.id,
                                          'COMPLETED',
                                        )
                                      : null,
                                ),
                                AppButton.destructive(
                                  label: 'Huỷ',
                                  icon: const Icon(Icons.close),
                                  onPressed: booking.status == 'PENDING'
                                      ? () => _update(
                                          context,
                                          booking.id,
                                          'CANCELLED',
                                        )
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
          },
        ),
      ),
    );
  }

  void _update(BuildContext context, String bookingId, String status) {
    context.read<BookingStatusCubit>().update(
      bookingId: bookingId,
      status: status,
    );
  }
}

enum _VenueAction { edit, delete }

class _RealtimeStatusPill extends StatelessWidget {
  const _RealtimeStatusPill({required this.state});

  final OwnerRealtimeState state;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      OwnerRealtimeConnecting() => ('Đang kết nối realtime', AppColors.amber),
      OwnerRealtimeFailure() => ('Realtime lỗi', AppColors.coral),
      _ => ('Realtime đã bật', AppColors.teal),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: AppStatusPill(label: label, color: color),
    );
  }
}
