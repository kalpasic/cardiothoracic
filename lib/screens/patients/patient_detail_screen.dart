import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:path_provider/path_provider.dart';

import 'package:medical_patient_app/widgets/glass_container.dart';
import 'package:medical_patient_app/screens/patients/patient_form_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailScreen({Key? key, required this.patient}) : super(key: key);

  // ================= PDF =================
  Future<Uint8List> _generateEnhancedPDF() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoRegular();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font),
        build: (_) => [
          pw.Text(
            'PATIENT MEDICAL REPORT',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.teal800,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Patient Name: ${patient['name'] ?? 'N/A'}'),
          pw.Text('Generated: ${DateTime.now()}'),
          pw.Divider(),

          _pdfSection('Demographics', [
            ['Age', patient['age']?.toString()],
            ['Sex', patient['sex']],
            ['Address', patient['address']],
          ]),

          _pdfSection('Symptoms', [
            ['Chest Pain', _yesNo(patient['chest_pain'])],
            ['SOB', _yesNo(patient['sob'])],
            ['Palpitations', _yesNo(patient['palpitations'])],
          ]),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfSection(String title, List<List<String?>> rows) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.teal700,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
          },
          children: rows
              .map(
                (r) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(r[0] ?? ''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(r[1] ?? 'N/A'),
                ),
              ],
            ),
          )
              .toList(),
        ),
      ],
    );
  }

  // ================= EMAIL =================
  Future<void> _sendEmail(BuildContext context, Uint8List pdfBytes) async {
    final emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Send Report'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Recipient Email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performEmailSend(
                context,
                emailController.text.trim(),
                pdfBytes,
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _performEmailSend(
      BuildContext context,
      String recipientEmail,
      Uint8List pdfBytes,
      ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
        const Center(child: CircularProgressIndicator()),
      );

      // 🔹 Save PDF to temp file
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/patient_report_${patient['name']}.pdf',
      );
      await file.writeAsBytes(pdfBytes);

      final smtpServer = gmail(
        'your-email@gmail.com',
        'YOUR_APP_PASSWORD',
      );

      final message = Message()
        ..from = const Address('your-email@gmail.com', 'Medical App')
        ..recipients.add(recipientEmail)
        ..subject = 'Patient Report - ${patient['name']}'
        ..text = 'Attached is the patient medical report.'
        ..attachments = [
          FileAttachment(file),
        ];

      await send(message, smtpServer);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient['name'] ?? 'Patient'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PatientFormScreen(patient: patient),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              final pdf = await _generateEnhancedPDF();

              if (value == 'pdf') {
                await Printing.sharePdf(
                  bytes: pdf,
                  filename:
                  'patient_report_${patient['name']}.pdf',
                );
              } else if (value == 'email') {
                await _sendEmail(context, pdf);
              } else if (value == 'print') {
                await Printing.layoutPdf(
                  onLayout: (_) => pdf,
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'pdf',
                child: Text('Generate PDF'),
              ),
              PopupMenuItem(
                value: 'email',
                child: Text('Email Report'),
              ),
              PopupMenuItem(
                value: 'print',
                child: Text('Print'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassContainer(
            child: Column(
              children: [
                Text(
                  patient['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Age: ${patient['age']}'),
                Text('Sex: ${patient['sex']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _yesNo(dynamic value) => value == true ? 'Yes' : 'No';
}
