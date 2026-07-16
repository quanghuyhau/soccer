import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/presentation/common/app_scaffold_widget.dart';
import 'package:soccer/presentation/common/appbar/base_app_bar_widget.dart';
import 'package:soccer/presentation/common/loading/loading.dart';
import 'package:soccer/presentation/common/empty/empty_widget.dart';
import 'package:soccer/presentation/screens/venues/cubit/venues_cubit.dart';
import 'package:soccer/presentation/screens/venue_detail/venue_detail_route.dart';
import 'package:soccer/utilities/style/style.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  late VenuesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<VenuesCubit>();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppScaffold(
      appBar: const BaseAppBar(
        title: 'Cụm Sân Bóng',
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<VenuesCubit, VenuesState>(
        builder: (context, state) {
          if (state is VenuesLoading) {
            return const Center(child: AppLoading());
          }

          if (state is VenuesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: theme.font.body.copyWith(color: theme.color.b100),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cubit.fetchVenues,
                    child: const Text('Thử lại'),
                  )
                ],
              ),
            );
          }

          if (state is VenuesLoaded) {
            final venues = state.venues;
            if (venues.isEmpty) {
              return const Center(child: EmptyWidget());
            }

            return RefreshIndicator(
              onRefresh: _cubit.fetchVenues,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: venues.length,
                itemBuilder: (context, index) {
                  final venue = venues[index];
                  return Card(
                    color: theme.color.b800,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Navigate to Venue Detail Screen
                        VenueDetailRoute.push(venue);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.name ?? 'Sân bóng không tên',
                              style: theme.font.title.copyWith(
                                color: theme.color.b20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (venue.description != null && venue.description!.isNotEmpty) ...[
                              Text(
                                venue.description!,
                                style: theme.font.body.copyWith(
                                  color: theme.color.b100,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                            ],
                            Row(
                              children: [
                                Icon(Icons.location_on, color: theme.color.green300, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    venue.address ?? 'Không có địa chỉ',
                                    style: theme.font.note.copyWith(
                                      color: theme.color.b100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.phone, color: theme.color.green300, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  venue.phone ?? 'Không có số điện thoại',
                                  style: theme.font.note.copyWith(
                                    color: theme.color.b100,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.access_time, color: theme.color.green300, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${venue.openTime ?? "06:00"} - ${venue.closeTime ?? "22:00"}',
                                  style: theme.font.note.copyWith(
                                    color: theme.color.b100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    );
  }
}
