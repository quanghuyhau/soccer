import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../core/error/app_exception.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/base_screen.dart';
import 'bookings_controller.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  const CreateBookingScreen({
    super.key,
    required this.venue,
    required this.pitch,
    this.prices = const [],
  });

  final Venue venue;
  final Pitch pitch;
  final List<PitchPrice> prices;

  @override
  ConsumerState<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _dateController = TextEditingController(
    text: AppFormatters.date(DateTime.now()),
  );
  final _startController = TextEditingController(text: '18:00');
  final _endController = TextEditingController(text: '19:30');
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(appSessionProvider)?.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createBookingControllerProvider);
    final preview = _previewPrice();

    ref.listen(createBookingControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (booking) {
          if (booking == null || previous?.isLoading != true) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đặt sân thành công')));
          Navigator.of(context).pop();
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
        },
      );
    });

    return BaseScreen(
      title: 'Tạo booking',
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppHeroPanel(
            title: widget.pitch.name,
            subtitle: widget.venue.name,
            icon: Icons.add_task,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _field(_nameController, 'Tên khách hàng', Icons.person),
                  _field(_phoneController, 'Số điện thoại', Icons.phone),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          _dateController,
                          'Ngày',
                          Icons.today,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _startController,
                          'Bắt đầu',
                          Icons.schedule,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  _field(
                    _endController,
                    'Kết thúc',
                    Icons.schedule_send,
                    onChanged: (_) => setState(() {}),
                  ),
                  _PricePreviewCard(preview: preview, prices: widget.prices),
                  _field(_noteController, 'Ghi chú', Icons.notes, maxLines: 3),
                  const SizedBox(height: 4),
                  AppButton.primary(
                    label: 'Xác nhận đặt sân',
                    icon: const Icon(Icons.check_circle_outline),
                    isLoading: createState.isLoading,
                    isExpanded: true,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField(
        controller: controller,
        label: label,
        icon: icon,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  void _submit() {
    final date = _dateController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    final startTime = _dateTimeAt(date, start);
    final endTime = _dateTimeAt(date, end);

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thời gian không hợp lệ')));
      return;
    }

    if (!endTime.isAfter(startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ kết thúc phải sau giờ bắt đầu')),
      );
      return;
    }

    ref
        .read(createBookingControllerProvider.notifier)
        .create(
          CreateBookingRequest(
            pitchId: widget.pitch.id,
            customerName: _nameController.text.trim(),
            customerPhone: _phoneController.text.trim(),
            startTime: startTime,
            endTime: endTime,
            note: _noteController.text.trim(),
          ),
        );
  }

  _PricePreview _previewPrice() {
    final date = _dateController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    final startTime = _dateTimeAt(date, start);
    final endTime = _dateTimeAt(date, end);

    if (widget.prices.isEmpty) {
      return const _PricePreview(
        message: 'Sân này chưa có bảng giá. Backend sẽ báo lỗi nếu đặt ngay.',
      );
    }

    if (startTime == null || endTime == null || !endTime.isAfter(startTime)) {
      return const _PricePreview(message: 'Chọn thời gian hợp lệ để xem giá.');
    }

    var total = 0.0;
    var coveredMinutes = 0;

    for (final price in widget.prices) {
      final priceStart = _dateTimeAt(date, price.startTime);
      var priceEnd = _dateTimeAt(date, price.endTime);

      if (priceStart == null || priceEnd == null) {
        continue;
      }

      if (!priceEnd.isAfter(priceStart)) {
        priceEnd = priceEnd.add(const Duration(days: 1));
      }

      final overlapStart = startTime.isAfter(priceStart)
          ? startTime
          : priceStart;
      final overlapEnd = endTime.isBefore(priceEnd) ? endTime : priceEnd;

      if (!overlapEnd.isAfter(overlapStart)) {
        continue;
      }

      final minutes = overlapEnd.difference(overlapStart).inMinutes;
      coveredMinutes += minutes;
      total += minutes / 60 * price.pricePerHour;
    }

    final bookingMinutes = endTime.difference(startTime).inMinutes;
    if (coveredMinutes < bookingMinutes) {
      return const _PricePreview(
        message: 'Khung giờ này chưa có bảng giá đầy đủ.',
      );
    }

    return _PricePreview(
      amount: total,
      message: 'Giá tạm tính. Giá cuối cùng lấy từ backend sau khi đặt.',
    );
  }

  DateTime? _dateTimeAt(String date, String time) {
    final normalizedTime = time.length == 5 ? '$time:00' : time;
    return DateTime.tryParse('${date}T$normalizedTime');
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      if (error.message.contains('chưa được cấu hình giá')) {
        return 'Sân này chưa có bảng giá cho khung giờ đã chọn.';
      }

      return error.message;
    }

    return 'Không tạo được booking';
  }
}

class _PricePreview {
  const _PricePreview({this.amount, required this.message});

  final num? amount;
  final String message;
}

class _PricePreviewCard extends StatelessWidget {
  const _PricePreviewCard({required this.preview, required this.prices});

  final _PricePreview preview;
  final List<PitchPrice> prices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppSurface(
        padding: const EdgeInsets.all(14),
        color: AppColors.mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payments_outlined, color: AppColors.teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    preview.amount == null
                        ? 'Giá đặt sân'
                        : AppFormatters.money(preview.amount!),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              preview.message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
            ),
            if (prices.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: prices
                    .map(
                      (price) => Chip(
                        label: Text(
                          '${_shortTime(price.startTime)} - ${_shortTime(price.endTime)}'
                          ' / ${AppFormatters.money(price.pricePerHour)}',
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _shortTime(String value) {
    return value.length >= 5 ? value.substring(0, 5) : value;
  }
}
