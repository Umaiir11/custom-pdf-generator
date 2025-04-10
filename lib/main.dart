import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern PDF Invoice Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const InvoiceGeneratorScreen(),
    );
  }
}

class InvoiceGeneratorScreen extends StatelessWidget {
  const InvoiceGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade800,
              Colors.indigo.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Modern Invoice Generator',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Create beautiful, professional A4 invoices',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton.icon(
                  onPressed: () async {
                    _createModernPDF(context);
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('GENERATE INVOICE'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.indigo.shade800,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 8,
                    shadowColor: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createModernPDF(BuildContext context) async {
    // Create a PDF document
    final PdfDocument document = PdfDocument();

    // Set the page size to A4
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.margins.all = 0;

    // Add a page to the document
    final PdfPage page = document.pages.add();

    // Get page client size to make it responsive
    final Size pageSize = page.getClientSize();

    // Create a PDF graphics for the page
    final PdfGraphics graphics = page.graphics;

    // Define colors
    final PdfColor primaryColor = PdfColor(33, 150, 243); // Blue from the invoice
    final PdfColor darkColor = PdfColor(33, 33, 33); // Dark background
    final PdfColor lightGrayColor = PdfColor(240, 240, 240);
    final PdfColor mediumGrayColor = PdfColor(180, 180, 180);
    final PdfColor darkGrayColor = PdfColor(80, 80, 80);
    final PdfColor whiteColor = PdfColor(255, 255, 255);

    // Create fonts
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
    final PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont sectionTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

    // Draw header background (dark with blue diagonal accents)
    graphics.drawRectangle(
      brush: PdfSolidBrush(darkColor),
      bounds: Rect.fromLTWH(0, 0, pageSize.width, 120),
    );

    // Draw blue diagonal accent (top-right triangle)
    final PdfPath blueAccentPath = PdfPath();
    blueAccentPath.addPolygon([
      Offset(pageSize.width, 0),
      Offset(pageSize.width, 120),
      Offset(pageSize.width - 150, 120),
    ]);
    graphics.drawPath(
      blueAccentPath,
      brush: PdfSolidBrush(primaryColor),
    );

    // Draw another blue diagonal accent (bottom-left triangle)
    final PdfPath blueAccentPath2 = PdfPath();
    blueAccentPath2.addPolygon([
      Offset(0, 120),
      Offset(150, 120),
      Offset(0, 80),
    ]);
    graphics.drawPath(
      blueAccentPath2,
      brush: PdfSolidBrush(primaryColor),
    );

    // Company header
    graphics.drawString(
      'Tagmuh Media',
      headerFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(40, 35, pageSize.width - 80, 30),
    );

    // Company tagline
    graphics.drawString(
      'COMPANY TAGLINE HERE',
      normalFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(40, 65, pageSize.width - 80, 20),
    );

    // Invoice title and details (right-aligned)
    graphics.drawString(
      'INVOICE',
      subHeaderFont,
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(pageSize.width - 150, 35, 110, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    double yPos = 65;
    graphics.drawString(
      'Invoice Number: INV-250410-487430',
      normalFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 15;
    graphics.drawString(
      'Issue Date: 2025-04-10',
      normalFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 15;
    graphics.drawString(
      'Email: Tagmuhmedia@gmail.com',
      normalFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Invoice To and Payment Method sections (side by side)
    yPos = 150;
    graphics.drawString(
      'INVOICED TO:',
      sectionTitleFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 30),
    );

    yPos += 25;
    graphics.drawString(
      'Seaside Voucher',
      boldFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 20),
    );

    yPos += 15;
    graphics.drawString(
      'Sahiwal, Pakistan',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 20),
    );

    yPos += 15;
    graphics.drawString(
      'Phone: +92 123 456 7890',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 20),
    );

    yPos += 15;
    graphics.drawString(
      'Email: seaside@gmail.com',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 20),
    );

    // Payment Method section
    yPos = 150;
    graphics.drawString(
      'PAYMENT METHOD',
      sectionTitleFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 25;
    graphics.drawString(
      'Account No: flg - 662225555580',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 15;
    graphics.drawString(
      'Bank Code: 850',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 15;
    graphics.drawString(
      'Branch Name: tesr',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Description placeholder
    yPos += 30;
    graphics.drawString(
      'Dear Client,\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel facilisis. Lorem ipsum dolor sit amet consectetur adipiscing elit sed.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 60),
    );

    // Items table
    yPos += 70;
    // Table header
    graphics.drawRectangle(
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 30),
    );

    final PdfFont tableHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    graphics.drawString(
      'No.',
      tableHeaderFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(50, yPos + 8, 30, 20),
    );

    graphics.drawString(
      'Product Description',
      tableHeaderFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(90, yPos + 8, 200, 20),
    );

    graphics.drawString(
      'Price',
      tableHeaderFont,
      brush: PdfSolidBrush(whiteColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 280, yPos + 8, 80, 20),
    );

    graphics.drawString(
      'Quantity',
      tableHeaderFont,
      brush: PdfSolidBrush(whiteColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 200, yPos + 8, 80, 20),
    );

    graphics.drawString(
      'Total',
      tableHeaderFont,
      brush: PdfSolidBrush(whiteColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 120, yPos + 8, 80, 20),
    );

    // Table rows
    yPos += 30;

    // Row 1
    graphics.drawString(
      '01.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(50, yPos + 12, 30, 20),
    );
    graphics.drawString(
      'tesr1\nLorem ipsum dolor sit amet, consectetur adipiscing elit.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(90, yPos + 12, 200, 40),
    );
    graphics.drawString(
      '\$35',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 280, yPos + 12, 80, 20),
    );
    graphics.drawString(
      '2',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 200, yPos + 12, 80, 20),
    );
    graphics.drawString(
      '\$70.00',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 120, yPos + 12, 80, 20),
    );

    // Row 2
    yPos += 40;
    graphics.drawString(
      '02.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(50, yPos + 12, 30, 20),
    );
    graphics.drawString(
      'item 2\nLorem ipsum dolor sit amet, consectetur adipiscing elit.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(90, yPos + 12, 200, 40),
    );
    graphics.drawString(
      '\$55',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 280, yPos + 12, 80, 20),
    );
    graphics.drawString(
      '2',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 200, yPos + 12, 80, 20),
    );
    graphics.drawString(
      '\$110.00',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 120, yPos + 12, 80, 20),
    );

    // Summary section
    yPos += 60;
    final double summaryX = pageSize.width - 230;
    graphics.drawString(
      'Subtotal:',
      boldFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(summaryX, yPos, 110, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
    graphics.drawString(
      '\$180.00',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(summaryX + 110, yPos, 80, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    yPos += 15;
    graphics.drawString(
      'Tax (0%):',
      boldFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(summaryX, yPos, 110, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
    graphics.drawString(
      '\$0.00',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(summaryX + 110, yPos, 80, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Total with blue background
    yPos += 15;
    graphics.drawRectangle(
      brush: PdfSolidBrush(primaryColor),
      bounds: Rect.fromLTWH(summaryX, yPos, 190, 30),
    );
    graphics.drawString(
      'TOTAL',
      boldFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(summaryX + 10, yPos + 8, 100, 20),
    );
    graphics.drawString(
      '\$180.00',
      boldFont,
      brush: PdfSolidBrush(whiteColor),
      bounds: Rect.fromLTWH(summaryX + 110, yPos + 8, 80, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Terms & Conditions
    yPos += 50;
    graphics.drawString(
      'TERMS & CONDITIONS:',
      sectionTitleFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, 200, 30),
    );

    yPos += 25;
    graphics.drawString(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\nQuis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel facilisis.',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 60),
    );

    // Footer with Thank You and Signature
    yPos += 70;
    graphics.drawString(
      'Thank You For Your Business',
      sectionTitleFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 30),
    );

    // Signature placeholder
    graphics.drawLine(
      PdfPen(mediumGrayColor, width: 1),
      Offset(pageSize.width - 230, yPos + 40),
      Offset(pageSize.width - 40, yPos + 40),
    );
    graphics.drawString(
      'Your Name & Signature\nAccount Manager',
      normalFont,
      brush: PdfSolidBrush(darkGrayColor),
      bounds: Rect.fromLTWH(pageSize.width - 230, yPos + 50, 190, 40),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Save and launch the document
    final List<int> bytes = await document.save();

    // Clean up resources
    document.dispose();

    // Save the PDF to a file and open it
    await _savePdfAndOpen(bytes, 'modern_invoice.pdf');
  }




  Future<void> _savePdfAndOpen(List<int> bytes, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/$fileName';
      final File file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      await OpenFile.open(path);
    } catch (e) {
      // Handle error
      print('Error saving or opening PDF: $e');
    }
  }
}