import 'package:flutter/material.dart';
import 'package:jobber_city/screens/role/employer/home_employer/widgets/stats_grid.dart'
    show StatsGrid;

class HomeEmployerView extends StatelessWidget {
  const HomeEmployerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // ពណ៌ Background ភ្លឺស្រាល
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎯 ១. ផ្នែកក្បាល (Header & Greeting)
              _buildHeader(),
              const SizedBox(height: 24),

              // 🎯 ២. ផ្ទាំងទិដ្ឋភាពទូទៅ (Hiring Overview / Stats Grid)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  "Here's your hiring overview today.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // ហៅ StatsGrid មកប្រើ (ត្រូវប្រាកដថាបានដក Padding ក្នុង GridView ចេញខ្លះបើវារុញពេក)
              const StatsGrid(),
              const SizedBox(height: 24),

              // 🎯 ៣. ផ្នែកការងារបន្ទាន់ (Needs Attention / Urgent Tasks)
              _buildUrgentTasks(),
              const SizedBox(height: 28),

              // 🎯 ៤. បេក្ខជនថ្មីៗបំផុត (Recent Applicants)
              _buildRecentApplicants(),
              const SizedBox(height: 28),

              // 🎯 ៥. សកម្មភាពរហ័ស (Quick Actions)
              _buildQuickActions(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ── ១. UI សម្រាប់ Header ───────────────────
  // ==========================================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          // Company Logo / Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              // ដាក់រូប Logo ក្រុមហ៊ុន (បណ្តោះអាសន្នប្រើ Icon)
              child: const Icon(Icons.business, color: Color(0xFF2E5BFF)),
            ),
          ),
          const SizedBox(width: 14),

          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good morning,",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "Jobber City",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Search Icon Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 22, color: Colors.black87),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 10),

          // Notification Bell ជាមួយចំណុចក្រហម
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 22,
                    color: Colors.black87,
                  ),
                  onPressed: () {},
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ── ៣. UI សម្រាប់ Urgent Tasks ────────────
  // ==========================================
  Widget _buildUrgentTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED), // ពណ៌ទឹកក្រូចស្រាល
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFEDD5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: Color(0xFFEA580C),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Needs Attention",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9A3412),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "You have 5 unreviewed applications for UI Designer.",
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF9A3412).withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9A3412)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ── ៤. UI សម្រាប់ Recent Applicants ───────
  // ==========================================
  Widget _buildRecentApplicants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Applicants",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2E5BFF),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "See All",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // បញ្ជីបេក្ខជន (Mock Data ៣ នាក់)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/100',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sokha Neth",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "UI/UX Designer • 2h ago",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF2E5BFF,
                      ).withValues(alpha: 0.1),
                      foregroundColor: const Color(0xFF2E5BFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: const Text(
                      "Review",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // ── ៥. UI សម្រាប់ Quick Actions ───────────
  // ==========================================
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              _buildActionCard(
                icon: Icons.add_box_rounded,
                title: "Post a Job",
                color: const Color(0xFF2E5BFF),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                icon: Icons.search_rounded,
                title: "Search CVs",
                color: const Color(0xFF0D9488),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                icon: Icons.calendar_month_rounded,
                title: "Schedule",
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
