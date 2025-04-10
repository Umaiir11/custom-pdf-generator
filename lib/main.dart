import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'model.dart';

void main() {
  Get.put(ResumeController()); // Initialize the controller
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildSectionFields(dynamic item, ResumeController controller, String type) {
    if (type == 'education') {
      Education edu = item as Education;
      return Column(
        children: [
          _buildTextField('Degree', (value) {
            final index = controller.educationList.indexOf(edu);
            controller.educationList[index] = Education(
              degree: value,
              institution: edu.institution,
              year: edu.year,
              details: edu.details,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Degree' : null),
          _buildTextField('Institution', (value) {
            final index = controller.educationList.indexOf(edu);
            controller.educationList[index] = Education(
              degree: edu.degree,
              institution: value,
              year: edu.year,
              details: edu.details,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Institution' : null),
          _buildTextField('Year', (value) {
            final index = controller.educationList.indexOf(edu);
            controller.educationList[index] = Education(
              degree: edu.degree,
              institution: edu.institution,
              year: value,
              details: edu.details,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Year' : null),
          _buildTextField('Details (e.g., GPA)', (value) {
            final index = controller.educationList.indexOf(edu);
            controller.educationList[index] = Education(
              degree: edu.degree,
              institution: edu.institution,
              year: edu.year,
              details: value,
            );
            controller.updateResume();
          }),
          const SizedBox(height: 10),
        ],
      );
    } else if (type == 'certification') {
      Certification cert = item as Certification;
      return Column(
        children: [
          _buildTextField('Certification Name', (value) {
            final index = controller.certificationsList.indexOf(cert);
            controller.certificationsList[index] = Certification(
              name: value,
              issuer: cert.issuer,
              year: cert.year,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Certification Name' : null),
          _buildTextField('Issuer', (value) {
            final index = controller.certificationsList.indexOf(cert);
            controller.certificationsList[index] = Certification(
              name: cert.name,
              issuer: value,
              year: cert.year,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Issuer' : null),
          _buildTextField('Year', (value) {
            final index = controller.certificationsList.indexOf(cert);
            controller.certificationsList[index] = Certification(
              name: cert.name,
              issuer: cert.issuer,
              year: value,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Year' : null),
          const SizedBox(height: 10),
        ],
      );
    } else if (type == 'project') {
      Project proj = item as Project;
      return Column(
        children: [
          _buildTextField('Project Title', (value) {
            final index = controller.projectsList.indexOf(proj);
            controller.projectsList[index] = Project(
              title: value,
              description: proj.description,
              technologies: proj.technologies,
              duration: proj.duration,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Project Title' : null),
          _buildTextField('Description', (value) {
            final index = controller.projectsList.indexOf(proj);
            controller.projectsList[index] = Project(
              title: proj.title,
              description: value,
              technologies: proj.technologies,
              duration: proj.duration,
            );
            controller.updateResume();
          }, maxLines: 3, validator: (value) => value!.isEmpty ? 'Please enter Description' : null),
          _buildTextField('Technologies', (value) {
            final index = controller.projectsList.indexOf(proj);
            controller.projectsList[index] = Project(
              title: proj.title,
              description: proj.description,
              technologies: value,
              duration: proj.duration,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Technologies' : null),
          _buildTextField('Duration', (value) {
            final index = controller.projectsList.indexOf(proj);
            controller.projectsList[index] = Project(
              title: proj.title,
              description: proj.description,
              technologies: proj.technologies,
              duration: value,
            );
            controller.updateResume();
          }, validator: (value) => value!.isEmpty ? 'Please enter Duration' : null),
          const SizedBox(height: 10),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final ResumeController controller = Get.find();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade400],
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
                  const Text(
                    'Create Your Resume',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Full Name', (value) => controller.updateResume(fullName: value), validator: (value) => value!.isEmpty ? 'Please enter Full Name' : null),
                  _buildTextField('Email', (value) => controller.updateResume(email: value), keyboardType: TextInputType.emailAddress, validator: (value) => value!.isEmpty ? 'Please enter Email' : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? 'Please enter a valid email' : null),
                  _buildTextField('Phone', (value) => controller.updateResume(phone: value), keyboardType: TextInputType.phone, validator: (value) => value!.isEmpty ? 'Please enter Phone' : null),
                  _buildTextField('Address', (value) => controller.updateResume(address: value), validator: (value) => value!.isEmpty ? 'Please enter Address' : null),
                  _buildTextField('Professional Summary', (value) => controller.updateResume(summary: value), maxLines: 3, validator: (value) => value!.isEmpty ? 'Please enter Summary' : null),
                  _buildTextField('LinkedIn (optional)', (value) => controller.updateResume(linkedin: value)),
                  _buildTextField('GitHub (optional)', (value) => controller.updateResume(github: value)),

                  const SizedBox(height: 20),
                  const Text('Education', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  Obx(() => Column(
                    children: controller.educationList.map((edu) => _buildSectionFields(edu, controller, 'education')).toList(),
                  )),
                  TextButton.icon(
                    onPressed: () => controller.addEducation('', '', '', ''),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Education', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20),
                  const Text('Certifications', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  Obx(() => Column(
                    children: controller.certificationsList.map((cert) => _buildSectionFields(cert, controller, 'certification')).toList(),
                  )),
                  TextButton.icon(
                    onPressed: () => controller.addCertification('', '', ''),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Certification', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20),
                  const Text('Skills', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  Obx(() => Column(
                    children: controller.skillsList.map((skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Skill', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20),
                  const Text('Projects', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  Obx(() => Column(
                    children: controller.projectsList.map((proj) => _buildSectionFields(proj, controller, 'project')).toList(),
                  )),
                  TextButton.icon(
                    onPressed: () => controller.addProject('', '', '', ''),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Project', style: TextStyle(color: Colors.white)),
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
                        foregroundColor: Colors.indigo.shade800,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 8,
                        shadowColor: Colors.black38,
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