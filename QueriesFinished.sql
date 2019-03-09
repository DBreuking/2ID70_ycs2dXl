/*
EX.1 :

%1% = student id
%2% = degree id

(working example, %1% = 2367849 and %2% = 4372
3938603, 7438
944715, 4785
3151795, 7095
303840, 3927
3332597, 2007
790117, 5174
)

roughly 3 secs
*/

SELECT Courses.CourseName, CourseRegistrations.grade
FROM StudentRegistrationsToDegrees
INNER JOIN CourseRegistrations 
ON CourseRegistrations.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId
INNER JOIN CourseOffers
ON CourseOffers.courseofferid = CourseRegistrations.courseofferid
INNER JOIN Courses
ON Courses.courseid = CourseOffers.courseid
WHERE StudentRegistrationsToDegrees.StudentId = %1% AND CourseRegistrations.grade > 5 AND StudentRegistrationsToDegrees.degreeid = %2%

/*
EX.2 :

roughly 0.5 secs
*/

SELECT DISTINCT studentid
FROM (
	SELECT passedStudentDegree.studentid, passedStudentDegree.degreeid, SUM(CASE WHEN courseregistrations.grade < 5 THEN 1 ELSE 0 END) AS failCount, StudentRegistrationsToDegrees.GPA
	FROM StudentRegistrationsToDegrees
	INNER JOIN passedStudentDegree
	ON StudentRegistrationsToDegrees.studentid = passedStudentDegree.studentid AND StudentRegistrationsToDegrees.degreeid = passedStudentDegree.degreeid
	INNER JOIN CourseRegistrations
	ON CourseRegistrations.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId
	WHERE grade IS NOT NULL
	GROUP BY passedStudentDegree.degreeid, passedStudentDegree.studentid, StudentRegistrationsToDegrees.GPA
) AS studentExcellence
WHERE failCount < 1 AND studentExcellence.GPA > %1%
ORDER BY studentid

/*
EX.3 :

roughly 0.5 secs
*/

WITH GenderIDPassed AS ( 
		SELECT Students.Gender, COUNT(Students.Gender) AS genderCount, passedStudentDegree.DegreeId
		FROM passedStudentDegree
		INNER JOIN students
		ON passedStudentDegree.studentid = students.studentid
		GROUP BY students.studentid, passedStudentDegree.DegreeId
	)


SELECT finished.degreeid, finished.percentage
FROM (
	Select GenderIDPassed.degreeid, (GenderIDPassed.genderCount::decimal/FullPassed.fullCount)*100 AS percentage
	FROM GenderIDPassed
	INNER JOIN (
		SELECT SUM(GenderIDPassed.genderCount) AS fullCount, GenderIDPassed.degreeid
		FROM GenderIDPassed
		GROUP BY GenderIDPassed.degreeid
	) AS FullPassed
	ON FullPassed.degreeid = GenderIDPassed.degreeid
	WHERE GenderIDPassed.Gender = 'F'
) AS finished


/*
EX 4:

roughly 0.3 sec
*/

SELECT SUM(CASE When gender='F' Then 1 Else 0 End )/(Count(gender)::float)*100 AS percentage
FROM Students, StudentRegistrationsToDegrees, Degrees
WHERE Degrees.dept = %1% AND Students.StudentId = StudentRegistrationsToDegrees.StudentId AND StudentRegistrationsToDegrees.degreeid = degrees.degreeid;

/*
EX.5 :

%1% = variable passing grade

roughly 25 sec
*/

SELECT courses.courseid, (SUM(CASE WHEN courseregistrations.grade > %1% THEN 1 ELSE 0 END)/COUNT(courses.courseid)::decimal)*100 AS percentagePassing
FROM courses
INNER JOIN courseoffers
ON courseoffers.courseid = courses.courseid
INNER JOIN courseregistrations
ON courseregistrations.courseofferid = courseoffers.courseofferid AND courseregistrations.grade IS NOT NULL
GROUP BY courses.courseid

/*
EX 6:

%1% = (1 2 or 3 (3 should not return anything))

roughly 5 secs
*/

SELECT students.StudentId, COUNT(StudentRegistrationId) AS numberOfCoursesWhereExcellent
FROM Students
INNER JOIN StudentRegistrationsToDegrees
ON Students.StudentId=StudentRegistrationsToDegrees.StudentId
WHERE StudentRegistrationsToDegrees.StudentRegistrationId IN (
	SELECT StudentRegistrationId
	FROM CourseRegistrations 
	INNER JOIN CourseOffers
	ON CourseRegistrations.CourseOfferId=CourseOffers.CourseOfferId
	WHERE CourseOffers.Year=2018 AND CourseOffers.Quartile=1 AND CourseRegistrations.Grade IN (
		SELECT MAX(CourseRegistrations.Grade) AS Grade
		FROM CourseRegistrations
	)
    GROUP BY CourseRegistrations.CourseOfferId, StudentRegistrationId
)
GROUP BY students.StudentId
HAVING COUNT(StudentRegistrationId) >= %1%
/*
EX.7 :

roughly 143 secs
*/

SELECT active.degreeid, students.birthyearstudent AS birthyear, students.gender, AVG(cr.grade) AS avgGrade
FROM (
	SELECT sr.studentid, sr.degreeId, sr.studentregistrationid
	FROM studentregistrationstodegrees AS sr
	WHERE NOT EXISTS (SELECT studentid FROM passedStudentDegree WHERE passedStudentDegree.studentid = sr.studentid AND passedStudentDegree.DegreeId = sr.DegreeId)
) AS active
INNER JOIN students
ON students.studentid = active.studentid
INNER JOIN courseregistrations AS cr
ON cr.studentregistrationid = active.studentregistrationid AND cr.grade IS NOT NULL
GROUP BY CUBE (active.degreeid, students.birthyearstudent, students.gender)
ORDER BY active.degreeid, students.birthyearstudent, students.gender;

/*
EX 8:

roughly 20 secs
*/
SELECT Courses.courseName, CourseOffers.year, CourseOffers.quartile FROM (
	SELECT actualAssistants, (Count(CourseRegistrations.StudentRegistrationId)/50 + (CASE WHEN Count(CourseRegistrations.StudentRegistrationId)%50>0 THEN 1 ELSE 0 END)) AS minAssistants, realAssistants.CourseOfferID
	FROM(
		SELECT COUNT(StudentAssistants.StudentRegistrationId) AS actualAssistants, StudentAssistants.CourseOfferID
		FROM StudentAssistants
		GROUP BY StudentAssistants.CourseOfferID
	) AS realAssistants
	INNER JOIN CourseRegistrations
	ON CourseRegistrations.CourseOfferID = realAssistants.courseOfferID
	GROUP BY realAssistants.courseOfferID, actualAssistants
	ORDER BY realAssistants.CourseOfferID
) AS assistantStats
INNER JOIN CourseOffers
ON CourseOffers.CourseOfferID = assistantStats.CourseOfferID
INNER JOIN Courses
ON Courses.courseId = CourseOffers.courseId
WHERE assistantStats.minAssistants > assistantStats.actualAssistants