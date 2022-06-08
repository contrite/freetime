import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freetime/Helpers/constants.dart';

class Category extends StatelessWidget {
  final String title;

  const Category({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0.0, 5.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
          child: Text(
            title,
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF676767))),
          ),
        ),
      ),
    );
  }
}
