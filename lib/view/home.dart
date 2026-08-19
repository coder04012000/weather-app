import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weaterapp/view/searchscreen.dart';
import 'package:intl/intl.dart';

import '../provider/homeprovider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<HomePageProvider>(context, listen: false);
      await provider.loadCurrentWeather();
      await provider.loadSavedCities();
    });
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

    if (provider.cities.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    return Scaffold(
      body: PageView.builder(
        itemCount: provider.cities.length,
        onPageChanged: (index) {
          provider.currentIndex = index;
          provider.notifyListeners();
        },
        itemBuilder: (context, index) {
          final city = provider.cities[index];

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: provider.getBackgroundColors(city.desc),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(provider.cities.length, (index) {
                      return Container(
                        margin: EdgeInsets.all(4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.currentIndex == index
                              ? Colors.white
                              : Colors.white24,

                        ),
                      );
                    }),
                  ),

                  Text(
                    city.city,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Icon(
                    provider.getWeatherIconFromCode(city.icon),
                    size: 100,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${city.temp}°C",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    city.desc.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _detailTile("Humidity", "${city.humidity}%"),
                      _detailTile("Wind", "${city.wind} m/s"),
                      _detailTile("Pressure", "${city.pressure} hPa"),
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
                      itemCount: city.hourly.length,
                      itemBuilder: (context, i) {
                        final item = city.hourly[i];

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
                              const SizedBox(height: 5),
                              Icon(
                                provider.getWeatherIconFromCode(item['icon']),
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
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
                    itemCount: city.daily.length,
                    itemBuilder: (context, i) {
                      final item = city.daily[i];

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
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchPage()),
          );
        },
        child: const Icon(Icons.add),
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
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
