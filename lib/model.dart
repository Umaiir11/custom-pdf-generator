class ResumeModel {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String summary;
  final List<Education> education;
  final List<Certification> certifications;
  final List<String> skills;
  final List<Project> projects;
  final String linkedin; // Optional for professional touch
  final String github;   // Optional for developers

  ResumeModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.summary,
    required this.education,
    required this.certifications,
    required this.skills,
    required this.projects,
    required this.linkedin,
    required this.github,
  });
}

class Education {
  final String degree;
  final String institution;
  final String year;
  final String details; // e.g., GPA or honors

  Education({
    required this.degree,
    required this.institution,
    required this.year,
    required this.details,
  });
}

class Certification {
  final String name;
  final String issuer;
  final String year;

  Certification({
    required this.name,
    required this.issuer,
    required this.year,
  });
}

class Project {
  final String title;
  final String description;
  final String technologies;
  final String duration;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.duration,
  });
}