import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/bus_boarding_bloc/bus_boarding_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/buses_bloc/buses_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/payment_details_bloc/payment_details_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/points_bloc/points_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/settings_bloc/settings_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/signup_bloc/signup_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/stations_bloc/stations_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/update_tickets_bloc/update_tickets_bloc.dart';
import 'package:sdp/data/repositories/bus_boarding_repository.dart';
import 'package:sdp/data/repositories/buses_repository.dart';
import 'package:sdp/data/repositories/location_repository.dart';
import 'package:sdp/data/repositories/login_repository.dart';
import 'package:sdp/data/repositories/points_repository.dart';
import 'package:sdp/data/repositories/stations_repository.dart';
import 'package:sdp/data/repositories/tickets_repository.dart';
import 'package:sdp/data/repositories/update_tickets_repository.dart';
import 'package:sdp/presentation/screens/driver_screen.dart';
import 'package:sdp/presentation/screens/generate_qr_code.dart';
import 'package:sdp/presentation/screens/maps_routing_screen.dart';
import 'package:sdp/presentation/screens/my_location_screen.dart';
import 'package:sdp/presentation/screens/homepage_screen.dart';
import 'package:sdp/presentation/screens/login_screen2.dart';
import 'package:sdp/presentation/screens/maps_screen.dart';
import 'package:sdp/presentation/screens/mobile_scanner_screen.dart';
import 'package:sdp/presentation/screens/payment_details.dart';
import 'package:sdp/presentation/screens/payment_screen.dart';
import 'package:sdp/presentation/screens/bus_scanner_screen.dart';
import 'package:sdp/presentation/screens/rewards_screen.dart';
import 'package:sdp/presentation/screens/settings_screen.dart';
import 'package:sdp/presentation/screens/signup_screen2.dart';
import 'package:sdp/presentation/screens/trace_buses_screen.dart';
import 'package:sdp/presentation/screens/wallet.dart';
import 'package:sdp/presentation/screens/your_tickets.dart';
import 'package:sdp/presentation/screens/new_welcome.dart';
import 'data/repositories/signup_repository.dart';

/*
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
*/

void main() {
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final TicketsBloc _ticketsBloc =
      TicketsBloc(ticketsRepos: TicketsRepository());

  final UpdateTicketsBloc _updateTicketsBloc =
      UpdateTicketsBloc(updateTicketsRepos: UpdateTicketsRepository());
/*
## one of the first blocks I have build before login even,  Not Used at the end :)
  final LocationBloc _locationBloc =
      LocationBloc(locationRepos: LocationRepository());
*/
  final Login2Bloc _login2Bloc = Login2Bloc(authRepo: LoginRepository());

  final SignupBloc _signupBloc = SignupBloc(signupRepo: SignupRepository());

  final BusBoardingBloc _busBoardingBloc =
      BusBoardingBloc(busBoardingRepos: BusBoardingRepository());

  final StationsBloc _stationsBloc =
      StationsBloc(stationsRepos: StationsRepository());

  final SettingsBloc _settingsBloc =
      SettingsBloc(); // no need for repository for now

  final PaymentDetailsBloc _paymentDetailsBloc =
      PaymentDetailsBloc(); // no need for repository for now

  final BusesBloc _busesBloc = BusesBloc(
      busesRepos: BusesRepository()); // no need for repository for now

  final PointsBloc _pointsBloc = PointsBloc(pointsRepos: PointsRepository());

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LoginRepository(),
        ),
        RepositoryProvider(
          create: (context) => SignupRepository(),
        ),
        RepositoryProvider(
          create: (context) => LocationRepository(),
        ),
        RepositoryProvider(
          create: (context) => TicketsRepository(),
        ),
        RepositoryProvider(
          create: (context) => StationsRepository(),
        ),
        RepositoryProvider(
          create: (context) => UpdateTicketsRepository(),
        ),
        RepositoryProvider(
          create: (context) => BusesRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'SDP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(224, 240, 230, 230),
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: {
          '/': (context) => BlocProvider.value(
                value: _login2Bloc,
                child: Welcome(),
              ),
          '/login': (context) => BlocProvider.value(
                value: _login2Bloc,
                child: LoginView(),
              ),
          '/signup': (context) => BlocProvider.value(
                value: _signupBloc,
                child: SignupScreen(),
              ),
          '/home': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _ticketsBloc,
                  ),
                  BlocProvider.value(
                    value: _busBoardingBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                  BlocProvider.value(
                    value: _pointsBloc,
                  ),
                ],
                child: MyHomePage(title: 'Home'),
              ),
          '/payment': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _ticketsBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                ],
                child: Payment(),
              ),
          '/PaymentInformation': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _paymentDetailsBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                ],
                child: PaymentInformation(),
              ),
          '/yourTickets': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _updateTicketsBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                  BlocProvider.value(
                    value: _ticketsBloc,
                  ),
                ],
                child: YourTickets(),
              ),
          '/generateCode': (context) => BlocProvider.value(
                value: _ticketsBloc,
                child: GeneratePage(),
              ),
          '/BusScanner': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _busBoardingBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                ],
                child: BusScanner(),
              ),
          '/MobileScanner': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _ticketsBloc,
                  ),
                  BlocProvider.value(
                    value: _busBoardingBloc,
                  ),
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                ],
                child: MobileScanner(),
              ),
/*
          '/location': (context) => BlocProvider.value(
                value: _locationBloc,
                child: CheckLiveLocation(),
              ),
*/
          '/Maps': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _stationsBloc,
                  ),
                  BlocProvider.value(
                    value: _busesBloc,
                  ),
                ],
                child: Maps(),
              ),
          '/settings': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _login2Bloc,
                  ),
                  BlocProvider.value(
                    value: _settingsBloc,
                  ),
                ],
                child: SettingsFourPage(),
              ),
          '/wallet': (context) => BlocProvider.value(
                value: _paymentDetailsBloc,
                child: Wallet(),
              ),
          '/MyLocation': (context) => MyLocation(),
          '/TraceBuses': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _stationsBloc,
                  ),
                ],
                child: TraceBuses(),
              ),
          '/MapsRouting': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _stationsBloc,
                  ),
                  BlocProvider.value(
                    value: _busesBloc,
                  ),
                ],
                child: MapsRouting(),
              ),
          '/Rewards': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _stationsBloc,
                  ),
                ],
                child: Rewards(),
              ),
          '/BusDriver': (context) => BusDriver(),
        },
      ),
    );
  }

  @override
  void dispose() {
    _ticketsBloc.close();
    super.dispose();
  }
}
