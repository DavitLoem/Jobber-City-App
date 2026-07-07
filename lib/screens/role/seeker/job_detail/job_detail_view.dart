import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'job_detail_binding.dart';
part 'job_detail_controller.dart';

class JobDetailView extends GetView<JobDetailViewController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Detail')),
      body: Center(
        child: Icon(Icons.work_outline_rounded, size: 100, color: Colors.blue),
      ),
    );
  }
}
