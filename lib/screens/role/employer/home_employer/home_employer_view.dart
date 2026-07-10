import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/home_header.dart';

part 'home_employer_binding.dart';
part 'home_employer_controller.dart';

class HomeEmployerView extends GetView<HomeEmployerViewController> {
  const HomeEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [const HomeHeader()])),
    );
  }
}

          // IconButton(
          //   onPressed: () {
          //     Get.find<AuthController>().logout();
          //   },
          //   icon: const Icon(Icons.logout),
          // ),
