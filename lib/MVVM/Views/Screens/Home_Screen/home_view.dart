import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Responsive/UiComponanets/InfoWidget.dart';
import '../../../../helpers/extantions.dart';
import '../../../../theming/colors.dart';
import '../../../../routing/routs.dart';
import '../../../../theming/styles.dart';
import '../../../VIew_Models/Task_View_Models/home_tasks/home_tasks_cubit.dart';
import '../../Widgets/Tasks_Widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<bool> _isSelected = [true, false];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() async {
    super.initState();
    await context.read<HomeTasksCubit>().getTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTaskView(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
    });

    if (_isSelected[0]) {
      context.read<HomeTasksCubit>().getTasks();
    } else {
      context.read<HomeTasksCubit>().subscribeToRealtimeSharedTasks();
      context.read<HomeTasksCubit>().getSharedTasks();
    }
  }

  Future<void> _refreshTasks() async {
    if (_isSelected[0]) {
      context.read<HomeTasksCubit>().getTasks();
    } else {
      context.read<HomeTasksCubit>().getSharedTasks();
    }
  }

  Widget _buildTaskList(HomeTasksState state, deviceinfo) {
    if (state is HomeTasksLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoTasks) {
      return const Center(
        child: Text(
          "No tasks yet",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (state is HomeTasksLoaded || state is SharedTaskloaded) {
      final tasks = (state as dynamic).tasks;
      return RefreshIndicator(
        onRefresh: _refreshTasks,
        child: ListView.builder(
          padding:
              EdgeInsetsDirectional.only(top: deviceinfo.screenHeight * 0.01),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(task: tasks[index]);
          },
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Infowidget(
      builder: (context, deviceinfo) {
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
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    // Header
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
                        const SizedBox(width: 20),
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

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      cursorColor: Colors.white,
                      style: TextStyles.searchBar(deviceinfo),
                      decoration:
                          TextFieldStyles.searchBar(deviceinfo: deviceinfo)
                              .copyWith(hintText: "Search"),
                      onChanged: (query) {
                        context.read<HomeTasksCubit>().searchTasks(query);
                      },
                    ),

                    // Toggle Buttons
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: deviceinfo.screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: ColorsManager.buttonColor.withOpacity(0.2),
                        borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(deviceinfo.screenWidth * 0.05),
                        ),
                      ),
                      child: ToggleButtons(
                        isSelected: _isSelected,
                        onPressed: _toggleTaskView,
                        borderRadius: BorderRadius.circular(
                            deviceinfo.screenWidth * 0.05),
                        selectedColor: Colors.white,
                        fillColor: ColorsManager.buttonColor,
                        color: Colors.white.withOpacity(0.6),
                        constraints: BoxConstraints(
                          minWidth: deviceinfo.screenWidth * 0.4,
                          minHeight: deviceinfo.screenHeight * 0.06,
                        ),
                        children: const [
                          Text("My Tasks"),
                          Text("Shared Tasks"),
                        ],
                      ),
                    ),

                    // Task List
                    Expanded(
                      child: BlocBuilder<HomeTasksCubit, HomeTasksState>(
                        builder: (context, state) =>
                            _buildTaskList(state, deviceinfo),
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
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
