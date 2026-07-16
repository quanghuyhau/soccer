import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/presentation/common/app_scaffold_widget.dart';
import 'package:soccer/presentation/common/appbar/base_app_bar_widget.dart';
import 'package:soccer/presentation/common/loading/loading.dart';
import 'package:soccer/presentation/common/empty/empty_widget.dart';
import 'package:soccer/presentation/screens/venue_detail/cubit/venue_detail_cubit.dart';
import 'package:soccer/presentation/screens/pitch_detail/pitch_detail_route.dart';
import 'package:soccer/utilities/style/style.dart';

class VenueDetailScreen extends StatefulWidget {
  final VenueResponse venue;
  const VenueDetailScreen({super.key, required this.venue});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late VenueDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<VenueDetailCubit>();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppScaffold(
      appBar: BaseAppBar(
        title: widget.venue.name ?? 'Chi tiết cụm sân',
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: theme.color.b800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.venue.name ?? 'Sân bóng không tên',
                    style: theme.font.title.copyWith(color: theme.color.b20),
                  ),
                  const SizedBox(height: 8),
                  if (widget.venue.description != null && widget.venue.description!.isNotEmpty) ...[
                    Text(
                      widget.venue.description!,
                      style: theme.font.body.copyWith(color: theme.color.b100),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Icon(Icons.location_on, color: theme.color.green300, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.venue.address ?? 'Không có địa chỉ',
                          style: theme.font.body.copyWith(color: theme.color.b100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: theme.color.green300, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.venue.phone ?? 'Không có số điện thoại',
                        style: theme.font.body.copyWith(color: theme.color.b100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: theme.color.green300, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Giờ mở cửa: ${widget.venue.openTime ?? "06:00"} - ${widget.venue.closeTime ?? "22:00"}',
                        style: theme.font.body.copyWith(color: theme.color.b100),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Danh sách sân con',
                style: theme.font.title.copyWith(color: theme.color.b20),
              ),
            ),
          ),
          BlocBuilder<VenueDetailCubit, VenueDetailState>(
            builder: (context, state) {
              if (state is VenueDetailLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: AppLoading()),
                  ),
                );
              }

              if (state is VenueDetailError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.message,
                        style: theme.font.body.copyWith(color: theme.color.b100),
                      ),
                    ),
                  ),
                );
              }

              if (state is VenueDetailLoaded) {
                final pitches = state.pitches;
                if (pitches.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: EmptyWidget()),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pitch = pitches[index];
                        return Card(
                          color: theme.color.b800,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              PitchDetailRoute.push(pitch);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pitch.name ?? 'Sân không tên',
                                          style: theme.font.subTitleBold.copyWith(
                                            color: theme.color.b20,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (pitch.description != null && pitch.description!.isNotEmpty) ...[
                                          Text(
                                            pitch.description!,
                                            style: theme.font.note.copyWith(
                                              color: theme.color.b100,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            _buildChip('Loại: ${pitch.type ?? "Sân 5"}'),
                                            _buildChip('Kích thước: ${pitch.size ?? "N/A"}'),
                                            _buildChip('Mặt sân: ${pitch.surface ?? "Cỏ nhân tạo"}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: theme.color.b100),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: pitches.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.color.b900,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: theme.font.note.copyWith(color: theme.color.b100),
      ),
    );
  }
}
