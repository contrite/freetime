import 'package:flutter/material.dart';

class FreetimeIcon extends StatelessWidget {
  final IconData map;

  const FreetimeIcon(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Icon(
        map,
        color: Colors.black45,
        size: 15,
      ),
    );
  }
}
