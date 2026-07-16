import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/screens/owner_prices/cubit/owner_prices_cubit.dart';
import 'package:soccer/presentation/screens/owner_prices/ui/owner_prices_screen.dart';
import 'package:soccer/utilities/routes/app_router.dart';
import 'package:soccer/utilities/routes/route_define.dart';

class OwnerPricesRoute extends RouteDefine {
  @override
  Path initRoute(dynamic arguments) {
    final pitchId = arguments as String;
    return Path(
      builder: (_) => BlocProvider<OwnerPricesCubit>(
        create: (_) => getIt<OwnerPricesCubit>()..fetchPrices(pitchId),
        child: OwnerPricesScreen(pitchId: pitchId),
      ),
    );
  }

  @override
  String get routeName => 'owner_prices';

  static push(String pitchId) {
    AppRouter.push(routeName: OwnerPricesRoute().routeName, arguments: pitchId);
  }
}
