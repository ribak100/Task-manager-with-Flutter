import 'package:flutter/material.dart';
import './home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 7), vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
          children: [
            Lottie.network(
                'https://assets4.lottiefiles.com/packages/lf20_mf5j5kua.json'),
            FlatButton(
              textColor: Colors.blue,
                onPressed: () async {
                  controller.reset();
                  controller.forward();
                  await Future.delayed(Duration(seconds: 6));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreen(), maintainState: true));
                },
                child: Column(
                  children: [
                      Lottie.network(
                          "https://assets2.lottiefiles.com/private_files/lf30_9zobda8d.json",
                          height: 220.0,
                          controller: controller),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text("CLICK HERE", style: GoogleFonts.montserrat()),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
