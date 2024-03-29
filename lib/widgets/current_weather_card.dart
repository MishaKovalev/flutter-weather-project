import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../models/models.dart';

class CurrentForecast extends StatelessWidget {
  const CurrentForecast({
    super.key,
    required CurrentDayForecast? weather,
    required this.currentDate,
  }) : _weather = weather;

  final CurrentDayForecast? _weather;
  final String currentDate;
  static const imageLink = "http://openweathermap.org/img/w/";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        Text(
          _weather?.cityName ?? "loading city...",
          style: GoogleFonts.montserrat(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "$currentDate ",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Image(image: AssetImage("$imageLink${_weather!.icon}.png")),
        Text(
          "Temperature: ${_weather.temperature.round()}°C",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Feels like: ${_weather.feelsLike.round()}°C",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Max Temperature: ${_weather.tempMax.round()}°C",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Min Temperature: ${_weather.tempMin.round()}°C",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )
      ]),
    )));
  }
}
