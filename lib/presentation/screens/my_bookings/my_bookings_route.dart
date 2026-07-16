import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/screens/my_bookings/cubit/my_bookings_cubit.dart';
import 'package:soccer/presentation/screens/my_bookings/ui/my_bookings_screen.dart';
import 'package:soccer/utilities/routes/app_router.dart';
import 'package:soccer/utilities/routes/route_define.dart';

class MyBookingsRoute extends RouteDefine {
  @override
  Path initRoute(dynamic arguments) => Path(
        builder: (_) => BlocProvider<MyBookingsCubit>(
          create: (_) => getIt<MyBookingsCubit>()..fetchMyBookings(),
          child: const MyBookingsScreen(),
        ),
      );

  @override
  String get routeName => 'my_bookings';

  static push() {
    AppRouter.push(routeName: MyBookingsRoute().routeName);
  }
}
