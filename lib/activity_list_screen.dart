//import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freetime/Helpers/time_converter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freetime/Helpers/constants.dart';
import 'package:freetime/Helpers/database_helper.dart';
import 'package:freetime/Models/task_model.dart';
import 'package:freetime/Widgets/activity_list_item.dart';
import 'package:freetime/Widgets/time_selector.dart';
import 'package:rive/rive.dart';
//import 'package:flare_flutter/flare_actor.dart';

import 'add_task_screen.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({Key? key}) : super(key: key);

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen>
    with SingleTickerProviderStateMixin {
  final double minSize = 252;
  final double maxSize = 700;

  late Future<List<Task>> _taskList;

  List<Task> _listRef = [];
  final List<Task> _filteredTaskList = [];
  String inputText = 'dog';
  //final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  late TimeDotModel _estimatedTime;

  bool _controllerIsOpen = false;
  bool _isAtTop = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  late ScrollController _scrollController;

  late RiveAnimationController _rivecontroller;
  //late FlareController _flareController;

  //SearchItems
  final String _searchTerm = "";
  final TextEditingController _searchController = TextEditingController();
  Icon _searchIcon = Icon(
    Icons.search,
    color: Colors.grey[800],
  );
  Widget _appBarTitle = const Text('Activity List');

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
      reverseCurve: Curves.ease,
    );
    _animation =
        Tween<double>(begin: minSize, end: maxSize).animate(curvedAnimation);
    //_scrollController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.easeOut);
    super.initState();
    _updateTaskList();
    Future.delayed(const Duration(milliseconds: 500), () {
      _maximizeController();
    });
  }

  _filterList(String text) {
    setState(() {
      _taskList = DatabaseHelper.instance.getFilterTaskList(text);
    });
  }

  _search() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(
          Icons.close,
          color: Color.fromARGB(255, 66, 66, 66),
        );
        _appBarTitle = TextField(
          controller: _searchController,
          onChanged: (String value) {
            print('Changed: $value');
            _filterList(value);
          },
          decoration: const InputDecoration(
              prefixIcon:
                  Icon(Icons.search, color: Color.fromARGB(255, 66, 66, 66)),
              hintText: 'Search...'),
        );
      } else {
        _searchController.clear();
        _searchIcon =
            const Icon(Icons.search, color: Color.fromARGB(255, 66, 66, 66));
        _appBarTitle = Text(
          _controllerIsOpen ? '' : 'Activity list',
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.grey[800], fontSize: 25)),
        );
        _updateTaskList();
      }
    });
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
    //5_listRef = _taskList as List<Task>;
  }

  _updateTime(time) {
    setState(() {
      _taskList = DatabaseHelper.instance
          .getTimeTaskList(convertToValue(int.parse(time)).toString());
    });
  }

  _updateFilter(phrase) {
    setState(() {
      _taskList = DatabaseHelper.instance.getFilterTaskList(phrase);
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          InkWell(
            child: ActivityListItem(
              task: task,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList, task: task))),
          ),
        ],
      ),
    );
  }

  _scrollListener() {
    if (_scrollController.offset > _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isAtTop = false;
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isAtTop = true;
      });
    }
  }

  _scrollToTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart);
    print(_scrollController.offset);
  }

  _maximizeController() {
    _controller.forward();
    _controllerIsOpen = true;
  }

  _minimizeController() {
    if (_controller.isCompleted) {
      _controller.reverse(from: maxSize);
      _controllerIsOpen = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: _isAtTop ? 0 : 6,
          backgroundColor:
              _controllerIsOpen ? Colors.transparent : Colors.white,
          centerTitle: false,
          //toolbarOpacity: .5,
          title: Padding(
              padding: const EdgeInsets.only(left: 15.0), child: _appBarTitle
              // Text(
              //   _controllerIsOpen ? '' : 'Activity list',
              //   style: GoogleFonts.lato(
              //       textStyle: TextStyle(color: Colors.grey[800], fontSize: 25)),
              // ),
              ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () => {
                  _search(),
                  _listRef
                      .where((task) => task.title
                          .toLowerCase()
                          .contains(inputText.toLowerCase()))
                      .toList()
                  // implement showing of the search field
                  //  for (var task in _taskList) {
                  //     _filteredTaskList.add(task)
                  //   }
                  //   return taskList;
                },
                icon: _searchIcon,
              ),
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                updateTaskList: _updateTaskList,
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        FutureBuilder(
          future: _taskList,
          builder: (_, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 5,
              ));
            }
            _listRef = snapshot.data;
            final int completedTaskCount = snapshot.data!
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 20, bottom: 252),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, int index) {
                // if (index == 0) {
                //   return Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 30, vertical: 20),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Text(
                //           "Activities",
                //           style: TextStyle(
                //               fontSize: 40, fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   );
                // }
                return _buildTask(snapshot.data[
                    index]); //add '- 1' to the index if you add back in the header above - also add '+1' to the itemCount length
              },
            );
          },
        ),
        Positioned(
          bottom: 0,
          height: _animation.value,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0 && !_controllerIsOpen) {
                _maximizeController();
              } else {
                _minimizeController();
              }
            },
            child: Container(
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 30,
                        color: Color(0x990E324A), //607D8B
                        offset: Offset(0, 0)),
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.white,
                        spreadRadius: 0,
                        offset: Offset(0, -2))
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: minSize,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: _controllerIsOpen ? 300 : 0,
                        height: _controllerIsOpen ? 300 : 0,
                        child: const RiveAnimation.asset('assets/skeeter.riv')
                        // FlareActor(
                        //   "assets/skeeter.flr",
                        //   controller: _flareController,
                        //   alignment: Alignment.center,
                        //   animation: "drifting",
                        //   fit: BoxFit.contain,
                        // )
                        ),
                    SizedBox(
                      height: _controllerIsOpen ? 40 : 0,
                    ),
                    Text('How much free time do you have?',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    const SizedBox(
                      height: 10,
                    ),
                    TimeSelector(
                      //key: UniqueKey(),
                      clear: () => _updateTaskList(),
                      updateTime: (String val) {
                        _updateTime(val);
                        if (_controllerIsOpen) {
                          _minimizeController();
                        }
                        _scrollToTop();
                      },
                    ),
                    SizedBox(
                      height: _controllerIsOpen ? 40 : 80,
                    )
                  ],
                ))),
          ),
        ),
      ]),
    );
  }
}
