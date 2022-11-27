import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routename = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var _taskController;
  List<Task> _tasks = [];
  List<bool> _taskDone = [];
  bool isClicked = false;
  bool isWrong = false;
  bool isRight = false;
  double bottomSheet = 400.0;
  static const routeName = '/home_screen';
  late final AnimationController controller;
  late final AnimationController controller2;
  late final AnimationController controller3;
  late final AnimationController controller4;
  late final AnimationController controller5;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Task t = Task.fromString(_taskController.text);
    String? tasks = prefs.getString('task');
    List<String> list =
        (tasks == null) ? [] : json.decode(tasks).cast<String>();
    list.add(json.encode(t.getMap()));
    prefs.setString('task', json.encode(list));
    print(list);
    _taskController.text = '';
    Navigator.of(context).pop();

    //isClicked = false;
    controller.reverse();
    isClicked = false;

    _getTasks();
  }

  void _getTasks() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List<String> list =
        (tasks == null) ? [] : json.decode(tasks).cast<String>();
    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }
    print(_tasks);

    _taskDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void updatePendingTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++) {
      if (!_taskDone[i]) pendingList.add(_tasks[i]);
    }

    var pendingListEncoded = List.generate(
        pendingList.length, (i) => json.encode(pendingList[i].getMap()));
    prefs.setString('task', json.encode(pendingListEncoded));

    _getTasks();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTasks();
    _taskController = TextEditingController();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller2 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller3 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller4 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller5 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _taskController.disopose();
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text(
          'Task Manager',
          style: GoogleFonts.montserrat(
              //color: Colors.white, fontSize: 20.0,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 1.0),
            child: GestureDetector(
              child: Lottie.network(
                  "https://assets2.lottiefiles.com/private_files/lf30_xtfzsgch.json",
                  height: 50.0,
                  width: 50.0,
                controller: controller4,
              ),
              onTap: ()async{
                updatePendingTaskList();
                controller4.forward();

                await Future.delayed(Duration(seconds: 1));
                controller4.reverse();
              },

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                child: Lottie.network(
                  "https://assets8.lottiefiles.com/private_files/lf30_rj4ooq2j.json",
                  //height: 40.0,
                  //width: 40.0,
                  controller: controller5,
                ),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('task', json.encode([]));
                  controller5.forward();

                  await Future.delayed(Duration(seconds: 3));
                  controller5.reverse();
                  _getTasks();
                  controller5.reset();
                },
                ),
          )
        ],
      ),
      body: (_tasks == [])
          ? Center(
              child: Text("No Tasks added yet"),
            )
          : Column(
              children: _tasks
                  .map<Widget>((e) => Container(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Lottie.network(
                                "https://assets3.lottiefiles.com/packages/lf20_vlVa8T.json"),
                            Text(
                              e.task,
                              style: GoogleFonts.montserrat(),
                            ),
                            Checkbox(
                                value: _taskDone[_tasks.indexOf(e)],
                                key: GlobalKey(),
                                onChanged: (val) {
                                  setState(() {
                                    _taskDone[_tasks.indexOf(e)] = val!;
                                  });
                                }),
                          ],
                        ),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
          child: GestureDetector(
            //onTap:()
            child: Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_iqxssits.json",
                controller: controller),
          ),
          backgroundColor: Colors.blue,
          onPressed: () async {
            if (isClicked == false) {
              isClicked = true;
              controller.forward();
              controller2.forward();
              controller3.forward();
              //break here;

            }
            await Future.delayed(Duration(seconds: 1));
            showModalBottomSheet(

              context: context,
              builder: (BuildContext context) => Container(
                height: bottomSheet,
                color: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Task',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                      Divider(thickness: 1.2),
                      SizedBox(height: 20.0),
                      TextField(
                        autofocus: true,
                        controller: _taskController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Task',
                          hintStyle: GoogleFonts.montserrat(),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        width: MediaQuery.of(context).size.width,
                        //height: 200.0,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 60.0),
                              child: GestureDetector(
                                  // width:
                                  //     (MediaQuery.of(context).size.width / 2) - 20,
                                  child: Lottie.network(
                                      "https://assets10.lottiefiles.com/packages/lf20_slGFhN.json",
                                      height: 80.0,
                                      width: 88.0,
                                      controller: controller2),
                                  //color: Colors.white,
                                  onTap: () async {
                                    _taskController.text = '';
                                    controller2.reverse();
                                    await Future.delayed(Duration(seconds: 1));
                                    controller2.forward();
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 1.0, left: 90.0),
                              child: GestureDetector(
                                  // width:
                                  //     (MediaQuery.of(context).size.width / 2) - 20,
                                  // height:
                                  //     (MediaQuery.of(context).size.width / 2) - 20,
                                  child: Lottie.network(
                                    "https://assets8.lottiefiles.com/packages/lf20_0rs4egoj.json",
                                    height: 50.0,
                                    width: 58.0,
                                    controller: controller3,
                                    animate: isRight,
                                  ),
                                  onTap: () async {
                                    isRight = true;
                                    if (isRight == true) {
                                      controller3.repeat();
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      //controller.forward();
                                      saveData();
                                      isRight = false;
                                      setState(() {});
                                    }
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
            setState(() {});
          }),
    );
  }
}
