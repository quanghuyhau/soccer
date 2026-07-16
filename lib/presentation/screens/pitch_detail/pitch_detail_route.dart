import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/data/models/response/pitch_response.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/screens/pitch_detail/cubit/pitch_detail_cubit.dart';
import 'package:soccer/presentation/screens/pitch_detail/ui/pitch_detail_screen.dart';
import 'package:soccer/utilities/routes/app_router.dart';
import 'package:soccer/utilities/routes/route_define.dart';

class PitchDetailRoute extends RouteDefine {
  @override
  Path initRoute(dynamic arguments) {
    final pitch = arguments as PitchResponse;
    return Path(
      builder: (_) => BlocProvider<PitchDetailCubit>(
        create: (_) => getIt<PitchDetailCubit>()..loadPitchPrices(pitch.id ?? ''),
        child: PitchDetailScreen(pitch: pitch),
      ),
    );
  }

  @override
  String get routeName => 'pitch_detail';

  static push(PitchResponse pitch) {
    AppRouter.push(routeName: PitchDetailRoute().routeName, arguments: pitch);
  }
}
