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

    // Colors
    final PdfColor darkColor = PdfColor(33, 33, 33); // Dark gray
    final PdfColor lightGrayColor = PdfColor(240, 240, 240); // Light gray for sidebar
    final PdfColor blueColor = PdfColor(33, 150, 243); // Blue for headers
    final PdfColor whiteColor = PdfColor(255, 255, 255);

    // Fonts
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
    final PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    // Two-column layout
    const double sidebarWidth = 180;
    const double mainContentWidth = 360;
    const double margin = 30;

    // Sidebar (Left Column)
    graphics.drawRectangle(brush: PdfSolidBrush(lightGrayColor), bounds: Rect.fromLTWH(0, 0, sidebarWidth, pageSize.height));

    // Main Content (Right Column)
    double yPos = 20;

    // Header (Name and Job Title)
    graphics.drawString(resume.value.fullName.toUpperCase(), headerFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 30));
    yPos += 30;
    graphics.drawString(resume.value.jobTitle, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
    yPos += 30;

    // Sidebar Content
    double sidebarYPos = 20;

    // Contact Section (Sidebar)
    graphics.drawString('CONTACT', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 25;
    graphics.drawString('Phone: ${resume.value.phone}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 20;
    graphics.drawString('Email: ${resume.value.email}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 20;
    graphics.drawString('Address: ${resume.value.address}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 20;
    if (resume.value.website.isNotEmpty) {
      graphics.drawString('Website: ${resume.value.website}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 30;
    } else {
      sidebarYPos += 10;
    }

    // Education Section (Sidebar)
    graphics.drawString('EDUCATION', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 25;
    for (var edu in resume.value.education) {
      graphics.drawString(edu.period, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 15;
      graphics.drawString(edu.institution, boldFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 15;
      graphics.drawString(edu.degree, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 15;
      if (edu.gpa.isNotEmpty) {
        graphics.drawString('GPA: ${edu.gpa}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
        sidebarYPos += 20;
      }
      sidebarYPos += 10;
    }

    // Skills Section (Sidebar)
    graphics.drawString('SKILLS', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 25;
    for (var skill in resume.value.skills) {
      graphics.drawString('• $skill', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 15;
    }
    sidebarYPos += 10;

    // Languages Section (Sidebar)
    graphics.drawString('LANGUAGES', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
    sidebarYPos += 25;
    for (var lang in resume.value.languages) {
      graphics.drawString('• ${lang.name}: ${lang.proficiency}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(margin, sidebarYPos, sidebarWidth - 2 * margin, 20));
      sidebarYPos += 15;
    }

    // Main Content (Right Column)
    // Profile Summary
    graphics.drawString('PROFILE SUMMARY', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
    yPos += 25;
    graphics.drawString(resume.value.profileSummary, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 40));
    yPos += 50;

    // Work Experience
    graphics.drawString('WORK EXPERIENCE', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
    yPos += 25;
    for (var exp in resume.value.workExperience) {
      graphics.drawString(exp.company, boldFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 15;
      graphics.drawString('${exp.position} (${exp.period})', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 20;
      for (var responsibility in exp.responsibilities) {
        graphics.drawString('• $responsibility', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
        yPos += 15;
      }
      yPos += 10;
    }

    // References
    graphics.drawString('REFERENCES', subHeaderFont, brush: PdfSolidBrush(blueColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
    yPos += 25;
    for (var ref in resume.value.references) {
      graphics.drawString(ref.name, boldFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 15;
      graphics.drawString(ref.position, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 15;
      graphics.drawString('Phone: ${ref.phone}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 15;
      graphics.drawString('Email: ${ref.email}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(sidebarWidth + margin, yPos, mainContentWidth, 20));
      yPos += 20;
    }

    final List<int> bytes = await document.save();
    document.dispose();
    await _savePdfAndOpen(bytes, 'resume.pdf');
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