import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_feedback.dart';
import '../../core/widgets/base_screen.dart';
import 'bookings_controller.dart';

class CreateBookingScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createBookingControllerProvider(prices));
    final notifier = ref.read(createBookingControllerProvider(prices).notifier);
    final slots = state.availableSlots;
    final selectedSlot = state.selectedSlot;
    final preview = _previewPrice(selectedSlot);

    return BaseScreen(
      title: 'Tạo booking',
      padding: EdgeInsets.zero,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppHeroPanel(
            title: pitch.name,
            subtitle: venue.name,
            icon: Icons.add_task,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _field(
                    notifier.nameController,
                    'Tên khách hàng',
                    Icons.person,
                  ),
                  _field(
                    notifier.phoneController,
                    'Số điện thoại',
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _field(
                    notifier.dateController,
                    'Ngày',
                    Icons.today,
                  ),
                  _SlotPicker(
                    slots: slots,
                    selectedSlot: selectedSlot,
                    onSelected: (slot) {
                      notifier.selectSlot(slot.startTime);
                    },
                  ),
                  _PricePreviewCard(preview: preview, prices: prices),
                  _field(
                    notifier.noteController,
                    'Ghi chú',
                    Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 4),
                  AppButton.primary(
                    label: 'Xác nhận đặt sân',
                    icon: const Icon(Icons.check_circle_outline),
                    isLoading: state.submitStatus.isLoading,
                    isExpanded: true,
                    onPressed: () => _submit(context, ref),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField(
        controller: controller,
        label: label,
        icon: icon,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  void _submit(BuildContext context, WidgetRef ref) {
    ref.read(createBookingControllerProvider(prices).notifier).submit(
          pitchId: pitch.id,
          onError: (msg) => AppToast.error(context, msg),
          onSuccess: () {
            AppToast.success(context, 'Đặt sân thành công');
            Navigator.of(context).pop();
          },
        );
  }

  _PricePreview _previewPrice(BookingSlot? slot) {
    if (prices.isEmpty) {
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

  final List<BookingSlot> slots;
  final BookingSlot? selectedSlot;
  final ValueChanged<BookingSlot> onSelected;

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
