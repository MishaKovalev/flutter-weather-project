import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_weather_app/config/keys.dart';
import 'package:flutter_weather_app/models/models.dart';
import 'package:flutter_weather_app/services/services.dart';
import 'package:flutter_weather_app/widgets/current_forecast.dart';
import 'package:flutter_weather_app/widgets/next_day_forecast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(apiKey);
  CurrentDayForecast? _weather;
  List<NextDayForecast> _forecast = [];
  String? _cityName;
  late String currentDate;

  _fetchCityName() async {
    String cityName = await _weatherService.getCurrentCityName();

    setState(() {
      _cityName = cityName;
    });
  }

  _updateCityName(String value) {
    setState(() {
      _cityName = value;
    });
  }

  _fetchCurrentWeather() async {
    String cityName = _cityName ?? await _weatherService.getCurrentCityName();

    try {
      final weather = await _weatherService.getCurrentDayWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchWeekForecast() async {
    String cityName = _cityName ?? await _weatherService.getCurrentCityName();

    try {
      final forecastList = await _weatherService.getWeekForecast(cityName);
      setState(() {
        _forecast = forecastList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchCityName();
    _fetchCurrentWeather();
    _fetchWeekForecast();

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("dd MMMM yyyy");
    currentDate = formatter.format(now);
  }

  SnackBar snackBarFactory(String text) {
    return SnackBar(
      content: Text(text),
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      width: 400,
      showCloseIcon: true,
      backgroundColor: Colors.red,
      duration: Durations.extralong4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Weather App",
          style: GoogleFonts.montserratAlternates(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 93, 183, 231),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          child: SearchBar(
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            elevation: const MaterialStatePropertyAll<double>(1.0),
            hintText: "Enter city name...",
            onSubmitted: (value) {
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    snackBarFactory("City Name cannot be empty!"));
              } else {
                _updateCityName(value);
                _fetchCurrentWeather();
                _fetchWeekForecast();
              }
            },
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
            width: 350,
            child: ((_weather == null)
                ? const SpinKitCircle(
                    color: Color.fromARGB(255, 93, 183, 231),
                    size: 50,
                  )
                : CurrentForecast(
                    weather: _weather,
                    currentDate: currentDate,
                  ))),
        const SizedBox(height: 30),
        SizedBox(
            height: 250,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus
                }),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _forecast.length,
                  itemBuilder: (context, index) {
                    return NextDayForecastCard(
                      forecast: _forecast[index],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                ),
              ),
            )),
      ],
    ))));
  }
}
