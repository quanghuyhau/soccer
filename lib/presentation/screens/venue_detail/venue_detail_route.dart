import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/data/models/response/venue_response.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/screens/venue_detail/cubit/venue_detail_cubit.dart';
import 'package:soccer/presentation/screens/venue_detail/ui/venue_detail_screen.dart';
import 'package:soccer/utilities/routes/app_router.dart';
import 'package:soccer/utilities/routes/route_define.dart';

class VenueDetailRoute extends RouteDefine {
  @override
  Path initRoute(dynamic arguments) {
    final venue = arguments as VenueResponse;
    return Path(
      builder: (_) => BlocProvider<VenueDetailCubit>(
        create: (_) => getIt<VenueDetailCubit>()..fetchPitches(venue.id ?? ''),
        child: VenueDetailScreen(venue: venue),
      ),
    );
  }

  @override
  String get routeName => 'venue_detail';

  static push(VenueResponse venue) {
    AppRouter.push(routeName: VenueDetailRoute().routeName, arguments: venue);
  }
}
