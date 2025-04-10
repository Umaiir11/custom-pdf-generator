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
      email: '',
      phone: '',
      address: '',
      summary: '',
      education: [],
      certifications: [],
      skills: [],
      projects: [],
      linkedin: '',
      github: '',
    ).obs;

    var educationList = <Education>[].obs;
    var certificationsList = <Certification>[].obs;
    var skillsList = <String>[].obs;
    var projectsList = <Project>[].obs;

    void updateResume({
      String? fullName,
      String? email,
      String? phone,
      String? address,
      String? summary,
      String? linkedin,
      String? github,
    }) {
      resume.value = ResumeModel(
        fullName: fullName ?? resume.value.fullName,
        email: email ?? resume.value.email,
        phone: phone ?? resume.value.phone,
        address: address ?? resume.value.address,
        summary: summary ?? resume.value.summary,
        education: educationList.toList(),
        certifications: certificationsList.toList(),
        skills: skillsList.toList(),
        projects: projectsList.toList(),
        linkedin: linkedin ?? resume.value.linkedin,
        github: github ?? resume.value.github,
      );
    }

    void addEducation(String degree, String institution, String year, String details) {
      educationList.add(Education(degree: degree, institution: institution, year: year, details: details));
      updateResume();
    }

    void addCertification(String name, String issuer, String year) {
      certificationsList.add(Certification(name: name, issuer: issuer, year: year));
      updateResume();
    }

    void addSkill(String skill) {
      skillsList.add(skill);
      updateResume();
    }

    void addProject(String title, String description, String technologies, String duration) {
      projectsList.add(Project(title: title, description: description, technologies: technologies, duration: duration));
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
      final PdfColor primaryColor = PdfColor(33, 150, 243); // Blue accent
      final PdfColor darkColor = PdfColor(33, 33, 33); // Dark gray
      final PdfColor lightGrayColor = PdfColor(200, 200, 200);
      final PdfColor whiteColor = PdfColor(255, 255, 255);

      // Fonts
      final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
      final PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
      final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
      final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

      // Header Section
      graphics.drawRectangle(brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(0, 0, pageSize.width, 80));
      graphics.drawString(resume.value.fullName, headerFont, brush: PdfSolidBrush(whiteColor), bounds: Rect.fromLTWH(40, 20, pageSize.width - 80, 40));

      double yPos = 90;
      graphics.drawString('${resume.value.email} | ${resume.value.phone} | ${resume.value.address}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 20;
      if (resume.value.linkedin.isNotEmpty || resume.value.github.isNotEmpty) {
        graphics.drawString('${resume.value.linkedin} | ${resume.value.github}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 30;
      } else {
        yPos += 10;
      }

      // Summary Section
      graphics.drawString('Professional Summary', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 25;
      graphics.drawString(resume.value.summary, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 40));
      yPos += 50;

      // Education Section
      graphics.drawString('Education', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 25;
      for (var edu in resume.value.education) {
        graphics.drawString('${edu.degree}', boldFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 15;
        graphics.drawString('${edu.institution} | ${edu.year}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 15;
        if (edu.details.isNotEmpty) {
          graphics.drawString(edu.details, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
          yPos += 20;
        }
        yPos += 5;
      }

      // Certifications Section
      graphics.drawString('Certifications', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 25;
      for (var cert in resume.value.certifications) {
        graphics.drawString('${cert.name} - ${cert.issuer} (${cert.year})', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 20;
      }

      // Skills Section
      graphics.drawString('Skills', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 25;
      String skillsText = resume.value.skills.join(', ');
      graphics.drawString(skillsText, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 40));
      yPos += 50;

      // Projects Section
      graphics.drawString('Projects', subHeaderFont, brush: PdfSolidBrush(primaryColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
      yPos += 25;
      for (var project in resume.value.projects) {
        graphics.drawString(project.title, boldFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 15;
        graphics.drawString(project.description, normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 40));
        yPos += 45;
        graphics.drawString('Technologies: ${project.technologies} | Duration: ${project.duration}', normalFont, brush: PdfSolidBrush(darkColor), bounds: Rect.fromLTWH(40, yPos, pageSize.width - 80, 20));
        yPos += 25;
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