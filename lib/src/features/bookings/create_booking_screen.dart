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
  final _noteController = TextEditingController();
  DateTime? _selectedSlotStart;

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
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createBookingControllerProvider);
    final slots = _availableSlots();
    final selectedSlot = _selectedSlot(slots);
    final preview = _previewPrice(selectedSlot);

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
                  _field(
                    _dateController,
                    'Ngày',
                    Icons.today,
                    onChanged: (_) {
                      setState(() => _selectedSlotStart = null);
                    },
                  ),
                  _SlotPicker(
                    slots: slots,
                    selectedSlot: selectedSlot,
                    onSelected: (slot) {
                      setState(() => _selectedSlotStart = slot.startTime);
                    },
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
    final slot = _selectedSlot(_availableSlots());
    final startTime = slot?.startTime;

    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn khung giờ hợp lệ')),
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
            note: _noteController.text.trim(),
          ),
        );
  }

  _PricePreview _previewPrice(_BookingSlot? slot) {
    if (widget.prices.isEmpty) {
      return const _PricePreview(
        message: 'Sân này chưa có bảng giá. Backend sẽ báo lỗi nếu đặt ngay.',
      );
    }

    if (slot == null) {
      return const _PricePreview(
        message: 'Không có slot 90 phút phù hợp trong bảng giá.',
      );
    }

    return _PricePreview(
      amount: slot.price.price,
      message: 'Giá tạm tính. Giá cuối cùng lấy từ backend sau khi đặt.',
    );
  }

  DateTime? _dateTimeAt(String date, String time) {
    final normalizedTime = time.length == 5 ? '$time:00' : time;
    return DateTime.tryParse('${date}T$normalizedTime');
  }

  List<_BookingSlot> _availableSlots() {
    final date = _dateController.text.trim();
    final slots = <_BookingSlot>[];

    for (final price in widget.prices) {
      if (price.slotMinutes != _slotMinutes) {
        continue;
      }

      final rangeStart = _dateTimeAt(date, price.startTime);
      var rangeEnd = _dateTimeAt(date, price.endTime);

      if (rangeStart == null || rangeEnd == null) {
        continue;
      }

      if (!rangeEnd.isAfter(rangeStart)) {
        rangeEnd = rangeEnd.add(const Duration(days: 1));
      }

      var cursor = rangeStart;
      while (!cursor.add(_slotDuration).isAfter(rangeEnd)) {
        slots.add(
          _BookingSlot(
            startTime: cursor,
            endTime: cursor.add(_slotDuration),
            price: price,
          ),
        );
        cursor = cursor.add(_slotDuration);
      }
    }

    slots.sort((a, b) => a.startTime.compareTo(b.startTime));
    return slots;
  }

  _BookingSlot? _selectedSlot(List<_BookingSlot> slots) {
    if (slots.isEmpty) {
      return null;
    }

    for (final slot in slots) {
      if (slot.startTime == _selectedSlotStart) {
        return slot;
      }
    }

    return slots.first;
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

const _slotMinutes = 90;
const _slotDuration = Duration(minutes: _slotMinutes);

class _BookingSlot {
  const _BookingSlot({
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  final DateTime startTime;
  final DateTime endTime;
  final PitchPrice price;
}

class _PricePreview {
  const _PricePreview({this.amount, required this.message});

  final num? amount;
  final String message;
}

class _SlotPicker extends StatelessWidget {
  const _SlotPicker({
    required this.slots,
    required this.selectedSlot,
    required this.onSelected,
  });

  final List<_BookingSlot> slots;
  final _BookingSlot? selectedSlot;
  final ValueChanged<_BookingSlot> onSelected;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: AppSurface(
          padding: EdgeInsets.all(14),
          child: Text('Chưa có slot 90 phút phù hợp trong bảng giá.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppSurface(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn khung giờ',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final selected = slot.startTime == selectedSlot?.startTime;
                return ChoiceChip(
                  selected: selected,
                  label: Text(
                    '${AppFormatters.time(slot.startTime)} - ${AppFormatters.time(slot.endTime)}',
                  ),
                  onSelected: (_) => onSelected(slot),
                );
              }).toList(),
            ),
            if (selectedSlot != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule_send, color: AppColors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ca 90 phút, kết thúc ${AppFormatters.time(selectedSlot!.endTime)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  ),
                  AppStatusPill(
                    label: selectedSlot!.price.priceType,
                    color: AppColors.teal,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
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
                          ' / ${AppFormatters.money(price.price)}',
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
