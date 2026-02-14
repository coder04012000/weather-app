import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/homemodel.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<HomePageProvider>(context, listen: false)
            .loadWeather());
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<HomePageProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(provider.error)),
      );
    }

    return Scaffold(
     // backgroundColor: provider.getBackgroundColors(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.getBackgroundColors(),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 20),
                Text(
                  provider.cityName,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                const SizedBox(height: 10),
                Icon(
                  provider.getWeatherIconFromCode(provider.icon),
                  size: 100,
                  color: Colors.white,
                ),

                Text(
                  "${provider.temperature}°C",
                  style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  provider.description.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _detailTile("Humidity", "${provider.humidity}%"),
                    _detailTile("Wind", "${provider.windSpeed} m/s"),
                    _detailTile("Pressure", "${provider.pressure} hPa"),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.hourlyList.length,
                    itemBuilder: (context, index) {

                      final item = provider.hourlyList[index];

                      final time = DateFormat('HH:mm')
                          .format(DateTime.parse(item['time']));

                      return Container(
                        width: 90,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(time,
                                style: const TextStyle(color: Colors.white)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                provider.getWeatherIconFromCode(item['icon']),
                                color: Colors.white,
                              ),
                            )
                            ,
                            Text(
                              "${item['temp']}°C",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "5 Day Forecast",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.dailyList.length,
                  itemBuilder: (context, index) {

                    final item = provider.dailyList[index];

                    final day = DateFormat('EEE')
                        .format(DateTime.parse(item['date']));

                    return ListTile(
                      leading: Text(
                        day,
                        style: const TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        "${item['temp']}°C",
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(
                        provider.getWeatherIconFromCode(item['icon']),
                        color: Colors.white,
                      )

                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}



