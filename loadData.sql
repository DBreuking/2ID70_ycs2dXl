COPY Degrees (DegreeId, Dept, DegreeDescription, TotalECTS) FROM '/mnt/ramdisk/tables/Degrees.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY Students (StudentId, StudentName, Address, BirthyearStudent, Gender) FROM '/mnt/ramdisk/tables/Students.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY StudentRegistrationsToDegrees (StudentRegistrationId, StudentId, DegreeId, RegistrationYear) FROM '/mnt/ramdisk/tables/StudentRegistrationsToDegrees.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY Teachers (TeacherId, TeacherName, Address, BirthyearTeacher, Gender) FROM '/mnt/ramdisk/tables/Teachers.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY Courses (CourseId, CourseName, CourseDescription, DegreeId, ECTS) FROM '/mnt/ramdisk/tables/Courses.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY CourseOffers (CourseOfferId, CourseId, Year, Quartile) FROM '/mnt/ramdisk/tables/CourseOffers.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY TeacherAssignmentsToCourses (CourseOfferId, TeacherId) FROM '/mnt/ramdisk/tables/TeacherAssignmentsToCourses.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY StudentAssistants (CourseOfferId, StudentRegistrationId) FROM '/mnt/ramdisk/tables/StudentAssistants.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

COPY CourseRegistrations (CourseOfferId, StudentRegistrationId, Grade) FROM '/mnt/ramdisk/tables/CourseRegistrations.table' DELIMITER ',' CSV HEADER  NULL AS 'null';

ALTER TABLE Degrees ADD PRIMARY KEY (DegreeId);
ALTER TABLE Students ADD PRIMARY KEY (StudentId);
ALTER TABLE StudentRegistrationsToDegrees ADD PRIMARY KEY (StudentRegistrationId);
ALTER TABLE Teachers ADD PRIMARY KEY (TeacherId);
ALTER TABLE Courses ADD PRIMARY KEY (CourseId);
ALTER TABLE CourseOffers ADD PRIMARY KEY (CourseOfferId);

ANALYZE VERBOSE;
