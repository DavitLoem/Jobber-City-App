import 'package:intl/intl.dart';
import 'package:jobber_city/models/role/employer/applicant_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportHelper {
  static Future<void> generateAndPreviewCandidatesPdf({
    required List<ApplicantModel> applicants,
    required String status,
    required String jobTitle,
  }) async {
    final pdf = pw.Document();

    // ទាញយក Font គាំទ្រ Unicode (ខ្មែរ & អង់គ្លេស)
    final fontRegular = await PdfGoogleFonts.notoSansKhmerRegular();
    final fontBold = await PdfGoogleFonts.notoSansKhmerBold();
    final pdfTheme = pw.ThemeData.withFont(base: fontRegular, bold: fontBold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        theme: pdfTheme,
        build: (pw.Context context) {
          return [
            // ── បឋមកថា (Header) ──
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "INTERVIEW SCORECARD",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Position: $jobTitle",
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      "Filter: ${status.toUpperCase()}",
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  "Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 24),

            // ── 🟢 ការពារតារាងពេលទិន្នន័យទទេ ──
            if (applicants.isEmpty)
              pw.Center(
                child: pw.Text(
                  "No candidates found for this report.",
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey600,
                  ),
                ),
              )
            else
              // ── តារាងបេក្ខជន (Table) ──
              pw.TableHelper.fromTextArray(
                context: context,
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue50,
                ),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                  fontSize: 11,
                ),
                cellStyle: const pw.TextStyle(fontSize: 10),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                  ),
                ),
                // 🟢 កំណត់ទំហំប្រវែង Column ថ្មី
                columnWidths: {
                  0: const pw.FlexColumnWidth(0.5), // No.
                  1: const pw.FlexColumnWidth(1.6), // Name
                  2: const pw.FlexColumnWidth(0.8), // Gender (ថ្មី)
                  3: const pw.FlexColumnWidth(2.2), // Contact Info
                  4: const pw.FlexColumnWidth(1.5), // Skills
                  5: const pw.FlexColumnWidth(1.5), // Date
                  6: const pw.FlexColumnWidth(
                    3.0,
                  ), // Score / Notes (ពង្រីកធំជាងមុន)
                },
                // 🟢 បន្ថែម Headers Gender
                headers: [
                  'No.',
                  'Candidate',
                  'Gender',
                  'Contact Info',
                  'Skills / Exp.',
                  'Interview Date',
                  'Score / Notes',
                ],
                data: List.generate(applicants.length, (index) {
                  final app = applicants[index];

                  String interviewDate = 'TBD';
                  if (app.interviewSchedule != null &&
                      app.interviewSchedule!['date'] != null) {
                    try {
                      String dateStr = app.interviewSchedule!['date'];
                      if (!dateStr.endsWith('Z')) dateStr += 'Z';
                      final date = DateTime.parse(dateStr).toLocal();
                      interviewDate = DateFormat(
                        'dd/MM/yyyy\nhh:mm a',
                      ).format(date);
                    } catch (_) {}
                  }

                  String skills = app.skills.take(2).join(', ');
                  if (skills.isEmpty)
                    skills = '${app.yearsOfExperience} Yrs Exp';

                  // Mock Data (សម្រាប់ Preview សិន)
                  String mockGender = "Male";
                  String mockEmail =
                      "${app.fullName.split(' ').last.toLowerCase()}@email.com";
                  String mockPhone = "012 345 678";

                  return [
                    (index + 1).toString(),
                    app.fullName,
                    mockGender, // 🟢 បញ្ចូលទិន្នន័យទៅ Column ថ្មី
                    '$mockEmail\n$mockPhone',
                    skills,
                    interviewDate,
                    ' ', // ទុកចំហរសម្រាប់ HR សរសេរដៃ
                  ];
                }),
              ),
          ];
        },
      ),
    );

    // លោតផ្ទាំង Preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Candidates_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
