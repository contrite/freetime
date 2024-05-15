import 'package:flutter/material.dart';
import 'package:freetime/Helpers/time_converter.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({required this.updateTime, required this.clear, Key? key})
      : super(key: key);

  final Function(String) updateTime;
  final Function() clear;

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

List<TimeDotModel> timeData = [
  TimeDotModel(timeValue: convertToMin(1), timeType: "m", isSelected: false),
  TimeDotModel(timeValue: convertToMin(2), timeType: "m", isSelected: false),
  TimeDotModel(timeValue: convertToMin(3), timeType: "h", isSelected: false),
  TimeDotModel(timeValue: convertToMin(4), timeType: "h", isSelected: false),
  TimeDotModel(timeValue: convertToMin(5), timeType: "h", isSelected: false),
  TimeDotModel(timeValue: convertToMin(6), timeType: "h+", isSelected: false)
];

class _TimeSelectorState extends State<TimeSelector>
    with SingleTickerProviderStateMixin {
  late TimeDotModel estimatedTime;
  int selectedIndex = 6;

  @override
  void initState() {
    super.initState();
  }


  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      //color: Colors.pink,
      width: _width,
      height: 60,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: timeData.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    for (var element in timeData) {
                      element.isSelected = false;
                    }
                    if (selectedIndex != index) {
                      timeData[index].isSelected = true;
                      selectedIndex = index;
                      estimatedTime = timeData[index];
                      widget.updateTime(timeData[index].timeValue.toString());
                    } else {
                      selectedIndex = 6;
                      widget.clear();
                    }
                  });
                },
                child: TimeDot(timeData[index]),
              );
            }),
      ),
    );
  }
}

class TimeDot extends StatefulWidget {
  final TimeDotModel _timeDotModel;

  const TimeDot(this._timeDotModel, {Key? key}) : super(key: key);

  @override
  _TimeDotState createState() => _TimeDotState();
}

class _TimeDotState extends State<TimeDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animationText, animationSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() => setState(() {}));
    animationText = Tween<double>(begin: 14, end: 20).animate(
      CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: _controller,
      ),
    );
    animationSize = Tween<double>(begin: 38, end: 54).animate(
      CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: _controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(TimeDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._timeDotModel.isSelected
        ? _controller.forward()
        : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: widget._timeDotModel.isSelected
                  ? const Color(0xFFE86767)
                  : const Color(0xFF3C3C3C),
              width: 3),
          color:
              widget._timeDotModel.isSelected ? const Color(0xFFE86767) : null,
          boxShadow: widget._timeDotModel.isSelected
              ? [
                  const BoxShadow(
                      color: Colors.blueGrey,
                      offset: Offset(0.0, 6.0),
                      blurRadius: 6.0,
                      spreadRadius: -2.0)
                ]
              : null,
        ),
        width: animationSize.value,
        height: animationSize.value,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(widget._timeDotModel.timeValue.toString(),
                  style: GoogleFonts.roboto(
                      fontSize: animationText.value,
                      color: widget._timeDotModel.isSelected
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w900)),
              Text(widget._timeDotModel.timeType,
                  style: GoogleFonts.roboto(
                      fontSize: animationText.value * .66,
                      color: widget._timeDotModel.isSelected
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeDotModel {
  bool isSelected;
  final int timeValue;
  final String timeType;

  TimeDotModel(
      {required this.isSelected,
      required this.timeValue,
      required this.timeType});
}
