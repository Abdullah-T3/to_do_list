import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../helpers/extantions.dart';
import '../../../../theming/colors.dart';

import '../../../../routing/routs.dart';
import '../../../../theming/styles.dart';
import '../../../VIew_Models/Task_View_Models/home_tasks/home_tasks_cubit.dart';
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
    context.read<HomeTasksCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Infowidget(builder: (context, deviceinfo) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          top: false,
          child: Container(
            decoration: MainBackgroundAttributes.MainBoxDecoration,
            padding: MainBackgroundAttributes(deviceinfo).MainPadding,
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
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                        borderRadius: BorderRadius.circular(
                            deviceinfo.screenWidth * 0.05),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(
                            deviceinfo.screenWidth * 0.05),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(
                            deviceinfo.screenWidth * 0.05),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      hintText: "Search",
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<HomeTasksCubit, HomeTasksState>(
                      builder: (context, state) {
                        print("$state lol");
                        if (state is HomeTasksLoading) {
                          print("loading");
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is HomeTasksLoaded) {
                          print("loaded");
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<HomeTasksCubit>().getTasks();
                            },
                            child: ListView.builder(
                              padding: EdgeInsetsDirectional.only(
                                  top: deviceinfo.screenHeight * 0.01),
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                return TaskCard(task: state.tasks[index]);
                              },
                            ),
                          );
                        } else if (state is HomeTasksError) {
                          print("error");
                          return Center(child: Text(state.error));
                        } else if (state is NoTaske) {
                          print("no tasks");
                          return const Center(
                            child: Text(
                              "No tasks yet",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed(Routes.addTaskScreen);
            },
            shape: const CircleBorder(),
            backgroundColor: ColorsManager.buttonColor,
            child: const Icon(Icons.add)),
      );
    });
  }
}
