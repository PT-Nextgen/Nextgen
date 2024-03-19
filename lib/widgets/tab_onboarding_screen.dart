import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TabOnboardingScreen extends StatelessWidget {
  TabOnboardingScreen(
      {super.key,
      this.color,
      required this.image,
      required this.title,
      required this.description});

  Color? color;
  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 26,
        ),
        color: color ?? Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: MediaQuery.of(context).size.height * 0.4,
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                // vertical: 50,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: const EdgeInsets.only(
                      // top: 30,
                      bottom: 16,
                      left: 26,
                      right: 26,
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.lilitaOne(
                        fontWeight: FontWeight.bold,
                        fontSize: 52,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
