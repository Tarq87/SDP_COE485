import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as global;

class MyLocation extends StatefulWidget {
  @override
  State<MyLocation> createState() => MyLocationState();
}

class MyLocationState extends State<MyLocation> {
  StreamSubscription? _locationSubscription;
  global.Location _locationTracker = global.Location();
  Marker? marker;
  Circle? circle;
  GoogleMapController? _controller;

  // should be initialized just in case
  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;
  late double altitude;
  late double speed;
  late double locationAccuracy;
  late double speedAccuracy;

  Future<Uint8List> getPersonMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/photos/person.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      global.LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("me"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("accuracy"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getPersonMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
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

  static final CameraPosition _kKFUPM = CameraPosition(
    target: LatLng(26.30713914704697, 50.14587577811144),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('My location'),
        actions: [],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kKFUPM,
        markers: Set.of((marker != null) ? [marker!] : []),
        circles: Set.of((circle != null) ? [circle!] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getCurrentLocation,
        label: Text('go My location'),
        icon: Icon(Icons.location_searching),
      ),
    );
  }
}
