import 'dart:convert';

import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as gc;

import '../models/earthquake_model.dart';

final baseAddress = 'https://earthquake.usgs.gov/fdsnws/event/1/query';

class AppDataProvider extends ChangeNotifier {
  final baseUrl = Uri.parse(baseAddress);
  Map<String, dynamic> queryParameters = {};
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _startTime = '';
  String _endTime = '';
  String _orderBy = 'time';
  String? _currentCity;
  EarthquakeModel? earthquakeModel;

  final double _maxRadiusKmThreshold = 20001.6;

  double _maxRadiusKm = 500;
  bool _shouldUseLocation = false;

  //  getters for private fields
  double get maxRadiusKm => _maxRadiusKm;

  double get latitude => _latitude;

  double get longitude => _longitude;

  String get startTime => _startTime;

  String get endTime => _endTime;

  String get orderBy => _orderBy;

  String? get currentCity => _currentCity;

  double get maxRadiusKmThreshold => _maxRadiusKmThreshold;

  bool get shouldUseLocation => _shouldUseLocation;

  set shouldUseLocation(bool value) {
    _shouldUseLocation = value;
  }

  //setter
  set orderBy(String value) {
    _orderBy = value;
  }

  _setQueryParameter() {
    queryParameters['format'] = 'geojson';
    queryParameters['starttime'] = _startTime;
    queryParameters['endtime'] = _endTime;
    queryParameters['orderby'] = _orderBy;
    queryParameters['minmagnitude'] = '4';
    queryParameters['latitude'] = '$_latitude';
    queryParameters['longitude'] = '$_longitude';
    queryParameters['maxradiuskm'] = '$_maxRadiusKm';
    queryParameters['limit'] = '500';
  }

  // method to set queryParameter along with _startTime and _endTime with by default 1 day range from current date
  init() {
    _startTime = getFormattedDateTime(
      DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
    );
    _endTime = getFormattedDateTime(DateTime.now().millisecondsSinceEpoch);
    _maxRadiusKm =
        maxRadiusKmThreshold; //todo why this is defined why didn't we defined that by default earlier
    _setQueryParameter();
    getEarthquakeData();
  }

  Color getAlertColor(String color) {
    return switch (color) {
      "green" => Colors.green,
      "yellow" => Colors.yellow,
      "orange" => Colors.orange,
      _ => Colors.red,
    };
  }

  void setOrder(String order) {
    orderBy = order;
    notifyListeners();
    _setQueryParameter();
    getEarthquakeData();
  }

  Future<void> getEarthquakeData() async {
    EasyLoading.show(status: "updated data fetching");
    final uri = Uri.https(
      baseUrl.authority, // Domain (e.g., "example.com")
      baseUrl.path, // Path of the endpoint (e.g., "/api/v1/data")
      queryParameters, // Optional query params (e.g., {"id": "123"})
    );
    debugPrint(uri.toString());
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        earthquakeModel = EarthquakeModel.fromJson(json);
        debugPrint(earthquakeModel!.features!.length.toString());
        notifyListeners();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    EasyLoading.dismiss();
  }

  void setStartDate(DateTime dateTime) {
    _startTime = getFormattedDateTime(dateTime.millisecondsSinceEpoch);
    _setQueryParameter();
    notifyListeners();
  }

  void setEndDate(DateTime dateTime) {
    _endTime = getFormattedDateTime(dateTime.millisecondsSinceEpoch);
    _setQueryParameter();
    notifyListeners();
  }



  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> setLocation(bool value) async {
    _shouldUseLocation = value;
    notifyListeners();
    if (value) {
      final position = await _determinePosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
       await getStreetName();
      _maxRadiusKm = 500;
      _setQueryParameter();
      getEarthquakeData();
    } else{
      _latitude = 0.0;
      _longitude = 0.0;
      _currentCity = null;
      _maxRadiusKm = maxRadiusKmThreshold;
      _setQueryParameter();
      getEarthquakeData();
    }
  }

  Future<void> getStreetName()async{
    try{
      final placemarkList = await gc.placemarkFromCoordinates(
          latitude, longitude);
      if (placemarkList.isNotEmpty) {
        _currentCity = placemarkList.first.locality!;
      }
      notifyListeners();
    }catch(error){
      debugPrint(error.toString());
    }
  }
}
