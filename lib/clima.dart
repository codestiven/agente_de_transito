import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Estadoclima extends StatefulWidget {
  @override
  _EstadoclimaState createState() => _EstadoclimaState();
}

class _EstadoclimaState extends State<Estadoclima> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  String address = '';
  String weatherInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mostrar clima'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitud'),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitud'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                double latitude = double.parse(latitudeController.text);
                double longitude = double.parse(longitudeController.text);

                _fetchWeather(latitude, longitude);
              },
              child: Text('Siguiente'),
            ),
            if (address.isNotEmpty || weatherInfo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clima en la zona: $weatherInfo',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    try {
      final apiUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m,is_day,rain,snowfall,cloud_cover&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final currentWeather = data['current'];

        String weatherCondition = _interpretWeatherCondition(
          currentWeather['temperature_2m'],
          currentWeather['is_day'],
          currentWeather['rain'],
          currentWeather['snowfall'],
          currentWeather['cloud_cover'],
        );

        setState(() {
          weatherInfo =
              '$weatherCondition \n \nTemperatura: ${currentWeather['temperature_2m']}°C \n \nVelocidad del viento: ${currentWeather['wind_speed_10m']} m/s';
        });

        _showLocationInfo(context, latitude, longitude);
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  String _interpretWeatherCondition(double temperature, int isDay, double rain,
      double snowfall, int cloudCover) {
    if (isDay == 1) {
      // It's daytime
      if (cloudCover < 50 && isDay == 0) {
        // Less than 50% cloud cover, consider it sunny
        return 'Soleado';
      } else if (rain > 0.0) {
        // Some rainfall, consider it rainy
        return 'Lluvioso';
      } else {
        // Otherwise, consider it cloudy
        return 'Nublado';
      }
    } else {
      // It's nighttime, you might have different conditions for nighttime
      // You can adjust these based on your preferences
      if (cloudCover < 50 && isDay == 1) {
        // Less than 50% cloud cover, consider it clear (assuming less cloudy)
        return 'Despejado';
      } else {
        // Otherwise, consider it cloudy
        return 'Nublado';
      }
    }
  }

  void _showLocationInfo(
    BuildContext context,
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          address = '${placemark.locality ?? ''}, ${placemark.country}';
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Clima en la zona'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Text('Clima: $weatherInfo'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle case where no placemarks were found
        print('No address found for the given coordinates.');
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }
}
