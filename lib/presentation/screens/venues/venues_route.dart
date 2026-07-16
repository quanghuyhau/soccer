import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/screens/venues/cubit/venues_cubit.dart';
import 'package:soccer/presentation/screens/venues/ui/venues_screen.dart';
import 'package:soccer/utilities/routes/app_router.dart';
import 'package:soccer/utilities/routes/route_define.dart';

class VenuesRoute extends RouteDefine {
  @override
  Path initRoute(dynamic arguments) => Path(
        builder: (_) => BlocProvider<VenuesCubit>(
          create: (_) => getIt<VenuesCubit>()..fetchVenues(),
          child: const VenuesScreen(),
        ),
      );

  @override
  String get routeName => 'venues';

  static push() {
    AppRouter.push(routeName: VenuesRoute().routeName);
  }
}
