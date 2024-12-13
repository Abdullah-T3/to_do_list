import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/theming/colors.dart';

import '../../../../Responsive/models/DeviceInfo.dart';
import '../../../VIew_Models/Task_View_Models/task_cubit.dart';
import '../../Widgets/Tasks_Widgets/task_widget.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().fetchTasks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Infowidget(
          builder: (BuildContext context, Deviceinfo deviceinfo) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.primaryColor,
                    ColorsManager.secondaryColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(3.14),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(deviceinfo.screenWidth * 0.05, deviceinfo.screenHeight * 0.01, deviceinfo.screenWidth * 0.05, deviceinfo.screenHeight * 0.01),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "on.time",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notification_add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: deviceinfo.screenHeight * 0.05),
                      TextField(
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                          hintStyle: const TextStyle(color: Colors.white),
                          hintText: "Search",
                        ),
                      ),
                      SizedBox(height: deviceinfo.screenHeight * 0.05),
                      Expanded(
                        child: BlocBuilder<TaskCubit, TaskState>(
                          builder: (context, state) {
                            print("${state} lol");
                            if (state is TaskLoading) {
                              print("loading");
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is TaskLoaded) {
                              print("loaded");
                              return ListView.builder(
                                itemCount: state.tasks.length,
                                itemBuilder: (context, index) {
                                  return TaskCard(task: state.tasks[index]);
                                },
                              );
                            } else if (state is TaskError) {
                              print("error");
                              return Center(child: Text(state.errorMessage));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<TaskCubit>().fetchTasks();
          },
          shape: const CircleBorder(),
          backgroundColor: ColorsManager.buttonColor,
          child: const Icon(Icons.add)),
    );
  }
}
