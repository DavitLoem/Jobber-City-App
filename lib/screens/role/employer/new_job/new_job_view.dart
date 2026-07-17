import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/controllers/category_controller.dart';
import 'package:jobber_city/controllers/location_controller.dart';
import 'package:jobber_city/controllers/master_data_controller.dart';
import 'package:jobber_city/core/api/network/api_exception.dart';
import 'package:jobber_city/core/api/services/role/employer/job_service.dart';
import 'package:jobber_city/core/constants/app_colors.dart';
import 'package:jobber_city/models/role/employer/job_model.dart';
import 'package:jobber_city/screens/role/employer/new_job/steps/step_1_basic_info.dart';
import 'package:jobber_city/screens/role/employer/new_job/steps/step_2_salary.dart';
import 'package:jobber_city/screens/role/employer/new_job/steps/step_3_details.dart';
import 'package:jobber_city/screens/role/employer/new_job/steps/step_4_schedule.dart';

import 'widgets/job_stepper_header.dart';

part 'new_job_binding.dart';
part 'new_job_controller.dart';

class NewJobView extends GetView<NewJobViewController> {
  const NewJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Post a Job",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Obx(
            () => JobStepperHeader(currentStep: controller.currentStep.value),
          ),

          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Step1BasicInfo(),
                Step2Salary(),
                Step3Details(),
                Step4Schedule(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: Obx(() {
            final isFirstStep = controller.currentStep.value == 0;
            final isLastStep = controller.currentStep.value == 3;

            return Row(
              children: [
                // បង្ហាញប៊ូតុង Back តែពេលមិនមែននៅជំហានទី 1
                if (!isFirstStep) ...[
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: controller.previousStep,
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // ប៊ូតុង Next / Post Job
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.nextStep,
                    child: Text(
                      isLastStep ? "Post Job" : "Next Step",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
