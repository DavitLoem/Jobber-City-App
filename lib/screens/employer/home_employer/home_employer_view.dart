import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'home_employer_binding.dart';
part 'home_employer_controller.dart';

class HomeEmployerView extends GetView<HomeEmployerViewController> {
  const HomeEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Employer'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
    );
  }
}
