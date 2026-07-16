import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/data/models/request/pitch_price_request.dart';
import 'package:soccer/presentation/common/app_scaffold_widget.dart';
import 'package:soccer/presentation/common/appbar/base_app_bar_widget.dart';
import 'package:soccer/presentation/common/loading/loading.dart';
import 'package:soccer/presentation/common/empty/empty_widget.dart';
import 'package:soccer/presentation/screens/owner_prices/cubit/owner_prices_cubit.dart';
import 'package:soccer/utilities/style/style.dart';
import 'package:intl/intl.dart';

class OwnerPricesScreen extends StatefulWidget {
  final String pitchId;
  const OwnerPricesScreen({super.key, required this.pitchId});

  @override
  State<OwnerPricesScreen> createState() => _OwnerPricesScreenState();
}

class _OwnerPricesScreenState extends State<OwnerPricesScreen> {
  late OwnerPricesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<OwnerPricesCubit>();
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return AppScaffold(
      appBar: BaseAppBar(
        title: 'Cấu hình giá sân',
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.color.green300),
            onPressed: () => _showAddOrEditPriceDialog(null),
          ),
        ],
      ),
      body: BlocListener<OwnerPricesCubit, OwnerPricesState>(
        listener: (context, state) {
          if (state is OwnerPricesLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.color.red300,
              ),
            );
            _cubit.clearError();
          }
        },
        child: BlocBuilder<OwnerPricesCubit, OwnerPricesState>(
          builder: (context, state) {
            if (state is OwnerPricesLoading) {
              return const Center(child: AppLoading());
            }

            if (state is OwnerPricesError) {
              return Center(
                child: Text(
                  state.message,
                  style: theme.font.body.copyWith(color: theme.color.b100),
                ),
              );
            }

            if (state is OwnerPricesLoaded) {
              final prices = state.prices;
              if (prices.isEmpty) {
                return const Center(child: EmptyWidget());
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: prices.length,
                itemBuilder: (context, index) {
                  final price = prices[index];
                  return Card(
                    color: theme.color.b800,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: theme.color.green300),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${price.startTime} - ${price.endTime}',
                                    style: theme.font.subTitleBold.copyWith(color: theme.color.b20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${NumberFormat('#,###').format(price.pricePerHour ?? 0)} VNĐ / Giờ',
                                style: theme.font.body.copyWith(color: theme.color.green300),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showAddOrEditPriceDialog(
                                  price.id,
                                  start: price.startTime,
                                  end: price.endTime,
                                  rate: price.pricePerHour,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: theme.color.red300),
                                onPressed: () => _cubit.removePrice(widget.pitchId, price.id ?? ''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  void _showAddOrEditPriceDialog(
    String? priceId, {
    String? start,
    String? end,
    double? rate,
  }) {
    final startController = TextEditingController(text: start ?? '06:00:00');
    final endController = TextEditingController(text: end ?? '17:00:00');
    final priceController = TextEditingController(text: rate != null ? rate.toInt().toString() : '150000');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.color.b800,
          title: Text(
            priceId == null ? 'Thêm khung giá' : 'Sửa khung giá',
            style: theme.font.title.copyWith(color: theme.color.b20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startController,
                decoration: _inputDecoration('Giờ bắt đầu (HH:mm:ss)'),
                style: theme.font.body.copyWith(color: theme.color.b20),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endController,
                decoration: _inputDecoration('Giờ kết thúc (HH:mm:ss)'),
                style: theme.font.body.copyWith(color: theme.color.b20),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Giá mỗi giờ (VNĐ)'),
                style: theme.font.body.copyWith(color: theme.color.b20),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('HỦY', style: theme.font.bodyBold.copyWith(color: theme.color.b100)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.color.green300),
              onPressed: () {
                final newRequest = PitchPriceRequest(
                  startTime: startController.text,
                  endTime: endController.text,
                  pricePerHour: double.tryParse(priceController.text) ?? 0.0,
                );
                if (priceId == null) {
                  _cubit.addPrice(widget.pitchId, newRequest);
                } else {
                  _cubit.updatePrice(widget.pitchId, priceId, newRequest);
                }
                Navigator.pop(context);
              },
              child: Text('LƯU', style: theme.font.bodyBold.copyWith(color: theme.color.b900)),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: theme.font.note.copyWith(color: theme.color.b100),
      filled: true,
      fillColor: theme.color.b900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
