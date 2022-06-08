import 'package:flutter/material.dart';
import 'package:freetime/Helpers/time_converter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freetime/Helpers/my_flutter_app_icons.dart';
import 'package:freetime/Models/task_model.dart';
import 'package:freetime/Widgets/category.dart';
import 'freetime_icon.dart';

class ActivityListItem extends StatelessWidget {
  // final String title;
  // final String notes;
  // final String timeValue;
  // final String timeType;
  final Task task;

  const ActivityListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Text(
                            task.title,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.mulish(
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Category(title: task.categories[0]),
                      const FreetimeIcon(MyFlutterApp.icon_map),
                      const FreetimeIcon(MyFlutterApp.icon_attachment),
                      const FreetimeIcon(MyFlutterApp.icon_image)
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 14.0, 0.0, 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          convertToMin(task.time).toString(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666666),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(convertToMin(task.time) < 10 ? 'h' : 'm',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF666666),
                                ),
                              )),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: Icon(
                      //   Icons.star_border,
                      //   size: 35.0,
                      //   color: Colors.grey,
                      // ),
                      child: Container(
                        height: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 1.0,
            color: Color(0xFFD8D8D8),
          )
        ],
      ),
    );
  }
}
