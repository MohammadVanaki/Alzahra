import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({
    super.key,
    required this.body,
    required this.date,
  });
  final String body;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("./assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const Gap(15),
              Row(
                children: <Widget>[
                  Text(
                    body,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const Gap(5),
                  // SvgPicture.asset(
                  //   './assets/svgs/card-tick.svg',
                  //   colorFilter:
                  //       const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  // ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
