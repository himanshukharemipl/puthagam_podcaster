import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:puthagam_podcaster/podcaster/core/resources/app_resources.dart';
import 'package:puthagam_podcaster/podcaster/modules/main/views/allpodcasts_tab.dart';
import 'package:puthagam_podcaster/podcaster/modules/main/views/upcoming_podcasts_tab.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../data/datasources/local/app_database.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          "Hi ${LocalStorage.readName()}".text.size(22).bold.make(),
          20.heightBox,
          "Select your podcast".text.gray500.make(),
          20.heightBox,
          TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: themeColor,
            tabs: const [
              Tab(
                text: 'Upcoming Podcast',
              ),
              Tab(
                text: 'All Podcast',
              )
            ],
            controller: controller.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [BuildUpcomingPocastsTab(), BuildAllEpisodesTab()],
            ),
          ),
        ],
      ).h(double.infinity).marginAll(10)),
    );
  }
}
