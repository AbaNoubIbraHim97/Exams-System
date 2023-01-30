/*
Test to Drop Table
IF OBJECT_ID('dbo.BranchIntakeTrack', 'U') IS NOT NULL
DROP TABLE dbo.BranchIntakeTrack;
*/

/* Data Inserted*/
Create table Course(
CourseCode varchar(3) Primary key Not Null,
Name varchar(20),
Description varchar(100),
MinDegree int ,
MaxDegree int
);
/* Data Inserted*/
create table QuestionPool(
ID int Primary key Not Null,
QText varchar(255),
CourseCode varchar(3) FOREIGN KEY REFERENCES Course(CourseCode)
);
/* Data Inserted*/
create table TextQuestion(
ID int Primary key,
Answer varchar(255),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID)
);
/* Data Inserted*/
create table TFQuestion(
ID int Primary key,
Answer nvarchar(50) ,
constraint c check (Answer in ('True','False')),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID)
);
/* Data Inserted*/
create table MultiChoicesQuestion(
ID int Primary key,
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID)
);
/* Data Inserted*/
create table Choices(
ID int Primary key,
Choise varchar(25),
CorrectAnswer nvarchar(50) ,
constraint c2 check (CorrectAnswer in ('True','False')),
MultiChoicesQuestionID int FOREIGN KEY REFERENCES MultiChoicesQuestion(ID)
);

/* Data Inserted*/
create table Exam(
ID int primary key,
EType varchar(25),
StartTime TIME (0) NOT Null,
EndTime time(0) NOT Null, 
TotalTime TIME(0),
AllowenceOptions nvarchar(50) ,
constraint c3 check (AllowenceOptions in ('True','False')),
);
/* Data Inserted*/
create table ExamQuetionPool(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID),
PRIMARY KEY ( ExamID, QuestionPoolID ),
Mark int
);

create table Student(
ID int Primary key,
Name varchar (50),
AccountID int FOREIGN KEY REFERENCES Account(ID), 
BranchID int FOREIGN KEY REFERENCES Branch(ID), 
IntakeNumber int FOREIGN KEY REFERENCES Intake(Number), 
TrackID int FOREIGN KEY REFERENCES Track(ID) 
);
create table ExamStudent(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
StudentID int FOREIGN KEY REFERENCES Student(ID),
PRIMARY KEY ( ExamID, StudentID ),
Result int
);
create table StudentExamQuetions(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
StudentID int FOREIGN KEY REFERENCES Student(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID),
PRIMARY KEY ( ExamID, StudentID,QuestionPoolID ),
);
create table StudentTextQuestion(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
StudentID int FOREIGN KEY REFERENCES Student(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID),
PRIMARY KEY ( ExamID, StudentID,QuestionPoolID ),
Answer varchar(255)
);
create table StudentTFQuestion(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
StudentID int FOREIGN KEY REFERENCES Student(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID),
PRIMARY KEY ( ExamID, StudentID,QuestionPoolID ),
Answer varchar(255)
);
create table StudentChoices(
MultiChoicesQuestionID int FOREIGN KEY REFERENCES MultiChoicesQuestion(ID),
ChoicesID int FOREIGN KEY REFERENCES Choices(ID),
PRIMARY KEY ( MultiChoicesQuestionID, ChoicesID),
Choise varchar(25),
CorrectAnswer nvarchar(50) ,
constraint c4 check (CorrectAnswer in ('True','False'))
);
/* Data Inserted*/
create table Instructor(
ID int primary key, 
Name varchar (50), 
JobTitle varchar(50), 
TrainingMgrID int FOREIGN KEY REFERENCES Instructor(ID), 
AccountID int FOREIGN KEY REFERENCES Account(ID), 
BranchID int FOREIGN KEY REFERENCES Branch(ID)
);
create table StudentInstructorCourse(
InstructorID int FOREIGN KEY REFERENCES Instructor(ID),
StudentID int FOREIGN KEY REFERENCES Student(ID),
CourseCode varchar(3) FOREIGN KEY REFERENCES Course(CourseCode),
PRIMARY KEY ( InstructorID,StudentID,CourseCode),
TheYear int
);

create Table InstructorQuestion(
InstructorID int FOREIGN KEY REFERENCES Instructor(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID),
PRIMARY KEY ( InstructorID,QuestionPoolID),
);
create table InstructorQuestionExam(
InstructorID int FOREIGN KEY REFERENCES Instructor(ID),
QuestionPoolID int FOREIGN KEY REFERENCES QuestionPool(ID), 
ExamID int FOREIGN KEY REFERENCES Exam(ID), 
PRIMARY KEY ( InstructorID,QuestionPoolID,ExamID),
Degree int
);
/* Data Inserted*/
create table Account(
ID int primary key,
Username varchar(50),
Pass varchar(20)
);
/* Data Inserted*/
create table Branch(
ID int primary key,
Name Varchar(50),
Location varchar(50)
);
/* Data Inserted*/
create table Intake(
Number int primary key
);
/* Data Inserted*/
create table Track (
ID int Primary key,
Name varchar(50)
);
/* Data Inserted*/
create table BranchIntakeTrack(
BranchID int FOREIGN KEY REFERENCES Branch(ID), 
IntakeNumber int FOREIGN KEY REFERENCES Intake(Number), 
TrackID int FOREIGN KEY REFERENCES Track(ID),
PRIMARY KEY ( BranchID,IntakeNumber)
);
create table InstructorIntake(
IntakeNumber int FOREIGN KEY REFERENCES Intake(Number),
InstructorID int FOREIGN KEY REFERENCES Instructor(ID),
PRIMARY KEY ( IntakeNumber,InstructorID),
);
create table ExamBranchIntakeTrack(
ExamID int FOREIGN KEY REFERENCES Exam(ID),
BranchID int FOREIGN KEY REFERENCES Branch(ID), 
IntakeNumber int FOREIGN KEY REFERENCES Intake(Number), 
TrackID int FOREIGN KEY REFERENCES Track(ID),
PRIMARY KEY ( ExamID,BranchID,IntakeNumber,TrackID)
);
/* Data Inserted*/
create table InstructorExamBranchIntakeTrack(
InstructorID int FOREIGN KEY REFERENCES Instructor(ID),
ExamID int FOREIGN KEY REFERENCES Exam(ID),
BranchID int FOREIGN KEY REFERENCES Branch(ID), 
IntakeNumber int FOREIGN KEY REFERENCES Intake(Number), 
TrackID int FOREIGN KEY REFERENCES Track(ID),
PRIMARY KEY ( InstructorID,ExamID,BranchID,IntakeNumber,TrackID)
);

/*Data Inserted*/
create table StudentCourse(
StudentID int FOREIGN KEY REFERENCES Student(ID),
CourseCode varchar(3) FOREIGN KEY REFERENCES Course(CourseCode),
PRIMARY KEY (StudentID,CourseCode),
);