CREATE MATERIALIZED VIEW passedStudentDegree AS
SELECT studentECTS.studentid, studentECTS.DegreeId
FROM( 
	SELECT Sreg.studentid, Sreg.DegreeId, SUM(Courses.ECTS) AS ECTSsum
	FROM StudentRegistrationsToDegrees AS Sreg
	INNER JOIN CourseRegistrations AS Creg
	ON Creg.StudentRegistrationId = Sreg.StudentRegistrationId AND Creg.grade > 5
	INNER JOIN CourseOffers AS Coff
	ON Coff.CourseOfferId = Creg.CourseOfferId
	INNER JOIN courses
	ON courses.courseid = Coff.courseid
	GROUP BY Sreg.StudentId, Sreg.DegreeId
) AS studentECTS
INNER JOIN Degrees
ON Degrees.degreeId = studentECTS.degreeId
WHERE studentECTS.ECTSsum >= Degrees.TotalECTS;

CREATE INDEX student_idx ON courseRegistrations(studentregistrationid);