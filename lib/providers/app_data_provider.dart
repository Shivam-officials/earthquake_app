import 'dart:convert';

import 'package:earthquake_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/earthquake_model.dart';

final baseAddress = 'https://earthquake.usgs.gov/fdsnws/event/1/query';

class AppDataProvider extends ChangeNotifier {
  final baseUrl = Uri.parse(baseAddress);
  Map<String, dynamic> queryParameters = {};
  double _maxRadiusKm = 500;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _startTime = '';
  String _endTime = '';
  String _orderBy = 'time';
  String? _currentCity;
  EarthquakeModel? earthquakeModel;
  final double _maxRadiusKmThreshold = 20001.6;
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

  Color getAlertColor(String color){
    return switch(color){
      "green" =>Colors.green,
      "yellow" =>Colors.yellow,
      "orange" =>Colors.orange,
      _ => Colors.red
    };
  }
  Future<void> getEarthquakeData() async{
    final uri = Uri.https(baseUrl.authority, baseUrl.path, queryParameters);
    debugPrint(uri.toString());
    try{
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        earthquakeModel = EarthquakeModel.fromJson(json);
        debugPrint(earthquakeModel!.features!.length.toString());
        notifyListeners();
      }
    }catch(error){
      debugPrint(error.toString());
    }
  }
}
