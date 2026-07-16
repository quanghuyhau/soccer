import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/data/models/request/booking_request.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/data/models/response/pitch_price_response.dart';
import 'package:soccer/presentation/common/app_scaffold_widget.dart';
import 'package:soccer/presentation/common/appbar/base_app_bar_widget.dart';
import 'package:soccer/presentation/common/loading/loading.dart';
import 'package:soccer/presentation/common/toast/toast_widget.dart';
import 'package:soccer/presentation/common/dialog/custom_dialog_widget.dart';
import 'package:soccer/presentation/screens/pitch_detail/cubit/pitch_detail_cubit.dart';
import 'package:soccer/utilities/style/style.dart';
import 'package:intl/intl.dart';

class PitchDetailScreen extends StatefulWidget {
  final PitchResponse pitch;
  const PitchDetailScreen({super.key, required this.pitch});

  @override
  State<PitchDetailScreen> createState() => _PitchDetailScreenState();
}

class _PitchDetailScreenState extends State<PitchDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late PitchDetailCubit _cubit;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 30);

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PitchDetailCubit>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppScaffold(
      appBar: BaseAppBar(
        title: widget.pitch.name ?? 'Chi tiết sân',
      ),
      body: BlocListener<PitchDetailCubit, PitchDetailState>(
        listener: (context, state) {
          if (state is PitchDetailLoaded) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: theme.color.red300,
                ),
              );
              _cubit.clearBookingResult();
            } else if (state.latestBooking != null) {
              final booking = state.latestBooking!;
              showCustomDialog(
                context: context,
                title: 'Đặt sân thành công!',
                message: 'Mã đặt sân: ${booking.id?.substring(0, 8)}\n'
                    'Sân: ${booking.pitchName}\n'
                    'Thời gian: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(booking.startTime!))} - '
                    '${DateFormat('HH:mm').format(DateTime.parse(booking.endTime!))}\n'
                    'Tổng tiền: ${NumberFormat('#,###').format(booking.totalPrice ?? 0)} VNĐ\n'
                    'Trạng thái: ${booking.status}',
                tileActiveButton: 'XÁC NHẬN',
                onPressActiveButton: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // Go back to pitch list
                },
              );
              _cubit.clearBookingResult();
            }
          }
        },
        child: BlocBuilder<PitchDetailCubit, PitchDetailState>(
          builder: (context, state) {
            if (state is PitchDetailLoading) {
              return const Center(child: AppLoading());
            }

            if (state is PitchDetailError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.font.body.copyWith(color: theme.color.b100),
                ),
              );
            }

            if (state is PitchDetailLoaded) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPitchInfo(),
                    const SizedBox(height: 24),
                    _buildPricingTable(state.prices),
                    const SizedBox(height: 24),
                    _buildBookingForm(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.color.green300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _onBookPressed(state),
                      child: Text(
                        'XÁC NHẬN ĐẶT SÂN',
                        style: theme.font.bodyBold.copyWith(color: theme.color.b900),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPitchInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.color.b800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.pitch.name ?? 'Sân không tên',
            style: theme.font.title.copyWith(color: theme.color.b20),
          ),
          if (widget.pitch.venueName != null) ...[
            const SizedBox(height: 4),
            Text(
              'Thuộc cụm: ${widget.pitch.venueName}',
              style: theme.font.body.copyWith(color: theme.color.b100),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Loại sân: Sân ${widget.pitch.type ?? "5"} người | Kích thước: ${widget.pitch.size ?? "N/A"} | Mặt sân: ${widget.pitch.surface ?? "Cỏ nhân tạo"}',
            style: theme.font.note.copyWith(color: theme.color.b100),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTable(List<PitchPriceResponse> prices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bảng giá khung giờ',
          style: theme.font.subTitleBold.copyWith(color: theme.color.b20),
        ),
        const SizedBox(height: 8),
        if (prices.isEmpty)
          Text(
            'Chưa có bảng giá được cấu hình cho sân này.',
            style: theme.font.body.copyWith(color: theme.color.b100),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: theme.color.b800,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prices.length,
              separatorBuilder: (context, index) => Divider(color: theme.color.b900, height: 1),
              itemBuilder: (context, index) {
                final price = prices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, color: theme.color.green300, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${price.startTime} - ${price.endTime}',
                            style: theme.font.body.copyWith(color: theme.color.b20),
                          ),
                        ],
                      ),
                      Text(
                        '${NumberFormat('#,###').format(price.pricePerHour ?? 0)} đ/giờ',
                        style: theme.font.subTitleBold.copyWith(color: theme.color.green300),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBookingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin đặt lịch',
          style: theme.font.subTitleBold.copyWith(color: theme.color.b20),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          style: theme.font.body.copyWith(color: theme.color.b20),
          decoration: _inputDecoration('Tên người đặt *'),
          validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: theme.font.body.copyWith(color: theme.color.b20),
          decoration: _inputDecoration('Số điện thoại liên hệ *'),
          validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _noteController,
          style: theme.font.body.copyWith(color: theme.color.b20),
          decoration: _inputDecoration('Ghi chú (Ví dụ: đặt áo pitch, bóng...)'),
        ),
        const SizedBox(height: 16),
        _buildDateTimeSelectors(),
      ],
    );
  }

  Widget _buildDateTimeSelectors() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Chọn ngày đặt sân:',
            style: theme.font.body.copyWith(color: theme.color.b100),
          ),
          trailing: TextButton.icon(
            icon: Icon(Icons.calendar_today, color: theme.color.green300),
            label: Text(
              DateFormat('dd/MM/yyyy').format(_selectedDate),
              style: theme.font.subTitleBold.copyWith(color: theme.color.green300),
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Giờ bắt đầu:',
            style: theme.font.body.copyWith(color: theme.color.b100),
          ),
          trailing: TextButton(
            child: Text(
              _startTime.format(context),
              style: theme.font.subTitleBold.copyWith(color: theme.color.green300),
            ),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _startTime,
              );
              if (time != null) {
                setState(() => _startTime = time);
              }
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Giờ kết thúc:',
            style: theme.font.body.copyWith(color: theme.color.b100),
          ),
          trailing: TextButton(
            child: Text(
              _endTime.format(context),
              style: theme.font.subTitleBold.copyWith(color: theme.color.green300),
            ),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _endTime,
              );
              if (time != null) {
                setState(() => _endTime = time);
              }
            },
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: theme.font.body.copyWith(color: theme.color.b100),
      filled: true,
      fillColor: theme.color.b800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _onBookPressed(PitchDetailLoaded state) {
    if (!_formKey.currentState!.validate()) return;

    // Combine Date and Time
    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Giờ kết thúc phải lớn hơn giờ bắt đầu!'),
          backgroundColor: theme.color.red300,
        ),
      );
      return;
    }

    final request = BookingRequest(
      pitchId: widget.pitch.id ?? '',
      customerName: _nameController.text,
      customerPhone: _phoneController.text,
      startTime: startDateTime.toIso8601String(),
      endTime: endDateTime.toIso8601String(),
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
    );

    _cubit.submitBooking(request);
  }
}
