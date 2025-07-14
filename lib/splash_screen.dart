import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_application/Weather_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WeatherPage()));
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/splash.json'),
            Text("ClimateIQ",style: TextStyle(color: Colors.grey.shade300,fontFamily: 'abels',fontSize: 55,fontWeight: FontWeight.w700),),
            Text("Weather Services",style: TextStyle(color: Colors.grey,fontFamily: 'abels',fontSize: 25,fontWeight: FontWeight.w700),),
          ],
        ),
      ),
    );
  }
}
