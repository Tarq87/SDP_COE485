import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sdp/bussiness_logic/blocs/buses_bloc/buses_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/stations_bloc/stations_bloc.dart';
import 'package:location/location.dart' as global;

class MapsRouting extends StatefulWidget {
  @override
  _MapsRoutingState createState() => _MapsRoutingState();
}

class _MapsRoutingState extends State<MapsRouting> {
  StreamSubscription? _locationSubscription;
  global.Location _locationTracker = global.Location();
  late GoogleMapController mapController;
  // KFUPM route 1
  // double _s1Latitude = 26.31319, _s1Longitude = 50.14827;
  // double _s2Latitude = 26.30500, _s2Longitude = 50.14757;
  // double _s3Latitude = 26.31463, _s3Longitude = 50.13977;
  double _s1Latitude = 26.31319, _s1Longitude = 50.14827;

  /*
  double _s2Latitude = 26.30500, _s2Longitude = 50.14757;
  double _s3Latitude = 26.31463, _s3Longitude = 50.13977;

  */

  // Encoded Polyline from GoogleMaps between three bus station
  String encodedPolylineOf123 = 'mhr_DuqaqHdr@jCe{@vo@';

  // this part for bus emulator
  late Marker tmpMarker;
  late Circle tmpCircle;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBXugk_q8_JKSTFhNHswlWniDJC0XjAoUg";

  List<String> stationsNames = [];
  List<double> stationsLat = [];
  List<double> stationsLong = [];

  List<String> buses_id = [];
  List<double> busesLat = [];
  List<double> busesLong = [];

  String _placeDistance = '';
  List<double> distnaceFromStation = [];
  bool stationsDistanceFilled = false;
  bool enableBusesUpdate = true;

  late LatLng userLatLong;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await getAndMarkCurrentLocation(); // make sure that the userLatLong is initialized
    await Future.delayed(Duration(seconds: 4)); // waiting to enhance accuracy
    locateNearestStation();
    await Future.delayed(Duration(seconds: 1));
    context.read<BusesBloc>().add(RequestBuses());
  }

  void locateNearestStation() async {
    _showSnackBar(context, 'Finding Nearest Station');

    // after obtaining the current location, find the nearest bus station from the user
    if (stationsLat.length > 0) {
      for (int i = 0; i <= (stationsLat.length - 1); i++) {
        print(
            '>>>>>>>>> Finding station ${stationsNames[i]} at index $i distance from the your current location\n');
        // distanceFromStation list will be filled in the same order as the stationNames
        await findDistance(
            PointLatLng(userLatLong.latitude, userLatLong.longitude),
            PointLatLng(stationsLat[i], stationsLong[i]));
      }
    }

    // find nearest station index
    int nearestStationIndex = findNearestStation();
    print(
        '>>>>>> the Nearest Station from you is ${stationsNames[nearestStationIndex]}\n');

    // add the polyline between the user and the nearest station
    _getPolyline(
      PointLatLng(userLatLong.latitude, userLatLong.longitude),
      PointLatLng(
          stationsLat[nearestStationIndex], stationsLong[nearestStationIndex]),
      'Me',
      stationsNames[nearestStationIndex],
    );
  }

  @override
  void initState() {
    super.initState();

    /*
    /// Station1
    _addStationsMarker(LatLng(_s1Latitude, _s1Longitude), "Station 1");

    /// station2
    _addStationsMarker(LatLng(_s2Latitude, _s2Longitude), "Station 2");

    /// station3
    _addStationsMarker(LatLng(_s3Latitude, _s3Longitude), "Station 3");

    */

    // make sure the lat and long are not reversed !!!!!!!
    stationsNames = context.read<StationsBloc>().state.names;
    stationsLat = context.read<StationsBloc>().state.lats;
    stationsLong = context.read<StationsBloc>().state.longs;

    // buses initial location
    buses_id = context.read<BusesBloc>().state.buses_id;
    busesLat = context.read<BusesBloc>().state.lats;
    busesLong = context.read<BusesBloc>().state.longs;

    // _addBusMarker(LatLng(_s1Latitude, _s1Longitude), "1001"); // for testing
    print(
        '################### From Buses Routing Screen ###################\n');
    if (buses_id.length > 0) {
      for (int i = 0; i <= (buses_id.length - 1); i++) {
        print(
            'Bus ID: ${buses_id[i]}, latitude: ${busesLat[i]}, longitude: ${busesLong[i]}\n');
        _addBusMarker(
            LatLng(busesLat[i], busesLong[i]), buses_id[i]); // for testing
      }
    }

    // adding stations markers stations
    print(
        '################### From Buses Routing Screen ###################\n');
    if (stationsNames.length > 0) {
      for (int i = 0; i <= (stationsNames.length - 1); i++) {
        print(
            'Station name: ${stationsNames[i]}, latitude: ${stationsLat[i]}, longitude: ${stationsLong[i]}\n');
        _addStationsMarker(
            LatLng(stationsLat[i], stationsLong[i]), stationsNames[i]);
      }
    }

/*
    if (stationsNames.length > 0) {
      for (int i = 0; i <= (stationsNames.length - 2); i++) {
        _getPolyline(
            PointLatLng(stationsLat[i], stationsLong[i]),
            PointLatLng(stationsLat[i + 1], stationsLong[i + 1]),
            stationsNames[i],
            stationsNames[i + 1]);
      }
      polylineCoordinates = [];
    }
*/

    /*

    _getPolyline(PointLatLng(_s1Latitude, _s1Longitude),
        PointLatLng(_s2Latitude, _s2Longitude));
    _getPolyline(PointLatLng(_s2Latitude, _s2Longitude),
        PointLatLng(_s3Latitude, _s3Longitude));

        */
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> findDistance(PointLatLng p1, PointLatLng p2) async {
    // initializing the polyline coordinates
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      p1,
      p2,
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    //start calculatin the distance
    double totalDistance = 0.0;

// Calculating the total distance by adding the distance
// between small segments
    for (int i = 0; i < polylineCoordinates.length - 2; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
    // add the distance between the user and first bus station to the double list for later comparison

    distnaceFromStation.add(
        totalDistance); // at 0 is the total distance between station0 and the user

    //reset polylines coordinates to calculate another route
    polylineCoordinates = [];

// Storing the calculated total distance of the route
    _placeDistance = totalDistance.toStringAsFixed(2);
    print(
        '>>>>> DISTANCE: $_placeDistance km,  at index ${distnaceFromStation.length - 1}');
  }

  int findNearestStation() {
    print('>>>>>>>>>> stations Distances from user: $distnaceFromStation ');
    double smallest = distnaceFromStation[0]; // assume it is at 0
    int nearestStationIndex = 0;
    for (int i = 1; i <= (distnaceFromStation.length - 1); i++) {
      if (distnaceFromStation[i] < smallest) {
        smallest = distnaceFromStation[i];
        nearestStationIndex = i;
      }
    }
    // String variable just in case :)
    _placeDistance = smallest.toStringAsFixed(2);
    print(
        '>>>>>>>>> Nearest station DISTANCE: $_placeDistance km, and the index is $nearestStationIndex');

    return nearestStationIndex;
  }

  Future<Uint8List> getPersonMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/photos/person.png");
    return byteData.buffer.asUint8List();
  }

  Future<void> getAndMarkCurrentLocation() async {
    try {
      Uint8List imageData = await getPersonMarker();
      var location = await _locationTracker.getLocation();
      double? tmpLat = location.latitude;
      double? tmpLong = location.longitude;

      if (tmpLat != null && tmpLong != null) {
        userLatLong = LatLng(tmpLat, tmpLong);
      }
      print('>>>>>>>>> Initial user Location obtained: $userLatLong');
      updateMarkerAndCircle(userLatLong, imageData, "Me");

      // set initial camera on the user location for the first time
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(userLatLong.latitude, userLatLong.longitude),
              tilt: 0,
              zoom: 18.00)));

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        double? tmpLat = newLocalData.latitude;
        double? tmpLong = newLocalData.longitude;

        if (tmpLat != null && tmpLong != null) {
          userLatLong = LatLng(tmpLat, tmpLong);
        }
        // no need to animate camera for now
        /*
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(newLocalData.latitude!, newLocalData.longitude!),
                tilt: 0,
                zoom: 18.00)));
                */
        updateMarkerAndCircle(userLatLong, imageData, "Me");
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("permission Denied");
      }
    }
  }

  // very important for app preformance
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  _addBusMarker(LatLng latlng, String markerid) async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/photos/bus_top_view.png");
    Uint8List busimageData = byteData.buffer.asUint8List();

    tmpMarker = Marker(
        markerId: MarkerId(markerid),
        position: latlng,
        rotation:
            0.0, // beccause it's not an actual device, just point on the map
        infoWindow: InfoWindow(
          title: 'Bus ID: $markerid',
          snippet: '*',
        ),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(busimageData));
    tmpCircle = Circle(
        circleId: CircleId("accuracy"),
        radius: 0, // beccause it's not an actual device, just point on the map
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(70));
    MarkerId markerId = MarkerId(markerid);
    setState(() {
      markers[markerId] = tmpMarker;
    });
  }

  _addStationsMarker(LatLng position, String stationName) async {
    ByteData byteData2 = await DefaultAssetBundle.of(context)
        .load("assets/photos/bus_station.png");
    Uint8List stationimageData = byteData2.buffer.asUint8List();

    print('####### Stations Marker #########');
    print('station name: $stationName');

    MarkerId markerId = MarkerId(stationName);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(
        title: stationName,
        snippet: '*',
      ),
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      onTap: () {},
      icon: BitmapDescriptor.fromBytes(stationimageData),
    );
    setState(() {
      markers[markerId] = marker;
    });

    print('Marker: ${marker.markerId}');
    print('#######  #########');
  }

  _addPolyLine(String s1, String s2) {
    setState(() {
      PolylineId id = PolylineId(
          '$s1/$s2'); // polyline id or name between two consequitive statinos
      Polyline polyline = Polyline(
          polylineId: id, color: Colors.red, points: polylineCoordinates);
      polylines[id] = polyline;
      polylineCoordinates =
          []; // reset the polyline coordinates to create new polyline
    });
  }

  _getPolyline(PointLatLng p1, PointLatLng p2, String s1, String s2) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      p1,
      p2,
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine(s1, s2);
  }

  void updateMarkerAndCircle(
      LatLng latlng, Uint8List imageData, String markerid) {
    this.setState(() {
      tmpMarker = Marker(
          markerId: MarkerId(markerid),
          position: latlng,
          rotation:
              0.0, // beccause it's not an actual device, just point on the map
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      tmpCircle = Circle(
          circleId: CircleId("accuracy"),
          radius:
              0, // beccause it's not an actual device, just point on the map
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
      MarkerId markerId = MarkerId(markerid);
      markers[markerId] = tmpMarker;
    });
  }

/*
  void busEmulator(BuildContext context) async {
    try {
      ByteData byteData = await DefaultAssetBundle.of(context)
          .load("assets/photos/bus_top_view.png");
      Uint8List busimageData = byteData.buffer.asUint8List();
      LatLng points = polylineCoordinates[0];
      updateMarkerAndCircle(points, busimageData, '1001');

      for (var points in polylineCoordinates) {
        print(points);
        updateMarkerAndCircle(points, busimageData, '1001');

        mapController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(points.latitude, points.longitude),
                tilt: 0,
                zoom: 18.00)));
        await Future.delayed(Duration(milliseconds: 500));
      }
      _showSnackBar(context, 'Bus Emulation Completed');
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("permission Denied");
      }
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
          title: Text('Buses Routing'),
        ),
        body: BlocListener<BusesBloc, BusesState>(
          listener: (context, state) async {
            if (state.requesting) {
              print('>>>>>>>>>>>>> Updating buses location....');
              await Future.delayed(Duration(milliseconds: 300));
            } else if (state.busesReceived) {
              // buses initial location
              print('>>>>>>>>>>>>> buses location Updated.');
              buses_id = state.buses_id;
              busesLat = state.lats;
              busesLong = state.longs;
              if (buses_id.length > 0) {
                for (int i = 0; i <= (buses_id.length - 1); i++) {
                  print(
                      'Bus ID: ${buses_id[i]}, latitude: ${busesLat[i]}, longitude: ${busesLong[i]}\n');
                  _addBusMarker(LatLng(busesLat[i], busesLong[i]),
                      buses_id[i]); // for testing
                }
              }
              await Future.delayed(Duration(seconds: 5));
              state.busesReceived = false;
              context.read<BusesBloc>().add(RequestBuses());
            }
          },
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(_s1Latitude, _s1Longitude), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
        ),
/*
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            busEmulator(context);
          },
          label: Text('start bus emulator'),
          icon: Icon(Icons.location_searching),
        ),
*/
      ),
    );
  }

/*
  if (state.requesting) {
              _showSnackBar(context, 'requesting Stations locations');
              return Text('Requesting Stations Location.');
            } else if (requestStationsOnce) {
              requestStationsOnce = false;
              context.read<StationsBloc>().add(RequestStations());
              return Text('Stations Location requested.');
            } else if (state.stationsReceived) {
              stationsNames = state.names;
              stationsLat = state.lats;
              stationsLong = state.longs;
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(_s1Latitude, _s1Longitude), zoom: 15),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              );
            } else {
              _showSnackBar(context, 'Stations are not located');
              return Text('Unable to locate Bus Stations');
            }

            */

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
