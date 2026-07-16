import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/presentation/common/app_scaffold_widget.dart';
import 'package:soccer/presentation/common/appbar/base_app_bar_widget.dart';
import 'package:soccer/presentation/common/loading/loading.dart';
import 'package:soccer/presentation/common/empty/empty_widget.dart';
import 'package:soccer/presentation/screens/my_bookings/cubit/my_bookings_cubit.dart';
import 'package:soccer/utilities/style/style.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late MyBookingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MyBookingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppScaffold(
      appBar: const BaseAppBar(
        title: 'Sân bóng đã đặt',
      ),
      body: BlocListener<MyBookingsCubit, MyBookingsState>(
        listener: (context, state) {
          if (state is MyBookingsLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.color.red300,
              ),
            );
            _cubit.clearError();
          }
        },
        child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: AppLoading());
            }

            if (state is MyBookingsError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.font.body.copyWith(color: theme.color.b100),
                ),
              );
            }

            if (state is MyBookingsLoaded) {
              final bookings = state.bookings;
              if (bookings.isEmpty) {
                return const Center(child: EmptyWidget());
              }

              return RefreshIndicator(
                onRefresh: _cubit.fetchMyBookings,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final start = DateTime.parse(booking.startTime!);
                    final end = DateTime.parse(booking.endTime!);

                    return Card(
                      color: theme.color.b800,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  booking.pitchName ?? 'Sân không tên',
                                  style: theme.font.subTitleBold.copyWith(color: theme.color.b20),
                                ),
                                _buildStatusBadge(booking.status ?? 'PENDING'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cụm sân: ${booking.venueName ?? ""}',
                              style: theme.font.note.copyWith(color: theme.color.b100),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Người đặt: ${booking.customerName ?? ""}',
                              style: theme.font.note.copyWith(color: theme.color.b100),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: theme.color.green300),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(start),
                                  style: theme.font.body.copyWith(color: theme.color.b20),
                                ),
                                const Spacer(),
                                Icon(Icons.access_time, size: 16, color: theme.color.green300),
                                const SizedBox(width: 6),
                                Text(
                                  '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}',
                                  style: theme.font.body.copyWith(color: theme.color.b20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng thanh toán:',
                                      style: theme.font.note.copyWith(color: theme.color.b100),
                                    ),
                                    Text(
                                      '${NumberFormat('#,###').format(booking.totalPrice ?? 0)} VNĐ',
                                      style: theme.font.subTitleBold.copyWith(color: theme.color.green300),
                                    ),
                                  ],
                                ),
                                if (booking.status == 'PENDING')
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: theme.color.red300),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () => _cubit.cancelBooking(booking.id ?? ''),
                                    child: Text(
                                      'HỦY LỊCH',
                                      style: theme.font.bodyBold.copyWith(color: theme.color.red300, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        color = theme.color.green300;
        label = 'Đã Xác Nhận';
        break;
      case 'CANCELLED':
        color = theme.color.red300;
        label = 'Đã Hủy';
        break;
      case 'COMPLETED':
        color = Colors.blue;
        label = 'Hoàn Thành';
        break;
      default:
        color = Colors.orange;
        label = 'Chờ Xác Nhận';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        label,
        style: theme.font.note.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
