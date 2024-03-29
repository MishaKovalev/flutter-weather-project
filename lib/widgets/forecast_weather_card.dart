import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather_app/config/keys.dart';

class ForecastWeatherCard extends StatelessWidget {
  const ForecastWeatherCard({
    super.key,
    required NextDayForecast forecast,
  }) : _forecast = forecast;

  final NextDayForecast _forecast;

  String getForecastDate(NextDayForecast forecastWeather) {
    DateFormat parseFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime parsedDate = parseFormatter.parse(forecastWeather.forecastDate);

    DateFormat formatter = DateFormat("dd MMMM HH:mm");

    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            getForecastDate(_forecast),
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image(image: AssetImage("$imageLink${_forecast.icon}.png")),
          Text(
            "${_forecast.temperature.round()}°C feels ${_forecast.feelsLike.round()}°C",
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Max: ${_forecast.tempMax.round()}°C",
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Min: ${_forecast.tempMin.round()}°C",
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
