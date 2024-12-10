import 'package:flutter/material.dart';
import 'package:to_do_list_zagsystem/Responsive/UiComponanets/InfoWidget.dart';
import 'package:to_do_list_zagsystem/View/home/Widgets/task_widget.dart';
import 'package:to_do_list_zagsystem/theming/colors.dart';

import '../../Responsive/models/DeviceInfo.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) => const TaskCard(),
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
      floatingActionButton: FloatingActionButton(onPressed: () {}, shape: const CircleBorder(), backgroundColor: ColorsManager.buttonColor, child: const Icon(Icons.add)),
    );
  }
}
