import 'package:flutter/material.dart';

class RecentApplicantsSection extends StatelessWidget {
  const RecentApplicantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Applicants",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                letterSpacing: -0.3,
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: const [
                    Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F7DF7),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Color(0xFF4F7DF7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            // នេះគ្រាន់តែជាទិន្នន័យសិប្បនិម្មិត (Mock Data) ដើម្បីឱ្យឃើញ UI
            final mockData = [
              {
                "initials": "AC",
                "name": "Alexandra Chen",
                "role": "Senior Product Designer",
                "status": "Interview",
                "rating": "4.9",
                "date": "Today, 10:30 AM",
                "statusColor": const Color(0xFFEEF2FF),
                "statusTextColor": const Color(0xFF4F7DF7),
              },
              {
                "initials": "MJ",
                "name": "Marcus Johnson",
                "role": "Full Stack Engineer",
                "status": "Review",
                "rating": "4.7",
                "date": "Today, 11:15 AM",
                "statusColor": const Color(0xFFFFFBEB),
                "statusTextColor": const Color(0xFFD97706),
              },
              {
                "initials": "SL",
                "name": "Sarah Lee",
                "role": "Growth Marketing Lead",
                "status": "Screening",
                "rating": "4.5",
                "date": "Yesterday, 2:45 PM",
                "statusColor": const Color(0xFFF1F5F9),
                "statusTextColor": const Color(0xFF64748B),
              },
              {
                "initials": "VL",
                "name": "Victor Lee",
                "role": "Creative Director",
                "status": "Offer",
                "rating": "4.6",
                "date": "Yesterday, 2:45 PM",
                "statusColor": const Color(0xFFECFDF5),
                "statusTextColor": const Color(0xFF10B981),
              },
            ];

            final data = mockData[index];

            return _buildApplicantCard(
              initials: data["initials"] as String,
              name: data["name"] as String,
              role: data["role"] as String,
              status: data["status"] as String,
              rating: data["rating"] as String,
              statusBgColor: data["statusColor"] as Color,
              statusTextColor: data["statusTextColor"] as Color,
              date: data["date"] as String,
            );
          },
        ),
      ],
    );
  }

  // ── ៣. អនុគមន៍សម្រាប់គូរកាតបេក្ខជននីមួយៗ (Reusable Widget) ──
  Widget _buildApplicantCard({
    required String initials,
    required String name,
    required String role,
    required String status,
    required String rating,
    required String date,
    required Color statusBgColor,
    required Color statusTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ផ្នែកទី ១៖ រូប Avatar (អក្សរកាត់)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // ផ្នែកទី ២៖ ឈ្មោះ និង តំណែង
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // ផ្នែកទី ៣៖ ស្លាកស្ថានភាព និង ពិន្ទុ
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Badge ស្ថានភាព (ឧ. Interview)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ពិន្ទុ (Rating)
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
