import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({
    super.key,
    this.color,
    required this.image,
    required this.title,
    required this.description,
    this.fontColor = Colors.black,
  });

  Color? color;
  final String image;
  final String title;
  final String description;
  final Color fontColor;

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
          children: [
            Image.asset(
              image,
              width: MediaQuery.of(context).size.height * 0.4,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 16,
                left: 26,
                right: 26,
              ),
              child: Text(
                title,
                style: GoogleFonts.lilitaOne(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: fontColor),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: fontColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
