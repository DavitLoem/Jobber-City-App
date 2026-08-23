import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

import '../chat/conversation_list/conversation_list_view.dart';
import 'interview_list/interview_list_view.dart';

class ChatsMainView extends StatelessWidget {
  const ChatsMainView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 ដំណោះស្រាយ៖ បញ្ចូល Controller ទៅក្នុង Memory មុនពេល Build UI
    // ប្រើ Get.put() ដើម្បីប្រាកដថាទំព័រទាំង ២ ស្គាល់ Controller របស់វា
    Get.put(InterviewListViewController());

    // បើ ConversationListView មាន Controller ដែរ សូម uncomment បន្ទាត់ខាងក្រោម៖
    // Get.put(ConversationListViewController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightSurfaceVariant,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Communications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Interviews'),
            ],
          ),
        ),
        // 🎯 ដកពាក្យ const ចេញពី TabBarView ដើម្បីធានាថាវា Update ជានិច្ច
        body: TabBarView(
          children: [const ConversationListView(), const InterviewListView()],
        ),
      ),
    );
  }
}
