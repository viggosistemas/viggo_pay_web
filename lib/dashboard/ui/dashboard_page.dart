import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/main.dart';

class Course {
  final String text;
  final String lessons;
  final String imageUrl;
  final double percent;
  final String backImage;
  final Color color;

  Course({
    required this.text,
    required this.lessons,
    required this.imageUrl,
    required this.percent,
    required this.backImage,
    required this.color,
  });
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.changeTheme,
  });

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return AppBuilderMain(
      changeTheme: changeTheme,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            itemCount: course.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 16 / 7,
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(course[index].backImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            course[index].text,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            course[index].lessons,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          CircularPercentIndicator(
                            radius: 35,
                            lineWidth: 3,
                            animation: true,
                            animationDuration: 1500,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent: course[index].percent / 100,
                            progressColor: Colors.white,
                            center: Text(
                              "${course[index].percent}%",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            course[index].imageUrl,
                            height: 110,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final List<Course> course = [
  Course(
    text: "Card 1",
    lessons: "10 Values",
    imageUrl: "assets/images/img1.png",
    percent: (12 / 80) * 100,
    backImage: "assets/images/box1.png",
    color: kDarkBlue,
  ),
  Course(
    text: "Card 2",
    lessons: "20 Values",
    imageUrl: "assets/images/img2.png",
    percent: (18 / 80) * 100,
    backImage: "assets/images/box2.png",
    color: kOrange,
  ),
  Course(
    text: "Card 3",
    lessons: "30 Values",
    imageUrl: "assets/images/img3.png",
    percent: (20 / 80) * 100,
    backImage: "assets/images/box3.png",
    color: kGreen,
  ),
  Course(
    text: "Card 4",
    lessons: "40 Values",
    imageUrl: "assets/images/img4.png",
    percent: (65 / 80) * 100,
    backImage: "assets/images/box4.png",
    color: kYellow,
  ),
];
