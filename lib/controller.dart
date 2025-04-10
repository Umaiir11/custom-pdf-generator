import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'model.dart';

class ResumeController extends GetxController {
  var resume = ResumeModel(
    fullName: '',
    jobTitle: '',
    phone: '',
    email: '',
    address: '',
    website: '',
    profileSummary: '',
    education: [],
    workExperience: [],
    skills: [],
    languages: [],
    references: [],
  ).obs;

  var educationList = <Education>[].obs;
  var workExperienceList = <WorkExperience>[].obs;
  var skillsList = <String>[].obs;
  var languagesList = <Language>[].obs;
  var referencesList = <Reference>[].obs;

  void updateResume({
    String? fullName,
    String? jobTitle,
    String? phone,
    String? email,
    String? address,
    String? website,
    String? profileSummary,
  }) {
    resume.value = ResumeModel(
      fullName: fullName ?? resume.value.fullName,
      jobTitle: jobTitle ?? resume.value.jobTitle,
      phone: phone ?? resume.value.phone,
      email: email ?? resume.value.email,
      address: address ?? resume.value.address,
      website: website ?? resume.value.website,
      profileSummary: profileSummary ?? resume.value.profileSummary,
      education: educationList.toList(),
      workExperience: workExperienceList.toList(),
      skills: skillsList.toList(),
      languages: languagesList.toList(),
      references: referencesList.toList(),
    );
  }

  void addEducation(String period, String institution, String degree, String gpa) {
    educationList.add(Education(period: period, institution: institution, degree: degree, gpa: gpa));
    updateResume();
  }

  void addWorkExperience(String period, String company, String position, List<String> responsibilities) {
    workExperienceList.add(WorkExperience(period: period, company: company, position: position, responsibilities: responsibilities));
    updateResume();
  }

  void addSkill(String skill) {
    skillsList.add(skill);
    updateResume();
  }

  void addLanguage(String name, String proficiency) {
    languagesList.add(Language(name: name, proficiency: proficiency));
    updateResume();
  }

  void addReference(String name, String position, String phone, String email) {
    referencesList.add(Reference(name: name, position: position, phone: phone, email: email));
    updateResume();
  }

  Future<void> generatePDF() async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = PdfPageSize.a4;
    document.pageSettings.margins.all = 0;

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfGraphics graphics = page.graphics;

    // Define theme colors (based on examples)
    final PdfColor primaryColor = PdfColor(33, 37, 41); // Dark for text
    final PdfColor secondaryColor = PdfColor(52, 58, 64); // For section headers
    final PdfColor accentColor = PdfColor(0, 123, 255); // Blue accent
    final PdfColor lightBgColor = PdfColor(240, 240, 240); // Light gray for sidebar
    final PdfColor darkBgColor = PdfColor(52, 58, 64); // Dark for header areas
    final PdfColor whiteColor = PdfColor(255, 255, 255);

    // Choose theme based on preference (could be user-selectable)
    bool useDarkTheme = false; // Set to true for dark header theme like in image 2

    // Fonts
    final PdfFont nameFont = PdfStandardFont(PdfFontFamily.helvetica, 28, style: PdfFontStyle.bold);
    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 16);
    final PdfFont sectionHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    // Layout dimensions
    const double sidebarWidth = 180;
    double mainContentWidth = pageSize.width - sidebarWidth;
    const double contentMargin = 20;
    const double headerHeight = 100; // Height of the top header area

    // Draw header background
    if (useDarkTheme) {
      // Dark header similar to image 2
      graphics.drawRectangle(
          brush: PdfSolidBrush(darkBgColor),
          bounds: Rect.fromLTWH(0, 0, pageSize.width, headerHeight)
      );
    } else {
      // Light header similar to image 1
      graphics.drawRectangle(
          brush: PdfSolidBrush(PdfColor(230, 242, 255)),  // Light blue from image 1
          bounds: Rect.fromLTWH(0, 0, pageSize.width, headerHeight)
      );
    }

    // Draw sidebar background
    graphics.drawRectangle(
        brush: PdfSolidBrush(lightBgColor),
        bounds: Rect.fromLTWH(0, useDarkTheme ? headerHeight : 0, sidebarWidth, pageSize.height)
    );

    // Header content (Name and title)
    double yPos = 30;
    PdfColor headerTextColor = useDarkTheme ? whiteColor : primaryColor;

    // Draw decorative elements like in Image 1
    if (!useDarkTheme) {
      // Left header line
      graphics.drawLine(
          PdfPen(primaryColor, width: 0.5),
          Offset(50, yPos + 15),
          Offset(170, yPos + 15)
      );
      // Circle
      graphics.drawEllipse(
          Rect.fromCenter(center: Offset(175, yPos + 15), width: 6, height: 6),
          pen: PdfPen(primaryColor, width: 0.5)
      );

      // Right header line
      graphics.drawLine(
          PdfPen(primaryColor, width: 0.5),
          Offset(pageSize.width - 50, yPos + 15),
          Offset(pageSize.width - 170, yPos + 15)
      );
      // Circle
      graphics.drawEllipse(
          Rect.fromCenter(center: Offset(pageSize.width - 175, yPos + 15), width: 6, height: 6),
          pen: PdfPen(primaryColor, width: 0.5)
      );
    }

    // Name centered
    final Size nameSize = nameFont.measureString(resume.value.fullName.toUpperCase());
    graphics.drawString(
        resume.value.fullName.toUpperCase(),
        nameFont,
        brush: PdfSolidBrush(headerTextColor),
        bounds: Rect.fromLTWH((pageSize.width - nameSize.width) / 2, yPos, pageSize.width, 40)
    );
    yPos += 40;

    // Job title centered
    final Size titleSize = titleFont.measureString(resume.value.jobTitle);
    graphics.drawString(
        resume.value.jobTitle,
        titleFont,
        brush: PdfSolidBrush(headerTextColor),
        bounds: Rect.fromLTWH((pageSize.width - titleSize.width) / 2, yPos, pageSize.width, 25)
    );

    // Reset positions for content sections
    double sidebarYPos = useDarkTheme ? headerHeight + 30 : 120;
    yPos = useDarkTheme ? headerHeight + 30 : 120;

    // Photo placeholder if desired (like in Image 2)
    if (useDarkTheme) {
      // Draw circular photo frame in sidebar
      final double photoSize = 120;
      final double photoX = (sidebarWidth - photoSize) / 2;
      final double photoY = headerHeight + 30;

      // Photo background circle
      graphics.drawEllipse(
          Rect.fromLTWH(photoX, photoY, photoSize, photoSize),
          brush: PdfSolidBrush(PdfColor(220, 220, 220))
      );

      // Placeholder text for photo
      final PdfFont photoFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
      final String photoText = "PHOTO";
      final Size photoTextSize = photoFont.measureString(photoText);
      graphics.drawString(
          photoText,
          photoFont,
          brush: PdfSolidBrush(PdfColor(150, 150, 150)),
          bounds: Rect.fromLTWH(
              photoX + (photoSize - photoTextSize.width) / 2,
              photoY + photoSize / 2,
              photoTextSize.width,
              photoTextSize.height
          )
      );

      sidebarYPos += photoSize + 30;
    }

    // Sidebar Content
    // CONTACT SECTION
    drawSectionHeader(graphics, 'CONTACT', contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    sidebarYPos += 30;

    // Phone with icon-like element
    drawContactItem(graphics, '📱', '+123-456-7890', contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, normalFont, primaryColor);
    sidebarYPos += 20;

    // Email with icon-like element
    drawContactItem(graphics, '✉️', resume.value.email, contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, normalFont, primaryColor);
    sidebarYPos += 20;

    // Address with icon-like element
    drawContactItem(graphics, '📍', resume.value.address, contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, normalFont, primaryColor);
    sidebarYPos += 20;

    // Website with icon-like element
    if (resume.value.website.isNotEmpty) {
      drawContactItem(graphics, '🌐', resume.value.website, contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, normalFont, primaryColor);
      sidebarYPos += 25;
    }
    sidebarYPos += 15;

    // EDUCATION SECTION
    drawSectionHeader(graphics, 'EDUCATION', contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    sidebarYPos += 30;

    for (var edu in resume.value.education) {
      // Period (years)
      graphics.drawString(
          edu.period,
          boldFont,
          brush: PdfSolidBrush(primaryColor),
          bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
      );
      sidebarYPos += 18;

      // Institution name
      graphics.drawString(
          edu.institution.toUpperCase(),
          boldFont,
          brush: PdfSolidBrush(secondaryColor),
          bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
      );
      sidebarYPos += 18;

      // Degree
      graphics.drawString(
          '• ${edu.degree}',
          normalFont,
          brush: PdfSolidBrush(primaryColor),
          bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
      );
      sidebarYPos += 15;

      // GPA if available
      if (edu.gpa.isNotEmpty) {
        graphics.drawString(
            '• GPA: ${edu.gpa}',
            normalFont,
            brush: PdfSolidBrush(primaryColor),
            bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
        );
        sidebarYPos += 15;
      }

      sidebarYPos += 10;
    }

    // SKILLS SECTION
    drawSectionHeader(graphics, 'SKILLS', contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    sidebarYPos += 30;

    for (var skill in resume.value.skills) {
      graphics.drawString(
          '• $skill',
          normalFont,
          brush: PdfSolidBrush(primaryColor),
          bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
      );
      sidebarYPos += 15;
    }
    sidebarYPos += 15;

    // LANGUAGES SECTION
    drawSectionHeader(graphics, 'LANGUAGES', contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    sidebarYPos += 30;

    for (var lang in resume.value.languages) {
      graphics.drawString(
          '• ${lang.name}: ${lang.proficiency}',
          normalFont,
          brush: PdfSolidBrush(primaryColor),
          bounds: Rect.fromLTWH(contentMargin, sidebarYPos, sidebarWidth - 2 * contentMargin, 20)
      );
      sidebarYPos += 15;
    }

    // Main Content (Right Column)
    // PROFILE SUMMARY
    drawSectionHeader(graphics, 'PROFILE SUMMARY', sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    yPos += 30;

    final PdfStringFormat paragraphFormat = PdfStringFormat(
        alignment: PdfTextAlignment.justify,
        lineSpacing: 5
    );

    graphics.drawString(
        resume.value.profileSummary,
        normalFont,
        brush: PdfSolidBrush(primaryColor),
        bounds: Rect.fromLTWH(sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, 100),
        format: paragraphFormat
    );
    yPos += calculateTextHeight(resume.value.profileSummary, normalFont, mainContentWidth - 2 * contentMargin) + 20;

    // WORK EXPERIENCE
    drawSectionHeader(graphics, 'PROFESSIONAL EXPERIENCE', sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
    yPos += 30;

    for (var exp in resume.value.workExperience) {
      // Create header row with company and date on same line
      graphics.drawString(
          exp.company,
          boldFont,
          brush: PdfSolidBrush(secondaryColor),
          bounds: Rect.fromLTWH(sidebarWidth + contentMargin, yPos, mainContentWidth / 2 - contentMargin, 20)
      );

      // Right-aligned date
      graphics.drawString(
          exp.period,
          boldFont,
          brush: PdfSolidBrush(accentColor),
          bounds: Rect.fromLTWH(sidebarWidth + mainContentWidth / 2, yPos, mainContentWidth / 2 - contentMargin, 20),
          format: PdfStringFormat(alignment: PdfTextAlignment.right)
      );
      yPos += 20;

      // Position
      graphics.drawString(
          exp.position,
          boldFont,
          brush: PdfSolidBrush(primaryColor),
          bounds: Rect.fromLTWH(sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, 20)
      );
      yPos += 20;

      // Draw a subtle divider line
      graphics.drawLine(
          PdfPen(PdfColor(200, 200, 200), width: 0.5),
          Offset(sidebarWidth + contentMargin, yPos - 5),
          Offset(pageSize.width - contentMargin, yPos - 5)
      );

      // Responsibilities as bullet points
      for (var responsibility in exp.responsibilities) {
        graphics.drawString(
            '• $responsibility',
            normalFont,
            brush: PdfSolidBrush(primaryColor),
            bounds: Rect.fromLTWH(sidebarWidth + contentMargin + 10, yPos, mainContentWidth - 2 * contentMargin - 10, 40),
            format: paragraphFormat
        );
        yPos += calculateTextHeight('• $responsibility', normalFont, mainContentWidth - 2 * contentMargin - 10) + 5;
      }

      yPos += 15;
    }

    // REFERENCES SECTION
    if (resume.value.references.isNotEmpty) {
      drawSectionHeader(graphics, 'REFERENCES', sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, sectionHeaderFont, accentColor, useDarkTheme);
      yPos += 30;

      // Display references in a horizontal layout if there are 2
      if (resume.value.references.length == 2) {
        final double refWidth = (mainContentWidth - 2 * contentMargin) / 2 - 10;

        // First reference (left)
        drawReference(graphics, resume.value.references[0], sidebarWidth + contentMargin, yPos, refWidth, boldFont, normalFont, primaryColor);

        // Second reference (right)
        drawReference(graphics, resume.value.references[1], sidebarWidth + contentMargin + refWidth + 20, yPos, refWidth, boldFont, normalFont, primaryColor);
      } else {
        // Display references vertically
        for (var ref in resume.value.references) {
          drawReference(graphics, ref, sidebarWidth + contentMargin, yPos, mainContentWidth - 2 * contentMargin, boldFont, normalFont, primaryColor);
          yPos += 70;
        }
      }
    }

    // Footer with page number if desired
    graphics.drawString(
        'Page 1',
        smallFont,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: Rect.fromLTWH(0, pageSize.height - 20, pageSize.width, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.center)
    );

    final List<int> bytes = await document.save();
    document.dispose();
    await _savePdfAndOpen(bytes, 'resume.pdf');
  }

// Helper functions for common drawing operations
  void drawSectionHeader(PdfGraphics graphics, String text, double x, double y, double width,
      PdfFont font, PdfColor color, bool useDarkTheme) {
    // Draw section title
    graphics.drawString(
        text,
        font,
        brush: PdfSolidBrush(color),
        bounds: Rect.fromLTWH(x, y, width, 25)
    );

    // Draw horizontal line under section title
    graphics.drawLine(
        PdfPen(PdfColor(220, 220, 220), width: 1),
        Offset(x, y + 25),
        Offset(x + width, y + 25)
    );
  }

  void drawContactItem(PdfGraphics graphics, String icon, String text, double x, double y,
      double width, PdfFont font, PdfColor color) {
    // Draw icon placeholder
    graphics.drawString(
        icon,
        font,
        brush: PdfSolidBrush(color),
        bounds: Rect.fromLTWH(x, y, 15, 20)
    );

    // Draw text with offset for icon
    graphics.drawString(
        text,
        font,
        brush: PdfSolidBrush(color),
        bounds: Rect.fromLTWH(x + 20, y, width - 20, 20)
    );
  }

  void drawReference(PdfGraphics graphics, Reference ref, double x, double y, double width,
      PdfFont nameFont, PdfFont detailsFont, PdfColor textColor) {
    // Reference name
    graphics.drawString(
        ref.name,
        nameFont,
        brush: PdfSolidBrush(textColor),
        bounds: Rect.fromLTWH(x, y, width, 20)
    );
    y += 15;

    // Position
    graphics.drawString(
        ref.position,
        detailsFont,
        brush: PdfSolidBrush(textColor),
        bounds: Rect.fromLTWH(x, y, width, 20)
    );
    y += 15;

    // Phone
    graphics.drawString(
        'Phone: ${ref.phone}',
        detailsFont,
        brush: PdfSolidBrush(textColor),
        bounds: Rect.fromLTWH(x, y, width, 20)
    );
    y += 15;

    // Email
    graphics.drawString(
        'Email: ${ref.email}',
        detailsFont,
        brush: PdfSolidBrush(textColor),
        bounds: Rect.fromLTWH(x, y, width, 20)
    );
  }

// Helper function to calculate text height based on width constraints
  double calculateTextHeight(String text, PdfFont font, double width) {
    // Rough estimate - in a real implementation, you'd do more precise calculations
    final int charPerLine = (width / (font.size * 0.6)).floor();
    final int lines = (text.length / charPerLine).ceil();
    return lines * (font.size * 1.5);
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