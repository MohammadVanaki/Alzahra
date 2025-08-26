import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class OfflineItemCard extends StatelessWidget {
  const OfflineItemCard({
    super.key,
    required this.title,
    required this.imagePath,
  });
  final String title;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          Image.asset(
            imagePath,
            height: 40,
            width: 40,
          ),
        ],
      ),
    );
  }
}
