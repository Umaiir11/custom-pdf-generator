import 'dart:ui';

import 'package:get/get.dart';
import 'model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class InvoiceController extends GetxController {
  // Reactive variables
  var invoice = InvoiceModel(
    companyName: '',
    companyTagline: '',
    companyEmail: '',
    invoiceNumber: '',
    issueDate: '',
    clientName: '',
    clientAddress: '',
    clientPhone: '',
    clientEmail: '',
    accountNumber: '',
    bankCode: '',
    branchName: '',
    description: '',
    items: [],
    termsAndConditions: '',
    signatureName: '',
    signatureTitle: '',
  ).obs;

  var items = <InvoiceItem>[].obs;

  void updateInvoice({
    String? companyName,
    String? companyTagline,
    String? companyEmail,
    String? invoiceNumber,
    String? issueDate,
    String? clientName,
    String? clientAddress,
    String? clientPhone,
    String? clientEmail,
    String? accountNumber,
    String? bankCode,
    String? branchName,
    String? description,
    String? termsAndConditions,
    String? signatureName,
    String? signatureTitle,
  }) {
    invoice.value = InvoiceModel(
      companyName: companyName ?? invoice.value.companyName,
      companyTagline: companyTagline ?? invoice.value.companyTagline,
      companyEmail: companyEmail ?? invoice.value.companyEmail,
      invoiceNumber: invoiceNumber ?? invoice.value.invoiceNumber,
      issueDate: issueDate ?? invoice.value.issueDate,
      clientName: clientName ?? invoice.value.clientName,
      clientAddress: clientAddress ?? invoice.value.clientAddress,
      clientPhone: clientPhone ?? invoice.value.clientPhone,
      clientEmail: clientEmail ?? invoice.value.clientEmail,
      accountNumber: accountNumber ?? invoice.value.accountNumber,
      bankCode: bankCode ?? invoice.value.bankCode,
      branchName: branchName ?? invoice.value.branchName,
      description: description ?? invoice.value.description,
      items: items.toList(),
      termsAndConditions: termsAndConditions ?? invoice.value.termsAndConditions,
      signatureName: signatureName ?? invoice.value.signatureName,
      signatureTitle: signatureTitle ?? invoice.value.signatureTitle,
    );
  }

  void addItem(String description, double price, int quantity) {
    items.add(InvoiceItem(description: description, price: price, quantity: quantity));
    updateInvoice();
  }

  Future<void> generatePDF() async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.margins.all = 0;

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfGraphics graphics = page.graphics;

    // Colors
    final PdfColor primaryColor = PdfColor(33, 150, 243);
    final PdfColor darkColor = PdfColor(33, 33, 33);
    final PdfColor darkGrayColor = PdfColor(80, 80, 80);
    final PdfColor mediumGrayColor = PdfColor(180, 180, 180);
    final PdfColor whiteColor = PdfColor(255, 255, 255);

    // Fonts
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
    final PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont sectionTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFont tableHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    // Header
    graphics.drawRectangle(brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(0, 0, pageSize.width, 120));
    final PdfPath blueAccentPath = PdfPath();
    blueAccentPath.addPolygon([Offset(pageSize.width, 0), Offset(pageSize.width, 120), Offset(pageSize.width - 150, 120)]);
    graphics.drawPath(blueAccentPath, brush: PdfSolidBrush(primaryColor));
    final PdfPath blueAccentPath2 = PdfPath();
    blueAccentPath2.addPolygon([Offset(0, 120), Offset(150, 120), Offset(0, 80)]);
    graphics.drawPath(blueAccentPath2, brush: PdfSolidBrush(primaryColor));

    graphics.drawString(invoice.value.companyName, headerFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(40, 35, pageSize.width - 80, 30));
    graphics.drawString(invoice.value.companyTagline, normalFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(40, 65, pageSize.width - 80, 20));
    graphics.drawString('INVOICE', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(pageSize.width - 150, 35, 110, 30), format: PdfStringFormat(alignment: PdfTextAlignment.right));

    double yPos = 65;
    graphics.drawString('Invoice Number: ${invoice.value.invoiceNumber}', normalFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawString('Issue Date: ${invoice.value.issueDate}', normalFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawString('Email: ${invoice.value.companyEmail}', normalFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));

    // Invoice To
    yPos = 150;
    graphics.drawString('INVOICED TO:', sectionTitleFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 30));
    yPos += 25;
    graphics.drawString(invoice.value.clientName, boldFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 20));
    yPos += 15;
    graphics.drawString(invoice.value.clientAddress, normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 20));
    yPos += 15;
    graphics.drawString('Phone: ${invoice.value.clientPhone}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 20));
    yPos += 15;
    graphics.drawString('Email: ${invoice.value.clientEmail}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 20));

    // Payment Method
    yPos = 150;
    graphics.drawString('PAYMENT METHOD', sectionTitleFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 30), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 25;
    graphics.drawString('Account No: ${invoice.value.accountNumber}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawString('Bank Code: ${invoice.value.bankCode}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawString('Branch Name: ${invoice.value.branchName}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos, 190, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));

    // Description
    yPos += 30;
    graphics.drawString(invoice.value.description, normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 60));

    // Items table
    yPos += 70;
    graphics.drawRectangle(brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 30));
    graphics.drawString('No.', tableHeaderFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(50, yPos + 8, 30, 20));
    graphics.drawString('Product Description', tableHeaderFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(90, yPos + 8, 200, 20));
    graphics.drawString('Price', tableHeaderFont, brush: PdfSolidBrush(whiteColor), format: PdfStringFormat(alignment: PdfTextAlignment.center), bounds: Rect.fromLTWH(pageSize.width - 280, yPos + 8, 80, 20));
    graphics.drawString('Quantity', tableHeaderFont, brush: PdfSolidBrush(whiteColor), format: PdfStringFormat(alignment: PdfTextAlignment.center), bounds: Rect.fromLTWH(pageSize.width - 200, yPos + 8, 80, 20));
    graphics.drawString('Total', tableHeaderFont, brush: PdfSolidBrush(whiteColor), format: PdfStringFormat(alignment: PdfTextAlignment.right), bounds: Rect.fromLTWH(pageSize.width - 120, yPos + 8, 80, 20));

    yPos += 30;
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      graphics.drawString('${(i + 1).toString().padLeft(2, '0')}.', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(50, yPos + 12, 30, 20));
      graphics.drawString(item.description, normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(90, yPos + 12, 200, 40));
      graphics.drawString('\$${item.price.toStringAsFixed(2)}', normalFont, brush: PdfSolidBrush(darkGrayColor), format: PdfStringFormat(alignment: PdfTextAlignment.center), bounds: Rect.fromLTWH(pageSize.width - 280, yPos + 12, 80, 20));
      graphics.drawString(item.quantity.toString(), normalFont, brush: PdfSolidBrush(darkGrayColor), format: PdfStringFormat(alignment: PdfTextAlignment.center), bounds: Rect.fromLTWH(pageSize.width - 200, yPos + 12, 80, 20));
      graphics.drawString('\$${item.total.toStringAsFixed(2)}', normalFont, brush: PdfSolidBrush(darkGrayColor), format: PdfStringFormat(alignment: PdfTextAlignment.right), bounds: Rect.fromLTWH(pageSize.width - 120, yPos + 12, 80, 20));
      yPos += 40;
    }

    // Summary
    yPos += 20;
    final double summaryX = pageSize.width - 230;
    graphics.drawString('Subtotal:', boldFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(summaryX, yPos, 110, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    graphics.drawString('\$${invoice.value.subtotal.toStringAsFixed(2)}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(summaryX + 110, yPos, 80, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawString('Tax (0%):', boldFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(summaryX, yPos, 110, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    graphics.drawString('\$${invoice.value.tax.toStringAsFixed(2)}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(summaryX + 110, yPos, 80, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));
    yPos += 15;
    graphics.drawRectangle(brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(summaryX, yPos, 190, 30));
    graphics.drawString('TOTAL', boldFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(summaryX + 10, yPos + 8, 100, 20));
    graphics.drawString('\$${invoice.value.total.toStringAsFixed(2)}', boldFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(summaryX + 110, yPos + 8, 80, 20), format: PdfStringFormat(alignment: PdfTextAlignment.right));

    // Terms
    yPos += 50;
    graphics.drawString('TERMS & CONDITIONS:', sectionTitleFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, 200, 30));
    yPos += 25;
    graphics.drawString(invoice.value.termsAndConditions, normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 60));

    // Footer
    yPos += 70;
    graphics.drawString('Thank You For Your Business', sectionTitleFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 30));
    graphics.drawLine(PdfPen(mediumGrayColor, width: 1), Offset(pageSize.width - 230, yPos + 40), Offset(pageSize.width - 40, yPos + 40));
    graphics.drawString('${invoice.value.signatureName}\n${invoice.value.signatureTitle}', normalFont, brush: PdfSolidBrush(darkGrayColor), bounds: Rect.fromLTWH(pageSize.width - 230, yPos + 50, 190, 40), format: PdfStringFormat(alignment: PdfTextAlignment.right));

    final List<int> bytes = await document.save();
    document.dispose();
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
      print('Error saving or opening PDF: $e');
    }
  }
}