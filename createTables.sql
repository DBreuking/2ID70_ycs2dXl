CREATE UNLOGGED TABLE Degrees (
  DegreeId integer ,
  Dept varchar(50),
  DegreeDescription varchar(200),
  TotalECTS integer
);

CREATE UNLOGGED TABLE Students (
  StudentId integer ,
  StudentName varchar(50),
  Address varchar(200),
  BirthyearStudent integer,
  Gender char(1)
);

CREATE UNLOGGED TABLE StudentRegistrationsToDegrees (
  StudentRegistrationId integer ,
  StudentId integer ,
  DegreeId integer ,
  RegistrationYear integer
);

CREATE UNLOGGED TABLE Teachers (
  TeacherId integer ,
  TeacherName varchar(50),
  Address varchar(200),
  BirthyearTeacher integer,
  Gender char(1)
);

CREATE UNLOGGED TABLE Courses (
  CourseId integer ,
  CourseName varchar(50),
  CourseDescription varchar(200),
  DegreeId integer ,
  ECTS integer
);

CREATE UNLOGGED TABLE CourseOffers (
  CourseOfferId integer ,
  CourseId integer ,
  Year integer,
  Quartile integer
);

CREATE UNLOGGED TABLE TeacherAssignmentsToCourses (
  CourseOfferId integer ,
  TeacherId integer 
);


CREATE UNLOGGED TABLE StudentAssistants (
  CourseOfferId integer ,
  StudentRegistrationId integer 
);


CREATE UNLOGGED TABLE CourseRegistrations (
  CourseOfferId integer ,
  StudentRegistrationId integer ,
  Grade integer
);

