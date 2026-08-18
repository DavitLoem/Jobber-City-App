import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ExcelExportHelper {
  // 🟢 ប្តូរឈ្មោះអនុគមន៍បន្តិចឱ្យសមស្រប (Download)
  static Future<void> generateAndDownloadCandidatesExcel({
    required List<ApplicantModel> applicants,
    required String status,
    required String jobTitle,
  }) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Candidates'];
      excel.setDefaultSheet('Candidates');

      List<String> headers = [
        'No.',
        'Candidate Name',
        'Gender',
        'Email',
        'Phone',
        'Skills',
        'Experience',
        'Interview Date',
        'Status',
        'Notes',
      ];

      sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

      for (int i = 0; i < applicants.length; i++) {
        final app = applicants[i];

        String interviewDate = 'Not Scheduled';
        if (app.interviewSchedule != null &&
            app.interviewSchedule!['date'] != null) {
          try {
            String dateStr = app.interviewSchedule!['date'];
            if (!dateStr.endsWith('Z')) dateStr += 'Z';
            final date = DateTime.parse(dateStr).toLocal();
            interviewDate = DateFormat('dd-MMM-yyyy hh:mm a').format(date);
          } catch (_) {}
        }

        String skills = app.skills.join(', ');

        // Mock Data សិន
        String gender = "Male";
        String email =
            "${app.fullName.split(' ').last.toLowerCase()}@email.com";
        String phone = "012 345 678";

        List<CellValue> row = [
          IntCellValue(i + 1),
          TextCellValue(app.fullName),
          TextCellValue(gender),
          TextCellValue(email),
          TextCellValue(phone),
          TextCellValue(skills),
          TextCellValue('${app.yearsOfExperience} Years'),
          TextCellValue(interviewDate),
          TextCellValue(app.status.toUpperCase()),
          TextCellValue(''),
        ];

        sheetObject.appendRow(row);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        // 🟢 ១. ស្វែងរកទីតាំង Folder សម្រាប់ Download ជាសាធារណៈ
        Directory? directory;
        if (Platform.isAndroid) {
          // ដាក់ចូល Folder Downloads របស់ទូរស័ព្ទ Android
          directory = Directory('/storage/emulated/0/Download');
          // បើទូរស័ព្ទខ្លះរកអត់ឃើញ យកទីតាំងបម្រុង
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          // សម្រាប់ iOS គឺតម្រូវឱ្យប្រើប្រាស់ Documents Directory
          directory = await getApplicationDocumentsDirectory();
        }

        String formattedDate = DateFormat(
          'dd_MMM_yyyy_HHmmss',
        ).format(DateTime.now());
        final filePath =
            '${directory!.path}/Candidates_${status}_$formattedDate.xlsx';

        // 🟢 ២. រក្សាទុកឯកសារចូលទៅក្នុង Folder នោះ
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);

        // 🟢 ៣. បង្ហាញសារបញ្ជាក់ថាដោនឡូតជោគជ័យ (មានប៊ូតុង OPEN ឱ្យចុចស្រេចចិត្ត)
        Get.snackbar(
          "Download Complete",
          "Excel file saved to Downloads folder.",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          mainButton: TextButton(
            onPressed: () {
              // ពេលគាត់ចុច OPEN ទើបយើងព្យាយាមបើកកម្មវិធី Excel (បើគាត់អត់ចុច គឺវាដោនឡូតទុកធម្មតា)
              OpenFilex.open(filePath);
            },
            child: const Text(
              "OPEN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Excel Export Error: $e");
      Get.snackbar(
        "Download Failed",
        "Make sure you have granted storage permissions.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }
}
