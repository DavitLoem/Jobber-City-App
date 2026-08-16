import 'package:flutter/material.dart';

class CandidateCoverLetter extends StatelessWidget {
  final String? coverLetter;

  const CandidateCoverLetter({super.key, this.coverLetter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cover Letter",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            coverLetter != null && coverLetter!.isNotEmpty
                ? coverLetter!
                : "No cover letter provided.",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
