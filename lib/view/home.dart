import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/homemodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<HomePageProvider>().getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyanAccent,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Assets/Images/backrain.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 50,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Friday',
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //Spacer(),
                      //Padding(padding: EdgeInsets.only(right: 10),child: ,)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20),
                  child: Row(
                    children: [
                      Text(
                        'Oct 18 2000',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Pair, London',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Image(image: AssetImage("Assets/Images/rain.png")),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Text(
                          '29',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 90),
                        ),
                        Text(
                          '°C',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 90),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 40.0, bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        'Sunny',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
