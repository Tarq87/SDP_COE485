import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/buses_bloc/buses_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/stations_bloc/stations_bloc.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  bool requestStationsOnce = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
        title: Text('Maps'),
      ),
      body: SingleChildScrollView(
        child: MultiBlocListener(
          listeners: [
            BlocListener<StationsBloc, StationsState>(
              listener: (context2, state) {
                // && context.read<BusesBloc>().state.requesting
                if (state.requesting) {
                  _showSnackBar(
                      context2, 'requesting Stations and Buses locations');
                  // && context.read<BusesBloc>().state.busesReceived
                } else if (state.stationsReceived) {
                  context.read<BusesBloc>().add(RequestBuses());
                  state.stationsReceived = false;
                } else {
                  // return Text('Unable to locate Bus Stations');
                }
              },
            ),
            BlocListener<BusesBloc, BusesState>(
              listener: (context, state) {
                if (state.requesting) {
                } else if (state.busesReceived) {
                  _showSnackBar(
                      context, 'Stations and Buses have been located');
                  // this remove all previous routes !!
/*
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/MapsRouting", (r) => false);
                      */
                  Navigator.popAndPushNamed(context, '/MapsRouting');
                } else {
                  _showSnackBar(context, 'Stations and Buses are not located');
                }
              },
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              /*
        
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                          onSurface: Colors.grey,
                          side: BorderSide(color: Colors.black, width: 1),
                          elevation: 20,
                          minimumSize: Size(150, 50),
                          shadowColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(context, '/MyLocation');
                        },
                        child: Text('My Location'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                          onSurface: Colors.grey,
                          side: BorderSide(color: Colors.black, width: 1),
                          elevation: 20,
                          minimumSize: Size(150, 50),
                          shadowColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () async {
                          if (requestStationsOnce) {
                            requestStationsOnce = false;
                            Navigator.pushNamed(context, '/TraceBuses');
                          }
                        },
                        child: Text('Trace Buses'),
                      ),
        
        */
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                  onSurface: Colors.grey,
                  side: BorderSide(color: Colors.black, width: 1),
                  elevation: 20,
                  minimumSize: Size(150, 50),
                  shadowColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  context.read<StationsBloc>().add(RequestStations());
                },
                child: Text('Display Buses and Stations'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
