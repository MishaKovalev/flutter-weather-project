import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/models.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/";
  static const BASE_GEOCODING_URL =
      "https://api.openweathermap.org/geo/1.0/reverse";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<CurrentDayForecast> getCurrentDayWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('${BASE_URL}weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return CurrentDayForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<List<NextDayForecast>> getWeekForecast(String cityName) async {
    final response = await http.get(Uri.parse(
        '${BASE_URL}forecast?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      var forecastList = (jsonDecode(response.body)['list'] as List)
          .map((value) => NextDayForecast.fromJson(value))
          .toList();
      return forecastList;
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCityName() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await http.get(Uri.parse(
        '$BASE_GEOCODING_URL?lat=${position.latitude}&lon=${position.longitude}&limit=1&appid=$apiKey'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body[0]['name'];
    } else {
      return "";
    }
  }
}
