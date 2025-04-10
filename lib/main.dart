import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'model.dart';

void main() {
  Get.put(ResumeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Modern Resume Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ResumeInputScreen(),
    );
  }
}

class ResumeInputScreen extends StatelessWidget {
  const ResumeInputScreen({Key? key}) : super(key: key);

  Widget _buildTextField(
      String label,
      Function(String) onChanged, {
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[800]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
        ),
        style: const TextStyle(color: Colors.black87),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildSectionFields(dynamic item, ResumeController controller, String type) {
    if (type == 'education') {
      Education edu = item as Education;
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Period (e.g., 2020-2023)', (value) {
                final index = controller.educationList.indexOf(edu);
                controller.educationList[index] = Education(
                  period: value,
                  institution: edu.institution,
                  degree: edu.degree,
                  gpa: edu.gpa,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Period' : null),
              _buildTextField('Institution', (value) {
                final index = controller.educationList.indexOf(edu);
                controller.educationList[index] = Education(
                  period: edu.period,
                  institution: value,
                  degree: edu.degree,
                  gpa: edu.gpa,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Institution' : null),
              _buildTextField('Degree', (value) {
                final index = controller.educationList.indexOf(edu);
                controller.educationList[index] = Education(
                  period: edu.period,
                  institution: edu.institution,
                  degree: value,
                  gpa: edu.gpa,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Degree' : null),
              _buildTextField('GPA (optional)', (value) {
                final index = controller.educationList.indexOf(edu);
                controller.educationList[index] = Education(
                  period: edu.period,
                  institution: edu.institution,
                  degree: edu.degree,
                  gpa: value,
                );
                controller.updateResume();
              }),
            ],
          ),
        ),
      );
    } else if (type == 'workExperience') {
      WorkExperience exp = item as WorkExperience;
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Period (e.g., 2020-Present)', (value) {
                final index = controller.workExperienceList.indexOf(exp);
                controller.workExperienceList[index] = WorkExperience(
                  period: value,
                  company: exp.company,
                  position: exp.position,
                  responsibilities: exp.responsibilities,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Period' : null),
              _buildTextField('Company', (value) {
                final index = controller.workExperienceList.indexOf(exp);
                controller.workExperienceList[index] = WorkExperience(
                  period: exp.period,
                  company: value,
                  position: exp.position,
                  responsibilities: exp.responsibilities,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Company' : null),
              _buildTextField('Position', (value) {
                final index = controller.workExperienceList.indexOf(exp);
                controller.workExperienceList[index] = WorkExperience(
                  period: exp.period,
                  company: exp.company,
                  position: value,
                  responsibilities: exp.responsibilities,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Position' : null),
              ...List.generate(exp.responsibilities.length, (i) => _buildTextField('Responsibility ${i + 1}', (value) {
                final index = controller.workExperienceList.indexOf(exp);
                exp.responsibilities[i] = value;
                controller.workExperienceList[index] = WorkExperience(
                  period: exp.period,
                  company: exp.company,
                  position: exp.position,
                  responsibilities: exp.responsibilities,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Responsibility' : null)),
              TextButton.icon(
                onPressed: () {
                  final index = controller.workExperienceList.indexOf(exp);
                  exp.responsibilities.add('');
                  controller.workExperienceList[index] = WorkExperience(
                    period: exp.period,
                    company: exp.company,
                    position: exp.position,
                    responsibilities: exp.responsibilities,
                  );
                  controller.updateResume();
                },
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text('Add Responsibility', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      );
    } else if (type == 'language') {
      Language lang = item as Language;
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Language', (value) {
                final index = controller.languagesList.indexOf(lang);
                controller.languagesList[index] = Language(
                  name: value,
                  proficiency: lang.proficiency,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Language' : null),
              _buildTextField('Proficiency (e.g., Fluent)', (value) {
                final index = controller.languagesList.indexOf(lang);
                controller.languagesList[index] = Language(
                  name: lang.name,
                  proficiency: value,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Proficiency' : null),
            ],
          ),
        ),
      );
    } else if (type == 'reference') {
      Reference ref = item as Reference;
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Name', (value) {
                final index = controller.referencesList.indexOf(ref);
                controller.referencesList[index] = Reference(
                  name: value,
                  position: ref.position,
                  phone: ref.phone,
                  email: ref.email,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Name' : null),
              _buildTextField('Position', (value) {
                final index = controller.referencesList.indexOf(ref);
                controller.referencesList[index] = Reference(
                  name: ref.name,
                  position: value,
                  phone: ref.phone,
                  email: ref.email,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Position' : null),
              _buildTextField('Phone', (value) {
                final index = controller.referencesList.indexOf(ref);
                controller.referencesList[index] = Reference(
                  name: ref.name,
                  position: ref.position,
                  phone: value,
                  email: ref.email,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Phone' : null),
              _buildTextField('Email', (value) {
                final index = controller.referencesList.indexOf(ref);
                controller.referencesList[index] = Reference(
                  name: ref.name,
                  position: ref.position,
                  phone: ref.phone,
                  email: value,
                );
                controller.updateResume();
              }, validator: (value) => value!.isEmpty ? 'Please enter Email' : null),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final ResumeController controller = Get.find();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Resume', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          _buildTextField('Full Name', (value) => controller.updateResume(fullName: value), validator: (value) => value!.isEmpty ? 'Please enter Full Name' : null),
                          _buildTextField('Job Title', (value) => controller.updateResume(jobTitle: value), validator: (value) => value!.isEmpty ? 'Please enter Job Title' : null),
                          _buildTextField('Phone', (value) => controller.updateResume(phone: value), keyboardType: TextInputType.phone, validator: (value) => value!.isEmpty ? 'Please enter Phone' : null),
                          _buildTextField('Email', (value) => controller.updateResume(email: value), keyboardType: TextInputType.emailAddress, validator: (value) => value!.isEmpty ? 'Please enter Email' : null),
                          _buildTextField('Address', (value) => controller.updateResume(address: value), validator: (value) => value!.isEmpty ? 'Please enter Address' : null),
                          _buildTextField('Website (optional)', (value) => controller.updateResume(website: value)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Profile Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          _buildTextField('Profile Summary', (value) => controller.updateResume(profileSummary: value), maxLines: 3, validator: (value) => value!.isEmpty ? 'Please enter Profile Summary' : null),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Education', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: controller.educationList.map((edu) => _buildSectionFields(edu, controller, 'education')).toList(),
                          )),
                          TextButton.icon(
                            onPressed: () => controller.addEducation('', '', '', ''),
                            icon: const Icon(Icons.add, color: Colors.blue),
                            label: const Text('Add Education', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Work Experience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: controller.workExperienceList.map((exp) => _buildSectionFields(exp, controller, 'workExperience')).toList(),
                          )),
                          TextButton.icon(
                            onPressed: () => controller.addWorkExperience('', '', '', ['']),
                            icon: const Icon(Icons.add, color: Colors.blue),
                            label: const Text('Add Work Experience', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: controller.skillsList.map((skill) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField('Skill', (value) {
                                      final index = controller.skillsList.indexOf(skill);
                                      controller.skillsList[index] = value;
                                      controller.updateResume();
                                    }, validator: (value) => value!.isEmpty ? 'Please enter Skill' : null),
                                  ),
                                ],
                              ),
                            )).toList(),
                          )),
                          TextButton.icon(
                            onPressed: () => controller.addSkill(''),
                            icon: const Icon(Icons.add, color: Colors.blue),
                            label: const Text('Add Skill', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Languages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: controller.languagesList.map((lang) => _buildSectionFields(lang, controller, 'language')).toList(),
                          )),
                          TextButton.icon(
                            onPressed: () => controller.addLanguage('', ''),
                            icon: const Icon(Icons.add, color: Colors.blue),
                            label: const Text('Add Language', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('References', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: controller.referencesList.map((ref) => _buildSectionFields(ref, controller, 'reference')).toList(),
                          )),
                          TextButton.icon(
                            onPressed: () => controller.addReference('', '', '', ''),
                            icon: const Icon(Icons.add, color: Colors.blue),
                            label: const Text('Add Reference', style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.generatePDF();
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('GENERATE RESUME'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}