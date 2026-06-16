import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'home_seeker_binding.dart';
part 'home_seeker_controller.dart';

class HomeSeekerView extends GetView<HomeSeekerViewController> {
  const HomeSeekerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Seeker'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
    );
  }
}
