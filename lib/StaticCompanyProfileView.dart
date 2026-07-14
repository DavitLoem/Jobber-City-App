import 'package:flutter/material.dart';

class StaticCompanyProfileView extends StatelessWidget {
  const StaticCompanyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // ពណ៌ប្រផេះស្រាលខ្លាំង ធ្វើឱ្យកាតពណ៌សលេចធ្លោ
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Company Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 30),

            // ផ្នែកទី១: Basic Information
            _buildSectionCard(
              title: "Company Identity",
              subtitle: "Tell us about your business",
              children: [
                _buildProfileTextField(
                  label: "Company Name *",
                  hint: "e.g. Jobber City Co., Ltd.",
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Industry *",
                  hint: "Select your industry",
                  isDropdown: true,
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Company Size",
                  hint: "Select company size",
                  isDropdown: true,
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Description *",
                  hint: "Briefly describe your company (min 10 chars)...",
                  maxLines: 4,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ផ្នែកទី២: Contact & Location
            _buildSectionCard(
              title: "Contact & Location",
              subtitle: "Where can candidates find you?",
              children: [
                _buildProfileTextField(
                  label: "Contact Email *",
                  hint: "hr@company.com",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Phone Number *",
                  hint: "+855 12 345 678",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Website (Optional)",
                  hint: "https://www.company.com",
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileTextField(
                        label: "Province *",
                        hint: "Select Province",
                        isDropdown: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildProfileTextField(
                        label: "District *",
                        hint: "Select District",
                        isDropdown: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProfileTextField(
                  label: "Address Detail",
                  hint: "Street 123, Sangkat...",
                  maxLines: 2,
                ),
              ],
            ),

            const SizedBox(height: 100), // Space សម្រាប់ប៊ូតុងខាងក្រោម
          ],
        ),
      ),
      // 🟢 ប៊ូតុង Save ស្អិតជាប់ខាងក្រោម (Sticky Bottom Bar)
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blueAccent, // ដូរទៅ AppColors.primary របស់អ្នក
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                "Save Profile",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGETS ទម្រង់ថ្មីដែលមើលទៅ Professional
  // ==========================================

  Widget _buildHeaderSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.business,
                  size: 35,
                  color: Colors.blueAccent, // AppColors.primary
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Upload Company Logo",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Recommended size: 500x500px",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        // ដក Shadow ធំៗចេញ ជំនួសដោយ Flat UI
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // 🎯 ប្រអប់ Text Field ថ្មី (គ្មាន Prefix Icon, មាន Label ខាងលើ)
  Widget _buildProfileTextField({
    required String label,
    required String hint,
    bool isDropdown = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          readOnly: isDropdown,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            suffixIcon: isDropdown
                ? const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  )
                : null,
            filled: true,
            fillColor: Colors.white, // ពណ៌ស
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300), // គែមស្តើង
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
