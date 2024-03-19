import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:nextgen_app/pages/main_page.dart';
import 'package:nextgen_app/widgets/onboarding_screen.dart';
import 'package:nextgen_app/widgets/tab_onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  LiquidController pageController = LiquidController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final double aspectRatio = screenWidth / screenHeight;

    double tabletAspectRatioThreshold = 1.3;

    // print(
    //   'Screen lebih kecil dari 600 ? ${(screenWidth < 600)}, Ukuran screen : $screenWidth, Acpect Ratio Threshold: $aspectRatio',
    // );

    final pages = [
      OnboardingScreen(
        fontColor: Colors.white,
        color: Colors.blue[300],
        image: 'assets/onboarding1.png',
        title: 'Selamat Datang di Nextgen!',
        description:
            'Perbarui keterampilan pemrograman Anda dengan Nextgen, kursus programming pertama di Indonesia yang sepenuhnya berfokus pada pengembangan keterampilan koding praktis, bukan hanya teori.',
      ),
      OnboardingScreen(
        image: 'assets/onboarding2.png',
        title: 'Eksplorasi Materi',
        description:
            'Eksplorasi materi coding dengan mudah dan menyenangkan. Dari dasar-dasar hingga konsep yang lebih kompleks, kami membawa Anda melangkah demi melangkah. Tersedia berbagai tutorial interaktif dan proyek nyata untuk menguji kemampuan Anda.',
      ),
      OnboardingScreen(
        fontColor: Colors.white,
        color: Colors.cyan,
        image: 'assets/onboarding3.png',
        title: 'Berlatih dan Berkembang',
        description:
            'Coba pengetahuan baru Anda melalui tantangan coding dan proyek-proyek aplikatif. Di sini, setiap kode yang Anda tulis membawa Anda lebih dekat pada kemahiran yang diperlukan. Selamat belajar dan jadilah programmer yang handal!',
      ),
    ];

    final tabPages = [
      TabOnboardingScreen(
        color: Colors.blue[300],
        image: 'assets/onboarding1.png',
        title: 'Selamat Datang di Nextgen!',
        description:
            'Perbarui keterampilan pemrograman Anda dengan Nextgen, kursus programming pertama di Indonesia yang sepenuhnya berfokus pada pengembangan keterampilan koding praktis, bukan hanya teori.',
      ),
      TabOnboardingScreen(
        image: 'assets/onboarding2.png',
        title: 'Eksplorasi Materi',
        description:
            'Eksplorasi materi coding dengan mudah dan menyenangkan. Dari dasar-dasar hingga konsep yang lebih kompleks, kami membawa Anda melangkah demi melangkah. Tersedia berbagai tutorial interaktif dan proyek nyata untuk menguji kemampuan Anda.',
      ),
      TabOnboardingScreen(
        color: Colors.cyan,
        image: 'assets/onboarding3.png',
        title: 'Berlatih dan Berkembang',
        description:
            'Coba pengetahuan baru Anda melalui tantangan coding dan proyek-proyek aplikatif. Di sini, setiap kode yang Anda tulis membawa Anda lebih dekat pada kemahiran yang diperlukan. Selamat belajar dan jadilah programmer yang handal!',
      ),
    ];
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            enableLoop: false,
            liquidController: pageController,
            onPageChangeCallback: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            pages: screenWidth < 600 ||
                    MediaQuery.of(context).orientation ==
                            Orientation.landscape &&
                        aspectRatio > tabletAspectRatioThreshold
                ? pages
                : tabPages,
          ),
          Positioned(
            top: 46,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: const Alignment(0, 0.55),
              child: AnimatedSmoothIndicator(
                // controller: pageController,
                count: 3,
                effect: WormEffect(
                  dotColor: Colors.grey.shade300,
                  activeDotColor: Colors.black,
                  dotHeight: 5,
                  dotWidth: MediaQuery.of(context).size.width * 0.3,
                ),
                activeIndex: pageController.currentPage,
              ),
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.90),
            margin: const EdgeInsets.symmetric(
              horizontal: 26,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(page: 2);
                  },
                  child: Text(
                    'Lewati',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ||
                              MediaQuery.of(context).orientation ==
                                      Orientation.landscape &&
                                  aspectRatio > tabletAspectRatioThreshold
                          ? 14
                          : 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth < 600 ||
                          MediaQuery.of(context).orientation ==
                                  Orientation.landscape &&
                              aspectRatio > tabletAspectRatioThreshold
                      ? 200
                      : MediaQuery.of(context).size.width * 0.26,
                  height: screenWidth < 600 ||
                          MediaQuery.of(context).orientation ==
                                  Orientation.landscape &&
                              aspectRatio > tabletAspectRatioThreshold
                      ? 42
                      : 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int nextPage = pageController.currentPage + 1;

                      pageController.animateToPage(page: nextPage);

                      if (onLastPage == true) {
                        await prefs.setInt("initScreen", 1);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (builder) =>
                                  const MainPage(url: 'https://nextgen.co.id/'),
                            ),
                            (route) => false);
                      }
                    },
                    child: onLastPage
                        ? Text(
                            'Mulai',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 600 ||
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape &&
                                          aspectRatio >
                                              tabletAspectRatioThreshold
                                  ? 16
                                  : 24,
                            ),
                          )
                        : Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 600 ||
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape &&
                                          aspectRatio >
                                              tabletAspectRatioThreshold
                                  ? 16
                                  : 24,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//backup
// import 'package:flutter/material.dart';
// import 'package:liquid_swipe/liquid_swipe.dart';
// import 'package:nextgen_app/pages/main_page.dart';
// import 'package:nextgen_app/widgets/onboarding_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   LiquidController pageController = LiquidController();

//   bool onLastPage = false;

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       OnboardingScreen(
//         color: Colors.blue[300],
//         image: 'assets/onboarding1.png',
//         title: 'Selamat Datang di Nextgen!',
//         description:
//             'Perbarui keterampilan pemrograman Anda dengan Nextgen, kursus programming pertama di Indonesia yang sepenuhnya berfokus pada pengembangan keterampilan koding praktis, bukan hanya teori.',
//       ),
//       OnboardingScreen(
//         image: 'assets/onboarding2.png',
//         title: 'Eksplorasi\nMateri',
//         description:
//             'Eksplorasi materi coding dengan mudah dan menyenangkan. Dari dasar-dasar hingga konsep yang lebih kompleks, kami membawa Anda melangkah demi melangkah. Tersedia berbagai tutorial interaktif dan proyek nyata untuk menguji kemampuan Anda.',
//       ),
//       OnboardingScreen(
//         color: Colors.cyan,
//         image: 'assets/onboarding3.png',
//         title: 'Berlatih dan\nBerkembang',
//         description:
//             'Coba pengetahuan baru Anda melalui tantangan coding dan proyek-proyek aplikatif. Di sini, setiap kode yang Anda tulis membawa Anda lebih dekat pada kemahiran yang diperlukan. Selamat belajar dan jadilah programmer yang handal!',
//       ),
//     ];
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           LiquidSwipe(
//             enableLoop: false,
//             liquidController: pageController,
//             onPageChangeCallback: (index) {
//               setState(() {
//                 onLastPage = (index == 2);
//               });
//             },
//             pages: pages,
//           ),
//           Positioned(
//             bottom: 46,
//             child: Container(
//               alignment: const Alignment(0, 0.55),
//               child: AnimatedSmoothIndicator(
//                 // controller: pageController,
//                 count: 3,
//                 effect: const WormEffect(
//                   activeDotColor: Colors.black,
//                   dotHeight: 5,
//                 ),
//                 activeIndex: pageController.currentPage,
//               ),
//             ),
//           ),
//           Container(
//             alignment: const Alignment(0, 0.80),
//             margin: const EdgeInsets.symmetric(
//               horizontal: 26,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     pageController.jumpToPage(page: 2);
//                   },
//                   child: const Text('Lewati'),
//                 ),
//                 SizedBox(
//                   width: 130,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       SharedPreferences prefs =
//                           await SharedPreferences.getInstance();
//                       int nextPage = pageController.currentPage + 1;

//                       pageController.animateToPage(page: nextPage);

//                       if (onLastPage == true) {
//                         await prefs.setInt("initScreen", 1);
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (builder) =>
//                                   const MainPage(url: 'https://nextgen.co.id/'),
//                             ),
//                             (route) => false);
//                       }
//                     },
//                     child: onLastPage
//                         ? const Text('Mulai')
//                         : const Text('Selanjutnya'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
