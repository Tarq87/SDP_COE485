import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/bus_boarding_bloc/bus_boarding_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/location_bloc/location_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/signup_bloc/signup_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';
import 'package:sdp/data/repositories/bus_boarding_repository.dart';
import 'package:sdp/data/repositories/location_repository.dart';
import 'package:sdp/data/repositories/login_repository.dart';
import 'package:sdp/data/repositories/tickets_repository.dart';
import 'package:sdp/presentation/screens/generate_qr_code.dart';
import 'package:sdp/presentation/screens/google_maps.dart';
import 'package:sdp/presentation/screens/homepage_screen.dart';
import 'package:sdp/presentation/screens/location_screen.dart';
import 'package:sdp/presentation/screens/login_screen2.dart';
import 'package:sdp/presentation/screens/payment_screen.dart';
import 'package:sdp/presentation/screens/scanner_screen.dart';
import 'package:sdp/presentation/screens/settings_screen.dart';
import 'package:sdp/presentation/screens/signup_screen2.dart';
import 'package:sdp/presentation/screens/wallet.dart';
import 'package:sdp/presentation/screens/your_tickets.dart';
import 'package:sdp/presentation/screens/New_welcome.dart';
import 'data/repositories/signup_repository.dart';

void main() {
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

  final LocationBloc _locationBloc =
      LocationBloc(locationRepos: LocationRepository());

  final Login2Bloc _login2Bloc = Login2Bloc(authRepo: LoginRepository());

  final SignupBloc _signupBloc = SignupBloc(signupRepo: SignupRepository());

  final BusBoardingBloc _busBoardingBloc =
      BusBoardingBloc(busBoardingRepos: BusBoardingRepository());

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
                    value: _locationBloc,
                  ),
                  BlocProvider.value(
                    value: _busBoardingBloc,
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
          '/yourTickets': (context) => BlocProvider.value(
                value: _ticketsBloc,
                child: YourTickets(),
              ),
          '/generateCode': (context) => BlocProvider.value(
                value: _ticketsBloc,
                child: GeneratePage(),
              ),
          '/scanner': (context) => BlocProvider.value(
                value: _busBoardingBloc,
                child: Scanner(),
              ),
          '/location': (context) => BlocProvider.value(
                value: _locationBloc,
                child: CheckLiveLocation(),
              ),
          '/settings': (context) => BlocProvider.value(
                value: _locationBloc,
                child: SettingsFourPage(),
              ),
          '/wallet': (context) => BlocProvider.value(
                value: _locationBloc,
                child: Wallet(),
              ),
          '/map': (context) => BlocProvider.value(
                value: _locationBloc,
                child: MapSample(),
              ),
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ticketsBloc.close();
    super.dispose();
  }
}
