// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:smart_kishan/constant.dart';
// import 'package:smart_kishan/controllers/app_controller.dart';
// import 'package:smart_kishan/routes/app_routes.dart';

// class IntroductionPage extends StatelessWidget {
//   const IntroductionPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//           titleWidget:
//               const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('Welcome to ',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                 )),
//             Text('Smart',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: kPrimaryColor)),
//             Text(
//               ' Kishan',
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: kSecondaryColor),
//             )
//           ]),
//           body:
//               'Welcome to Travel Kendra, You can rent vehicle and delivery / dhuwani service as per your requirement and budget.',
//           // bodyWidget: Column(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   children: const [
//           //     Text(
//           //       'Welcome to Travel Kendra',
//           //       style: TextStyle(
//           //           fontSize: 20,
//           //           fontWeight: FontWeight.bold,
//           //           color: kPrimaryColor),
//           //     ),
//           //     SizedBox(
//           //       height: 10,
//           //     ),
//           //     Text("Rent vehicles & Deliver your goods at your fingertips!"),
//           //   ],
//           // ),
//           image: buildImage('assets/images/story1.png'),
//           decoration: buildDecoration(),
//         ),
//         PageViewModel(
//           titleWidget:
//               const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('Rent',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: kPrimaryColor)),
//             Text(
//               ' Vehicle',
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: kSecondaryColor),
//             )
//           ]),
//           body:
//               ' Cheapest, Reliable and Safest vehicle rental service in Nepal. You can rent for one way, return, multi stops or self drive.',
//           image: buildImage('assets/images/story2.png'),
//           decoration: buildDecoration(),
//         ),
//         PageViewModel(
//           titleWidget:
//               const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('Deliver',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: kPrimaryColor)),
//             Text(
//               ' Goods',
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: kSecondaryColor),
//             )
//           ]),
//           body:
//               'You can book Delivery / Dhuwani service with Travel Kendra all over Nepal. You can book for single or multi drops service.',
//           image: buildImage('assets/images/story3.png'),
//           decoration: buildDecoration(),
//         ),
//         PageViewModel(
//           titleWidget:
//               const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('Become',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: kPrimaryColor)),
//             Text(
//               ' an Agent',
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: kSecondaryColor),
//             )
//           ]),
//           body:
//               'Help your friends, family and customers to rent our vehicle and earn unlimited. Our agents are earning more than Rs 30,000 every month.',
//           image: buildImage('assets/images/story4.png'),
//           decoration: buildDecoration(),
//         ),
//       ],
//       next: const Text(
//         'Next',
//         style: TextStyle(fontSize: 15),
//       ),
//       // nextStyle: const ButtonStyle(
//       //     backgroundColor: WidgetStatePropertyAll<Color>(kWhiteColor)),
//       // doneStyle: const ButtonStyle(
//       //     backgroundColor: WidgetStatePropertyAll<Color>(kWhiteColor)),
//       done: const Text('Done',
//           style: TextStyle(color: kPrimaryColor, fontSize: 15)),
//       onDone: () => goToHome(),
//       showSkipButton: true,
//       // skipStyle: const ButtonStyle(
//       //     backgroundColor: WidgetStatePropertyAll<Color>(kWhiteColor)),
//       skip: const Text(
//         'Skip',
//         style: TextStyle(color: kPrimaryColor, fontSize: 15),
//       ), //by default, skip goes to the last page
//       onSkip: () => goToHome(),
//       dotsDecorator: getDotDecoration(),
//       animationDuration: 1000,
//       globalBackgroundColor: Colors.white,
//     );
//   }

//   DotsDecorator getDotDecoration() => DotsDecorator(
//       color: Colors.grey,
//       size: const Size(10, 10),
//       activeColor: kPrimaryColor,
//       activeSize: const Size(22, 10),
//       activeShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ));

//   void goToHome() async {
//     await authController.updateFirstLaunch();
//     Get.offNamed(AppRoute.signInScreen);
//   }

//   Widget buildImage(String path) => Container(
//       alignment: Alignment.bottomCenter,
//       child: Image.asset(
//         path,
//         width: 340,
//       ));

//   PageDecoration buildDecoration() => const PageDecoration(
//         imageFlex: 4,
//         bodyFlex: 3,
//         titleTextStyle: TextStyle(
//             fontSize: 20, fontWeight: FontWeight.bold, color: kSecondaryColor),
//         bodyTextStyle: TextStyle(fontSize: 15),
//         pageColor: kCanvasColor,
//         imagePadding: EdgeInsets.all(0),
//       );
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    storyData = [
      {
        "image": "assets/images/story1.png",
        "title": AppLocalizations.of(context)!.story1Title,
        "text": AppLocalizations.of(context)!.story1Desc
      },
      {
        "image": "assets/images/story2.png",
        "title": AppLocalizations.of(context)!.story2Title,
        "text": AppLocalizations.of(context)!.story2Desc
      },
      {
        "image": "assets/images/story3.png",
        "title": AppLocalizations.of(context)!.story3Title,
        "text": AppLocalizations.of(context)!.story3Desc
      },
      {
        "image": "assets/images/story4.png",
        "title": AppLocalizations.of(context)!.story4Title,
        "text": AppLocalizations.of(context)!.story4Desc
      },
    ];

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            SizedBox(
              height: 500,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemCount: storyData.length,
                itemBuilder: (context, index) {
                  return OnboardContent(
                    image: storyData[index]['image'],
                    title: storyData[index]['title'],
                    text: storyData[index]['text'],
                  );
                },
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                storyData.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedDot(
                    isActive: _selectedIndex == index,
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Align(
              child: ElevatedButton(
                  onPressed: () async {
                    await authController.updateFirstLaunch();
                    Get.toNamed(AppRoute.signInScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize:
                        Size(double.infinity, getProportionateScreenWidth(45)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.getStarted,
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
            const Spacer()
          ],
        ),
      ),
    ));
  }
}

class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
          color: isActive
              ? kPrimaryColor
              : const Color(0xFF868686).withOpacity(0.25),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent(
      {super.key,
      required this.image,
      required this.title,
      required this.text});

  final String image, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(image),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

List<Map<String, dynamic>> storyData = [
  {
    "image": "assets/images/story1.png",
    "title": "Farming Made Easier",
    "text":
        "Simplify farm management with tools designed to help you grow and succeed effortlessly."
  },
  {
    "image": "assets/images/story2.png",
    "title": "Manage Multiple Farmlands",
    "text":
        "Store and track data from different farmlands, customized for each plot."
  },
  {
    "image": "assets/images/story3.png",
    "title": "Organize Farm Stock Efficiently",
    "text":
        "Keep a clear record of all farm supplies and stock levels in one place."
  },
  {
    "image": "assets/images/story4.png",
    "title": "Quick Notes for Fast Reminders",
    "text":
        "Note down important tasks or ideas instantly to stay organized and on top of your farm's needs."
  },
];
