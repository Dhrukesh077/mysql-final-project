-- =========================
-- DATABASE
-- =========================
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- =========================
-- 1. STUDENTS TABLE
-- =========================
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

INSERT INTO Students VALUES
(1,'Amit','Sharma','amit@gmail.com','2000-01-15','2022-08-01'),
(2,'Priya','Patel','priya@gmail.com','1999-05-25','2021-08-01'),
(3,'Rahul','Verma','rahul@gmail.com','2001-03-10','2023-07-01'),
(4,'Sneha','Reddy','sneha@gmail.com','2000-12-20','2020-06-15'),
(5,'Karan','Mehta','karan@gmail.com','1998-11-11','2022-09-01'),
(6,'Neha','Kapoor','neha@gmail.com','2002-02-02','2023-01-10'),
(7,'Vikas','Singh','vikas@gmail.com','2001-07-07','2022-03-20'),
(8,'Anjali','Gupta','anjali@gmail.com','2000-04-14','2021-09-05'),
(9,'Rohit','Yadav','rohit@gmail.com','1999-10-30','2022-05-12'),
(10,'Pooja','Nair','pooja@gmail.com','2001-06-18','2023-02-18');

-- =========================
-- 2. DEPARTMENTS TABLE
-- =========================
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Mathematics'),
(3,'Commerce');

-- =========================
-- 3. COURSES TABLE
-- =========================
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Data Structures',1,4),
(103,'Algebra',2,3),
(104,'Statistics',2,4),
(105,'Accounting',3,3);

-- =========================
-- 4. INSTRUCTORS TABLE
-- =========================
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Instructors VALUES
(1,'Arjun','Desai','arjun@univ.com',1,60000),
(2,'Meera','Joshi','meera@univ.com',2,55000),
(3,'Rakesh','Kumar','rakesh@univ.com',1,70000),
(4,'Divya','Shah','divya@univ.com',3,50000);

-- =========================
-- 5. ENROLLMENTS TABLE
-- =========================
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,2,102,'2021-08-01'),
(3,3,101,'2023-07-01'),
(4,4,103,'2020-06-15'),
(5,5,104,'2022-09-01'),
(6,6,105,'2023-01-10'),
(7,7,101,'2022-03-20'),
(8,8,102,'2021-09-05'),
(9,9,103,'2022-05-12'),
(10,10,104,'2023-02-18');

-- =========================
-- QUERIES
-- =========================

-- 1. CRUD (example select)
SELECT * FROM Students;

-- 2. Students enrolled after 2022
SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- 3. Courses from Mathematics department
SELECT * FROM Courses
WHERE DepartmentID = 2
LIMIT 5;

-- 4. Students per course (>5)
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- 5. Students in both SQL & Data Structures
SELECT e1.StudentID
FROM Enrollments e1
JOIN Enrollments e2 
ON e1.StudentID = e2.StudentID
WHERE e1.CourseID = 101 AND e2.CourseID = 102;

-- 6. Students in either course
SELECT DISTINCT StudentID
FROM Enrollments
WHERE CourseID IN (101,102);

-- 7. Average credits
SELECT AVG(Credits) FROM Courses;

-- 8. Max salary in CS department
SELECT MAX(Salary)
FROM Instructors
WHERE DepartmentID = 1;

-- 9. Students per department
SELECT d.DepartmentName, COUNT(e.StudentID)
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

-- 10. INNER JOIN
SELECT s.FirstName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN
SELECT s.FirstName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. Subquery (courses >10 students)
SELECT StudentID
FROM Enrollments
WHERE CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(*) > 10
);

-- 13. Extract year
SELECT StudentID, YEAR(EnrollmentDate) FROM Enrollments;

-- 14. Instructor full name
SELECT CONCAT(FirstName,' ',LastName) FROM Instructors;

-- 15. Total students
SELECT COUNT(*) FROM Students;

-- 16. Label Senior/Junior
SELECT StudentID,
CASE
    WHEN TIMESTAMPDIFF(YEAR, EnrollmentDate, CURDATE()) > 4 THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM Students;