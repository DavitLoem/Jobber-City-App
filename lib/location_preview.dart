import 'package:flutter/material.dart';

class LocationStaticPreview extends StatefulWidget {
  const LocationStaticPreview({super.key});

  @override
  State<LocationStaticPreview> createState() => _LocationStaticPreviewState();
}

class _LocationStaticPreviewState extends State<LocationStaticPreview> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedProvince = '';
  String _selectedDistrict = '';

  // ពណ៌ (ចម្លងពី LocationColors)
  final Color _accent = const Color(0xFF2E5BFF);
  final Color _ink = const Color(0xFF0F0F0F);
  final Color _sub = const Color(0xFF8A8A8A);

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom Header & Back Button ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == 1) {
                        _prevPage(); // បើនៅទំព័រស្រុក ឱ្យថយមកខេត្តវិញ
                      } else {
                        Navigator.pop(context); // បើនៅខេត្ត ឱ្យបិទអេក្រង់
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    _currentPage == 0 ? 'Your City' : 'Your District',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                ],
              ),
            ),

            // ── PageView (ស្លាយចុះឡើង) ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // បិទមិនឱ្យអូសដោយដៃ (ត្រូវចុចរើសសិន)
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  // ទំព័រទី ១៖ រើសខេត្ត
                  _buildListView(
                    items: ['Phnom Penh', 'Siem Reap', 'Battambang', 'Kampot'],
                    selectedValue: _selectedProvince,
                    onSelected: (val) {
                      setState(() => _selectedProvince = val);
                      _nextPage(); // ពេលរើសខេត្តរួច ស្លាយទៅមុខអូតូ
                    },
                  ),

                  // ទំព័រទី ២៖ រើសស្រុក (មាន Chip បង្ហាញខេត្តដែលបានរើស)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chip បង្ហាញខេត្តដែលបានរើស
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_city,
                                size: 14,
                                color: _accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _selectedProvince,
                                style: TextStyle(
                                  color: _accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: _prevPage,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: _accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildListView(
                          items: [
                            'Chamkar Mon',
                            'Doun Penh',
                            'Prampir Makara',
                            'Tuol Kouk',
                          ],
                          selectedValue: _selectedDistrict,
                          onSelected: (val) {
                            setState(() => _selectedDistrict = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Continue Button (នៅស្ងៀមមិនរើ) ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: (_currentPage == 1 && _selectedDistrict.isNotEmpty)
                    ? () {
                        // Action ពេលរើសគ្រប់ទាំង ២
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected: $_selectedProvince, $_selectedDistrict',
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  disabledBackgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ជំនួយសម្រាប់គូរ List ចៀសវាងសរសេរកូដជាន់គ្នា
  Widget _buildListView({
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedValue == item;
        return GestureDetector(
          onTap: () => onSelected(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accent.withOpacity(0.05)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? _accent : Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? _accent : _sub,
                ),
                const SizedBox(width: 12),
                Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _ink,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
