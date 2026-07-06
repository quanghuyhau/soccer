import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/base_screen.dart';
import '../owner/owner_controller.dart';
import '../owner/venue_dialog.dart';
import 'venue_detail_screen.dart';
import 'venues_controller.dart';

class VenuesScreen extends ConsumerStatefulWidget {
  const VenuesScreen({super.key});

  @override
  ConsumerState<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends ConsumerState<VenuesScreen> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venuesState = ref.watch(venuesControllerProvider);
    final venueMutationState = ref.watch(venueMutationControllerProvider);
    final user = ref.watch(appSessionProvider)?.user;
    final canCreateVenue = user?.isOwner == true;

    ref.listen(venueMutationControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (value) {
          if (value != null && previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật cụm sân')),
            );
            ref.invalidate(venuesControllerProvider);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return BaseAsyncScreen<List<Venue>>(
      title: 'Cụm sân',
      value: venuesState,
      onRetry: () => ref.invalidate(venuesControllerProvider),
      onRefresh: () async => ref.invalidate(venuesControllerProvider),
      actions: [
        if (canCreateVenue)
          IconButton(
            tooltip: 'Tạo cụm sân',
            onPressed: venueMutationState.isLoading
                ? null
                : () => showVenueDialog(context: context),
            icon: const Icon(Icons.add_business),
          ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () => ref.invalidate(venuesControllerProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
      data: (venues) {
        final filtered = venues.where((venue) {
          final query = _query.toLowerCase();
          return venue.name.toLowerCase().contains(query) ||
              venue.address.toLowerCase().contains(query);
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AppHeroPanel(
              title: 'Tìm sân phù hợp',
              subtitle: 'Chọn cụm sân, xem sân con và đặt lịch',
              icon: Icons.stadium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.location_city,
                    label: 'Cụm sân',
                    value: venues.length.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppMetricBubble(
                    icon: Icons.grass,
                    label: 'Sẵn sàng',
                    value: venues
                        .where((venue) => venue.status == 'ACTIVE')
                        .length
                        .toString(),
                    color: AppColors.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (canCreateVenue) ...[
              AppButton.primary(
                label: 'Tạo cụm sân',
                icon: const Icon(Icons.add_business),
                isLoading: venueMutationState.isLoading,
                isExpanded: true,
                onPressed: () => showVenueDialog(context: context),
              ),
              const SizedBox(height: 12),
            ],
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
              children: [
                AppQuickActionTile(
                  icon: Icons.flash_on,
                  label: 'Đặt nhanh',
                  color: AppColors.coral,
                  onTap: filtered.isEmpty
                      ? null
                      : () => _openVenue(context, filtered.first),
                ),
                AppQuickActionTile(
                  icon: Icons.near_me,
                  label: 'Gần bạn',
                  color: AppColors.teal,
                  onTap: null,
                ),
                AppQuickActionTile(
                  icon: Icons.history,
                  label: 'Gần đây',
                  color: AppColors.amber,
                  onTap: null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _searchController,
              label: 'Tìm theo tên hoặc địa chỉ',
              icon: Icons.search,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              const _EmptyVenues()
            else
              ...filtered.map((venue) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _VenueCard(venue: venue),
                );
              }),
          ],
        );
      },
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _openVenue(context, venue);
        },
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
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.sports_soccer,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(venue.address),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text('${venue.openTime} - ${venue.closeTime}'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.phone, size: 18),
                    label: Text(venue.phone),
                  ),
                  AppStatusPill(
                    label: venue.status,
                    color: venue.status == 'ACTIVE'
                        ? AppColors.teal
                        : AppColors.coral,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _openVenue(BuildContext context, Venue venue) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => VenueDetailScreen(venueId: venue.id),
    ),
  );
}

class _EmptyVenues extends StatelessWidget {
  const _EmptyVenues();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chưa có cụm sân'));
  }
}
