import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:myproject/config/theme.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData _locationData =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  String? message;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => getLocation());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    ph.PermissionStatus permission = await ph.Permission.location.status;
    print(permission);
    if (permission.isDenied) {
      permission = await ph.Permission.location.request();
      print(['after: ', permission]);
      if (permission.isDenied) {
        return;
      }
    }

    _locationData = await location.getLocation();


    double distance = calculateDistance(_locationData.latitude!,
        _locationData.longitude!, 36.1028509, 129.387156);
    double bearing = calculateBearing(_locationData.latitude!,
        _locationData.longitude!, 36.1028509, 129.387156);

    setState(() {
      String direction = getDirection(bearing);
      message =
          '오석관은 현재 위치에서 $direction 방향으로 ${distance.toStringAsFixed(2)} 미터 떨어져 있습니다.';
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 2 * 6371000 * math.asin(math.sqrt(a));
  }

  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    var y = math.sin(lon2 - lon1) * math.cos(lat2);
    var x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(lon2 - lon1);
    var bearing = math.atan2(y, x) * 180 / math.pi;

    bearing = (bearing + 360) % 360;
    return bearing;
  }

  String getDirection(double bearing) {
    String direction = "";

    if (bearing >= 22.5 && bearing < 67.5) {
      direction = "북동쪽";
    } else if (bearing >= 67.5 && bearing < 112.5) {
      direction = "동쪽";
    } else if (bearing >= 112.5 && bearing < 157.5) {
      direction = "남동쪽";
    } else if (bearing >= 157.5 && bearing < 202.5) {
      direction = "남쪽";
    } else if (bearing >= 202.5 && bearing < 247.5) {
      direction = "남서쪽";
    } else if (bearing >= 247.5 && bearing < 292.5) {
      direction = "서쪽";
    } else if (bearing >= 292.5 && bearing < 337.5) {
      direction = "북서쪽";
    } else {
      direction = "북쪽";
    }

    return direction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColorTheme.primary,
        title: const Text('Location Tracker',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Text(
            message ?? '위치를 불러오는 중...',
            softWrap: true,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
