class ResumeModel {
  final String fullName;
  final String jobTitle;
  final String phone;
  final String email;
  final String address;
  final String website;
  final String profileSummary;
  final List<Education> education;
  final List<WorkExperience> workExperience;
  final List<String> skills;
  final List<Language> languages;
  final List<Reference> references;

  ResumeModel({
    required this.fullName,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.address,
    required this.website,
    required this.profileSummary,
    required this.education,
    required this.workExperience,
    required this.skills,
    required this.languages,
    required this.references,
  });
}

class Education {
  final String period;
  final String institution;
  final String degree;
  final String gpa;

  Education({
    required this.period,
    required this.institution,
    required this.degree,
    required this.gpa,
  });
}

class WorkExperience {
  final String period;
  final String company;
  final String position;
  final List<String> responsibilities;

  WorkExperience({
    required this.period,
    required this.company,
    required this.position,
    required this.responsibilities,
  });
}

class Language {
  final String name;
  final String proficiency;

  Language({
    required this.name,
    required this.proficiency,
  });
}

class Reference {
  final String name;
  final String position;
  final String phone;
  final String email;

  Reference({
    required this.name,
    required this.position,
    required this.phone,
    required this.email,
  });
}