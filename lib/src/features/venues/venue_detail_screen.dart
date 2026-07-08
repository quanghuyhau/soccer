import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_feedback.dart';
import '../../core/widgets/base_screen.dart';
import '../bookings/create_booking_screen.dart';
import 'venues_controller.dart';

class VenueDetailScreen extends ConsumerWidget {
  const VenueDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(venueDetailControllerProvider(venueId));
    final user = ref.watch(appSessionProvider)?.user;
    final canManageVenue = user?.isOwner == true || user?.isAdmin == true;

    ref.listen(createPitchControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (pitch) {
          if (pitch != null && previous?.isLoading == true) {
            AppToast.success(context, 'Đã thêm sân con');
          }
        },
        error: (error, stackTrace) {
          AppToast.error(context, error);
        },
      );
    });

    ref.listen(pitchPriceMutationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (value) {
          if (value != null && previous?.isLoading == true) {
            AppToast.success(context, 'Đã cập nhật bảng giá');
          }
        },
        error: (error, stackTrace) {
          AppToast.error(context, error);
        },
      );
    });

    ref.listen(pitchMutationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (value) {
          if (value != null && previous?.isLoading == true) {
            AppToast.success(context, 'Đã cập nhật sân con');
          }
        },
        error: (error, stackTrace) {
          AppToast.error(context, error);
        },
      );
    });

    return BaseAsyncScreen<VenueDetailData>(
      title: 'Chi tiết sân',
      value: detailState,
      onRetry: () => ref.invalidate(venueDetailControllerProvider(venueId)),
      onRefresh: () async =>
          ref.invalidate(venueDetailControllerProvider(venueId)),
      actions: [
        if (canManageVenue)
          IconButton(
            tooltip: 'Thêm sân con',
            onPressed: () =>
                _showAddPitchDialog(context: context, venueId: venueId),
            icon: const Icon(Icons.add),
          ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () {
            ref.invalidate(venueDetailControllerProvider(venueId));
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      data: (detail) => _VenueDetail(detail: detail),
    );
  }
}

class _VenueDetail extends ConsumerWidget {
  const _VenueDetail({required this.detail});

  final VenueDetailData detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = detail.venue;
    final user = ref.watch(appSessionProvider)?.user;
    final canManagePrices = user?.isOwner == true || user?.isAdmin == true;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppHeroPanel(
          title: venue.name,
          subtitle: venue.address,
          icon: Icons.stadium,
        ),
        if (venue.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(venue.description),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.location_on_outlined, size: 18),
              label: Text(venue.address),
            ),
            Chip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text('${venue.openTime} - ${venue.closeTime}'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppMetricBubble(
          icon: Icons.sports_soccer,
          label: 'Sân con',
          value: detail.pitches.length.toString(),
          color: AppColors.coral,
        ),
        const SizedBox(height: 20),
        Text('Sân con', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (detail.pitches.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Chưa có sân con'),
            ),
          )
        else
          ...detail.pitches.map((pitch) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PitchCard(
                venue: venue,
                pitch: pitch,
                prices: detail.pricesOf(pitch.id),
                canManagePrices: canManagePrices,
              ),
            );
          }),
      ],
    );
  }
}

class _PitchCard extends StatelessWidget {
  const _PitchCard({
    required this.venue,
    required this.pitch,
    required this.prices,
    required this.canManagePrices,
  });

  final Venue venue;
  final Pitch pitch;
  final List<PitchPrice> prices;
  final bool canManagePrices;

  @override
  Widget build(BuildContext context) {
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grass,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pitch.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                AppStatusPill(label: pitch.type, color: AppColors.teal),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.straighten, size: 18),
                  label: Text(pitch.size),
                ),
                Chip(
                  avatar: const Icon(Icons.eco_outlined, size: 18),
                  label: Text(pitch.surface),
                ),
              ],
            ),
            if (pitch.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(pitch.description),
            ],
            const SizedBox(height: 12),
            _PitchPriceList(
              venueId: venue.id,
              prices: prices,
              canManage: canManagePrices,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton.primary(
                  label: 'Đặt sân',
                  icon: const Icon(Icons.add_task),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CreateBookingScreen(
                          venue: venue,
                          pitch: pitch,
                          prices: prices,
                        ),
                      ),
                    );
                  },
                ),
                if (canManagePrices)
                  AppButton.outlined(
                    label: 'Thêm giá',
                    icon: const Icon(Icons.payments_outlined),
                    onPressed: () => _showAddPriceDialog(
                      context: context,
                      venueId: venue.id,
                      pitchId: pitch.id,
                    ),
                  ),
                if (canManagePrices)
                  PopupMenuButton<_PitchAction>(
                    tooltip: 'Tuỳ chọn sân con',
                    onSelected: (action) {
                      switch (action) {
                        case _PitchAction.edit:
                          _showAddPitchDialog(
                            context: context,
                            venueId: venue.id,
                            pitch: pitch,
                          );
                        case _PitchAction.delete:
                          _confirmDeletePitch(context, venue.id, pitch);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: _PitchAction.edit,
                        child: Text('Sửa sân'),
                      ),
                      PopupMenuItem(
                        value: _PitchAction.delete,
                        child: Text('Xoá sân'),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PitchPriceList extends StatelessWidget {
  const _PitchPriceList({
    required this.venueId,
    required this.prices,
    required this.canManage,
  });

  final String venueId;
  final List<PitchPrice> prices;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const AppSurface(
        padding: EdgeInsets.all(12),
        color: AppColors.mint,
        child: Text('Chưa có bảng giá cho sân này'),
      );
    }

    return AppSurface(
      padding: const EdgeInsets.all(12),
      color: AppColors.mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bảng giá',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...prices.map(
            (price) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(
                '${_shortTime(price.startTime)} - ${_shortTime(price.endTime)}'
                ' / ${AppFormatters.money(price.price)}',
              ),
              subtitle: Text('${price.priceType} - ${price.slotMinutes} phút'),
              trailing: canManage
                  ? PopupMenuButton<_PriceAction>(
                      tooltip: 'Tuỳ chọn bảng giá',
                      onSelected: (action) {
                        switch (action) {
                          case _PriceAction.edit:
                            _showAddPriceDialog(
                              context: context,
                              venueId: venueId,
                              pitchId: price.pitchId,
                              price: price,
                            );
                          case _PriceAction.delete:
                            _confirmDeletePrice(context, venueId, price);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: _PriceAction.edit,
                          child: Text('Sửa giá'),
                        ),
                        PopupMenuItem(
                          value: _PriceAction.delete,
                          child: Text('Xoá giá'),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

enum _PriceAction { edit, delete }

void _showAddPriceDialog({
  required BuildContext context,
  required String venueId,
  required String pitchId,
  PitchPrice? price,
}) {
  showDialog<void>(
    context: context,
    builder: (_) =>
        _AddPriceDialog(venueId: venueId, pitchId: pitchId, price: price),
  );
}

Future<void> _confirmDeletePrice(
  BuildContext context,
  String venueId,
  PitchPrice price,
) async {
  final container = ProviderScope.containerOf(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Xoá bảng giá?'),
      content: Text(
        '${_shortTime(price.startTime)} - ${_shortTime(price.endTime)}'
        ' / ${AppFormatters.money(price.price)}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Huỷ'),
        ),
        AppButton.destructive(
          label: 'Xoá',
          icon: const Icon(Icons.delete_outline),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    container
        .read(pitchPriceMutationControllerProvider.notifier)
        .delete(venueId: venueId, priceId: price.id);
  }
}

void _showAddPitchDialog({
  required BuildContext context,
  required String venueId,
  Pitch? pitch,
}) {
  showDialog<void>(
    context: context,
    builder: (_) => _AddPitchDialog(venueId: venueId, pitch: pitch),
  );
}

enum _PitchAction { edit, delete }

Future<void> _confirmDeletePitch(
  BuildContext context,
  String venueId,
  Pitch pitch,
) async {
  final container = ProviderScope.containerOf(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Xoá sân con?'),
      content: Text('Bạn muốn xoá "${pitch.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Huỷ'),
        ),
        AppButton.destructive(
          label: 'Xoá',
          icon: const Icon(Icons.delete_outline),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    container
        .read(pitchMutationControllerProvider.notifier)
        .delete(venueId: venueId, pitchId: pitch.id);
  }
}

class _AddPitchDialog extends ConsumerStatefulWidget {
  const _AddPitchDialog({required this.venueId, this.pitch});

  final String venueId;
  final Pitch? pitch;

  @override
  ConsumerState<_AddPitchDialog> createState() => _AddPitchDialogState();
}

class _AddPitchDialogState extends ConsumerState<_AddPitchDialog> {
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _typeController;
  late final TextEditingController _sizeController;
  late final TextEditingController _surfaceController;
  final _priceStartController = TextEditingController(text: '06:00:00');
  final _priceEndController = TextEditingController(text: '17:00:00');
  final _priceTypeController = TextEditingController(text: 'NORMAL');
  final _priceController = TextEditingController(text: '150000');

  @override
  void initState() {
    super.initState();
    final pitch = widget.pitch;
    _codeController = TextEditingController(text: pitch?.code ?? '');
    _nameController = TextEditingController(text: pitch?.name ?? 'Sân A');
    _descriptionController = TextEditingController(
      text: pitch?.description ?? 'Sân bóng 7 người',
    );
    _typeController = TextEditingController(text: pitch?.type ?? 'SEVEN');
    _sizeController = TextEditingController(text: pitch?.size ?? '30x50m');
    _surfaceController = TextEditingController(
      text: pitch?.surface ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    _sizeController.dispose();
    _surfaceController.dispose();
    _priceStartController.dispose();
    _priceEndController.dispose();
    _priceTypeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPitchControllerProvider);
    final mutationState = ref.watch(pitchMutationControllerProvider);
    final isEdit = widget.pitch != null;
    final isLoading = state.isLoading || mutationState.isLoading;

    return AlertDialog(
      title: Text(isEdit ? 'Sửa sân con' : 'Thêm sân con'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _codeController,
                label: 'Mã sân',
                icon: Icons.qr_code_2,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _nameController,
                label: 'Tên sân',
                icon: Icons.grass,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descriptionController,
                label: 'Mô tả',
                icon: Icons.notes,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _typeController,
                      label: 'Loại',
                      icon: Icons.sports_soccer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _sizeController,
                      label: 'Kích thước',
                      icon: Icons.straighten,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _surfaceController,
                label: 'Mặt sân',
                icon: Icons.eco_outlined,
              ),
              if (!isEdit) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Khung giá ban đầu',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _priceStartController,
                        label: 'Bắt đầu',
                        icon: Icons.schedule,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _priceEndController,
                        label: 'Kết thúc',
                        icon: Icons.schedule_send,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _priceTypeController,
                  label: 'Loại giá',
                  icon: Icons.label_outline,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _priceController,
                  label: 'Giá/ca 90 phút',
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        AppButton.primary(
          label: 'Lưu',
          isLoading: isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    final pitch = widget.pitch;
    final price = num.tryParse(_priceController.text.trim());
    if (pitch == null && (price == null || price <= 0)) {
      AppToast.info(context, 'Giá phải lớn hơn 0');
      return;
    }

    final request = CreatePitchRequest(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _typeController.text.trim(),
      size: _sizeController.text.trim(),
      surface: _surfaceController.text.trim(),
    );

    if (pitch == null) {
      ref
          .read(createPitchControllerProvider.notifier)
          .create(
            venueId: widget.venueId,
            request: request,
            prices: [
              CreatePitchPriceRequest(
                startTime: _normalizeTime(_priceStartController.text),
                endTime: _normalizeTime(_priceEndController.text),
                slotMinutes: _slotMinutes,
                priceType: _priceTypeController.text.trim(),
                price: price!,
              ),
            ],
          );
    } else {
      ref
          .read(pitchMutationControllerProvider.notifier)
          .update(venueId: widget.venueId, pitchId: pitch.id, request: request);
    }

    Navigator.of(context).pop();
  }
}

class _AddPriceDialog extends ConsumerStatefulWidget {
  const _AddPriceDialog({
    required this.venueId,
    required this.pitchId,
    this.price,
  });

  final String venueId;
  final String pitchId;
  final PitchPrice? price;

  @override
  ConsumerState<_AddPriceDialog> createState() => _AddPriceDialogState();
}

class _AddPriceDialogState extends ConsumerState<_AddPriceDialog> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _priceTypeController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final price = widget.price;
    _startController = TextEditingController(
      text: price?.startTime ?? '06:00:00',
    );
    _endController = TextEditingController(text: price?.endTime ?? '17:00:00');
    _priceTypeController = TextEditingController(
      text: price?.priceType ?? 'NORMAL',
    );
    _priceController = TextEditingController(
      text: price?.price.round().toString() ?? '150000',
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _priceTypeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pitchPriceMutationControllerProvider);
    final isEdit = widget.price != null;

    return AlertDialog(
      title: Text(isEdit ? 'Sửa bảng giá' : 'Thêm bảng giá'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _startController,
            label: 'Bắt đầu',
            icon: Icons.schedule,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _endController,
            label: 'Kết thúc',
            icon: Icons.schedule_send,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _priceTypeController,
            label: 'Loại giá',
            icon: Icons.label_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _priceController,
            label: 'Giá/ca 90 phút',
            icon: Icons.payments_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        AppButton.primary(
          label: 'Lưu',
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    final price = num.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      AppToast.info(context, 'Giá phải lớn hơn 0');
      return;
    }

    final request = CreatePitchPriceRequest(
      startTime: _normalizeTime(_startController.text),
      endTime: _normalizeTime(_endController.text),
      slotMinutes: _slotMinutes,
      priceType: _priceTypeController.text.trim(),
      price: price,
    );
    final controller = ref.read(pitchPriceMutationControllerProvider.notifier);
    final currentPrice = widget.price;

    if (currentPrice == null) {
      controller.create(
        venueId: widget.venueId,
        pitchId: widget.pitchId,
        request: request,
      );
    } else {
      controller.update(
        venueId: widget.venueId,
        priceId: currentPrice.id,
        request: request,
      );
    }

    Navigator.of(context).pop();
  }
}

const _slotMinutes = 90;

String _normalizeTime(String value) {
  final trimmed = value.trim();
  return trimmed.length == 5 ? '$trimmed:00' : trimmed;
}

String _shortTime(String value) {
  return value.length >= 5 ? value.substring(0, 5) : value;
}
