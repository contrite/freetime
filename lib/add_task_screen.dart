// TODO Implement this library.import 'dart:io';
import 'dart:io';
import 'dart:math';
import 'package:freetime/Widgets/time_selector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:freetime/Helpers/constants.dart';
import 'package:freetime/Helpers/database_helper.dart';
import 'package:location/location.dart';
import 'Models/task_model.dart';
import 'Widgets/category.dart';
import 'package:path_provider/path_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Function? updateTaskList;
  final Task? task;

  const AddTaskScreen({Key? key, this.updateTaskList, this.task})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _notes = 'Notes...';
  DateTime _date = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  List<Category> categories = [];
  List<String> categoryTitles = [];
  int _time = 1;
  final double _selectedTime = 2;
  String _imagePath = '';
  final Location _location = Location();
  LocationData? _currentPosition;
  List<int> timesList = [10, 30, 1, 2, 4, 6];
  File? imageFile;
  final picker = ImagePicker();
  String _locationText = "Get Location";
  List<TimeDotModel> timeData = [
    TimeDotModel(timeValue: 10, timeType: "m", isSelected: false),
    TimeDotModel(timeValue: 30, timeType: "m", isSelected: false),
    TimeDotModel(timeValue: 1, timeType: "h", isSelected: false),
    TimeDotModel(timeValue: 2, timeType: "h", isSelected: false),
    TimeDotModel(timeValue: 4, timeType: "h", isSelected: false),
    TimeDotModel(timeValue: 6, timeType: "h+", isSelected: false)
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _notes = widget.task!.notes;
      _date = widget.task!.date;
      categories = getCategories();
      categoryTitles = widget.task!.categories;
      _time = widget.task!.time;
      if (widget.task!.imagePath != null) {
        _imagePath = widget.task!.imagePath!;
        imageFile = File(_imagePath);
      }
      timeData[_convertTimeForPicker()].isSelected = true;
    }
    _dateController.text = _dateFormat.format(_date);
    if (categories.isEmpty) {
      categories.add(const Category(title: 'No Category'));
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  T getRandomElement<T>(List<T> list) {
    final random = Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      initialDate: _date,
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      _date = date;
    }
    _dateController.text = _dateFormat.format(_date);
  }

  _convertTimeForSlider() {
    double t = 0;
    if (_time == 10) {
      t = 1;
    } else if (_time == 30) {
      t = 2;
    } else if (_time == 1) {
      t = 3;
    } else if (_time == 2) {
      t = 4;
    } else if (_time == 4) {
      t = 5;
    } else if (_time == 6) {
      t = 6;
    }
    return t;
  }

  _convertTimeForPicker() {
    int t = 0;
    if (_time == 1) {
      t = 0;
    } else if (_time == 2) {
      t = 1;
    } else if (_time == 3) {
      t = 2;
    } else if (_time == 4) {
      t = 3;
    } else if (_time == 5) {
      t = 4;
    } else if (_time == 6) {
      t = 5;
    }
    return t;
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_notes, $_dateFormat, $categories, $_time, $_imagePath');
      categoryTitles = [];
      for (var c in categories) {
        if (c.title != '') categoryTitles.add(c.title);
      }

      Task task = Task(
        title: _title,
        notes: _notes,
        date: _date,
        categories: categoryTitles,
        time: _time,
        imagePath: _imagePath,
      );

      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList!();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task!.id!);
    widget.updateTaskList!();
    Navigator.pop(context);
  }

  _getCategories() {
    List<Widget> cats = [];
    for (var cat in categories) {
      cats.add(cat);
    }
    cats.add(
      TextButton(
          onPressed: () {
            createAlertDialog(context).then((onValue) {
              setState(() {
                if (categories[0].title == 'No Category') {
                  categories.removeAt(0);
                }
                if (onValue != null) {
                  categories.add(Category(title: onValue));
                }
              });
            });
          },
          style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 12.0))),
          //padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0.0, 5.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Add Category',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          )),
    );
    return cats;
  }

  Future<dynamic> createAlertDialog(BuildContext context) {
    _categoryController.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Category Name:'),
            content: TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              controller: _categoryController,
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(_categoryController.text.toString());
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  _getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _location.getLocation();
    setState(() {
      _locationText = _currentPosition.toString();
    });
    // _initialcameraposition =
    //     LatLng(_currentPosition.latitude, _currentPosition.longitude);
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   print("${currentLocation.longitude} : ${currentLocation.longitude}");
    //   setState(() {
    //     _currentPosition = currentLocation;
    //     _initialcameraposition =
    //         LatLng(_currentPosition.latitude, _currentPosition.longitude);

    //     DateTime now = DateTime.now();
    //     _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
    //     _getAddress(_currentPosition.latitude, _currentPosition.longitude)
    //         .then((value) {
    //       setState(() {
    //         _address = "${value.first.addressLine}";
    //       });
    //     });
    //   });
    // });
  }

  _takePic(ImageSource source) async {
    //final XFile pickedFile = await picker.pickImage(source: source);
    // setState(() {
    //   imageFile = File(pickedFile.path);
    // });
    if (source == ImageSource.camera) {
      try {
        final pickedFile = await picker.pickImage(
          source: source,
        );
        setState(() {
          imageFile = File(pickedFile!.path);
        });
      } catch (e) {
        setState(() {});
      }
    } else if (source == ImageSource.gallery) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          _imagePath = pickedFile.path;
        });
      }
    }
    Directory dir = await getApplicationDocumentsDirectory();
    //String path = dir.path + '/todo_list.db';
    print(Uri.parse(imageFile!.path).pathSegments.last.characters);
    final fileName = Uri.parse(imageFile!.path).pathSegments.last.characters;
    final savedImage = await imageFile!.copy('${dir.path}/$fileName');
    print(savedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    TimeSelector ts;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: darkColor,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      color: primaryColor,
                      icon: const Icon(Icons.access_time),
                      iconSize: 30,
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        //var rng = Random();
                        _time = getRandomElement(timesList);
                      },
                    ),
                  ],
                ),

                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   widget.task == null ? 'Add Activity' : 'Update Activity',
                //   style: TextStyle(
                //       fontSize: 30,
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500)),
                            autofocus: widget.task == null ? true : false,
                            decoration: const InputDecoration(
                              //labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 20),
                              border: InputBorder.none,
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter a title'
                                : null,
                            onSaved: (input) => _title = input!,
                            initialValue: _title,
                          ),
                        ),
                        //FreetimeIcon(MyFlutterApp.star_empty),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          //color: Colors.pink,
                          //width: 400,
                          height: 80,
                          clipBehavior: Clip.none,
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
                                        timeData[index].isSelected = true;
                                        if (index == 0) {
                                          _time = 1;
                                        } else if (index == 1) {
                                          _time = 2;
                                        } else if (index == 2) {
                                          _time = 3;
                                        } else if (index == 3) {
                                          _time = 4;
                                        } else if (index == 4) {
                                          _time = 5;
                                        } else if (index == 5) {
                                          _time = 6;
                                        }
                                      });
                                    },
                                    child: TimeDot(timeData[index]),
                                  );
                                }),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 3,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                            decoration: const InputDecoration(
                              // labelText: 'Notes...',
                              // labelStyle: TextStyle(fontSize: 15),
                              border: InputBorder.none,
                            ),
                            // validator: (input) => input.trim().isEmpty
                            //     ? 'Please enter a title'
                            //     : null,
                            onSaved: (input) => _notes = input!,
                            initialValue: _notes,
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10),
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     controller: _dateController,
                        //     style: TextStyle(fontSize: 12),
                        //     onTap: _handleDatePicker,
                        //     decoration: InputDecoration(
                        //       //labelText: 'Date',
                        //       labelStyle: TextStyle(fontSize: 12),
                        //       border: InputBorder.none,
                        //     ),
                        //   ),
                        // ),
                        Wrap(
                          children: _getCategories(),
                          alignment: WrapAlignment.center,
                        ),

                        Container(
                            child: imageFile != null && _imagePath != ''
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    // color: Colors.black12,
                                    child: TextButton(
                                      onPressed: () {
                                        _takePic(ImageSource.gallery);
                                      },
                                      child: const Text(
                                        '＋ Add Image',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20),
                                      ),
                                    ),
                                  )),
                        Container(
                          decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 80),
                          // color: Colors.black12,
                          child: TextButton(
                            onPressed: () {
                              _getLoc();
                            },
                            child: Text(
                              _locationText,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 20),
                            ),
                          ),
                        )

                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 20),
                        //   child: DropdownButtonFormField(
                        //     isDense: true,
                        //     icon: Icon(Icons.arrow_drop_down_circle),
                        //     iconSize: 22,
                        //     iconEnabledColor: Theme.of(context).primaryColor,
                        //     items: _priorities.map((String priority) {
                        //       return DropdownMenuItem(
                        //         value: priority,
                        //         child: Text(
                        //           priority,
                        //           style: TextStyle(
                        //               fontSize: 15, color: Colors.black),
                        //         ),
                        //       );
                        //     }).toList(),
                        //     style: TextStyle(fontSize: 15),
                        //     decoration: InputDecoration(
                        //       labelText: 'Priority',
                        //       labelStyle: TextStyle(fontSize: 15),
                        //       border: InputBorder.none,
                        //     ),
                        //     validator: (input) => _priority == null
                        //         ? 'Please enter a priority'
                        //         : null,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _priority = value;
                        //       });
                        //     },
                        //     value: _priority,
                        //   ),
                        // ),

                        //Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Color(0xBB607D8B), //607D8B
                offset: Offset(0, 0))
          ],
        ),
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            widget.task != null
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: _delete,
                    ),
                  )
                : const SizedBox.shrink(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                child: Text(
                  widget.task == null ? 'Add' : 'Update',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Category> getCategories() {
    List<Category> cats = [];
    for (var c in widget.task!.categories) {
      if (c != '') {
        cats.add(Category(title: c));
      }
    }
    return cats;
  }
}
