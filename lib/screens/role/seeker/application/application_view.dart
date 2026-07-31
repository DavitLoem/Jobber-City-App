import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobber_city/core/constants/app_colors.dart';

part 'application_binding.dart';
part 'application_controller.dart';

class ApplicationView extends GetView<ApplicationViewController> {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    // ប្រើ DefaultTabController ដើម្បីគ្រប់គ្រង Tab ទាំង ៣
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB), // ពណ៌ផ្ទៃខាងក្រោយស្រាល
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My Applications',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Interview'),
              Tab(text: 'Closed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: ការងារកំពុងរង់ចាំ
            _buildApplicationList(status: 'Pending'),

            // Tab 2: ការងារត្រូវហៅសម្ភាសន៍
            _buildApplicationList(status: 'Interview'),

            // Tab 3: ការងារដែលបិទ ឬធ្លាក់
            _buildApplicationList(status: 'Rejected'),
          ],
        ),
      ),
    );
  }

  // 🎯 មុខងារសម្រាប់បង្កើតបញ្ជីរាយនាមការងារ
  Widget _buildApplicationList({required String status}) {
    // បង្កើត Mock Data បន្តិចបន្តួចដើម្បីមើល UI
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // ចំនួនកាតគំរូ
      itemBuilder: (context, index) {
        return _buildApplicationCard(
          jobTitle: index == 0 ? "Senior Flutter Developer" : "UI/UX Designer",
          companyName: index == 0 ? "Tech Solutions App" : "Creative Studio",
          location: "Phnom Penh, Cambodia",
          appliedDate: "Applied 2 days ago",
          status: status,
          logoUrl:
              "https://via.placeholder.com/150", // ដាក់ URL រូបពិតនៅពេលមាន Data
        );
      },
    );
  }

  // 🎯 មុខងារសម្រាប់គូរកាត (Card) នៃការងារនីមួយៗ
  Widget _buildApplicationCard({
    required String jobTitle,
    required String companyName,
    required String location,
    required String appliedDate,
    required String status,
    required String logoUrl,
  }) {
    // កំណត់ពណ៌តាមស្ថានភាព (Status)
    Color statusColor;
    Color statusBgColor;

    if (status == 'Pending') {
      statusColor = Colors.orange.shade700;
      statusBgColor = Colors.orange.shade50;
    } else if (status == 'Interview') {
      statusColor = AppColors.success;
      statusBgColor = AppColors.success.withOpacity(0.1);
    } else {
      statusColor = Colors.red.shade700;
      statusBgColor = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ផ្នែកខាងលើ៖ រូប Logo និង ស្ថានភាព
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo ក្រុមហ៊ុន
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(logoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // ឈ្មោះការងារ និង ក្រុមហ៊ុន
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // ផ្នែកខាងក្រោម៖ ទីតាំង ពេលវេលា និង Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appliedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Status Pill (បន្តោងពណ៌ប្រាប់ពីស្ថានភាព)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
