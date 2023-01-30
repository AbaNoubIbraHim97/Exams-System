/*
/*Start Region*/
/*Some Of Simple Queries to To test tables*/ 
select QText,Answer from QuestionPool , TextQuestion where QuestionPool.ID=TextQuestion.QuestionPoolID;
select QText,Answer from QuestionPool , TFQuestion where QuestionPool.ID=TFQuestion.QuestionPoolID;
insert into TFQuestion values(4,'false',10);
select QText,Choise,CorrectAnswer from[dbo].[QuestionPool],[dbo].[MultiChoicesQuestion],[dbo].[Choices]
where QuestionPool.ID=MultiChoicesQuestion.QuestionPoolID 
AND MultiChoicesQuestion.ID=Choices.MultiChoicesQuestionID;
INSERT INTO Exam (ID,EType,StartTime,EndTime,AllowenceOptions)
VALUES (1,'Midterm','10:30:30','12:30:30','True');
INSERT INTO Exam (ID,EType,StartTime,EndTime,AllowenceOptions)
VALUES (2,'Midterm','10:30:30','12:30:30','False');
INSERT INTO Exam (ID,EType,StartTime,EndTime,AllowenceOptions)
VALUES (3,'Final','09:00:00','12:00:00','True');
INSERT INTO Exam (ID,EType,StartTime,EndTime,AllowenceOptions)
VALUES (4,'Final','12:00:00','03:00:00','True');
INSERT INTO Exam (ID,EType,StartTime,EndTime,AllowenceOptions)
VALUES (5,'Quiz','12:00:00','12:30:00','True');
/*End Region*/
*/



/*Show All Students who do an exam an each TF Question in this exam and its model answer and its mark and student answer on it and student mark for each Question*/
alter view ShowTFQwithStudentAnswer
as(
select Distinct Student.Name , Exam.EType , QuestionPool.QText ,
TFQuestion.Answer AS 'ModelAnswer' ,StudentTFQuestion.Answer AS 'Student Answer' , 
ExamQuetionPool.Mark,CASE WHEN TFQuestion.Answer = StudentTFQuestion.Answer 
    THEN ExamQuetionPool.Mark
    ELSE '0' 
  END 
  AS MyDesiredResult
from Student , Exam , QuestionPool , StudentTFQuestion ,
StudentExamQuetions , TFQuestion , ExamQuetionPool
where
Exam.ID=1 AND
TFQuestion.QuestionPoolID=StudentExamQuetions.QuestionPoolID AND
TFQuestion.QuestionPoolID = QuestionPool.ID AND
StudentTFQuestion.ExamID= Exam.ID AND
StudentTFQuestion.StudentID = Student.ID AND
QuestionPool.ID=TFQuestion.QuestionPoolID AND
Student.ID = StudentExamQuetions.StudentID AND
Exam.ID=StudentExamQuetions.ExamID AND
Exam.ID = ExamQuetionPool.ExamID AND
QuestionPool.ID=ExamQuetionPool.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID AND
StudentExamQuetions.QuestionPoolID = StudentTFQuestion.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID
);
select * from ShowTFQwithStudentAnswer



/*Show All Students who do an exam an each Text Question in this exam and its model answer and its mark and student answer on it and student mark for each Question*/
create view ShowTQwithStudentAnswer
as(
select Distinct Student.Name , Exam.EType , QuestionPool.QText ,
TextQuestion.Answer AS 'ModelAnswer' ,StudentTextQuestion.Answer AS 'Student Answer' , 
ExamQuetionPool.Mark,CASE WHEN TextQuestion.Answer = StudentTextQuestion.Answer 
    THEN ExamQuetionPool.Mark
    ELSE '0' 
  END 
  AS MyDesiredResult
from Student , Exam , QuestionPool , StudentTextQuestion ,
StudentExamQuetions , TextQuestion , ExamQuetionPool
where
Exam.ID=1 AND
TextQuestion.QuestionPoolID=StudentExamQuetions.QuestionPoolID AND
TextQuestion.QuestionPoolID = QuestionPool.ID AND
StudentTextQuestion.ExamID= Exam.ID AND
StudentTextQuestion.StudentID = Student.ID AND
QuestionPool.ID=TextQuestion.QuestionPoolID AND
Student.ID = StudentExamQuetions.StudentID AND
Exam.ID=StudentExamQuetions.ExamID AND
Exam.ID = ExamQuetionPool.ExamID AND
QuestionPool.ID=ExamQuetionPool.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID AND
StudentExamQuetions.QuestionPoolID = StudentTextQuestion.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID
);
select * from ShowTQwithStudentAnswer


/*Show Total Marks of Student in Text Question in Exam*/
alter proc ShowTotalMarksofStudentinTQinExam(@StudentID int , @TotalMarks int output)
As
Begin
set @TotalMarks = (
select Sum(ExamQuetionPool.Mark)
from Student , Exam , QuestionPool , StudentTextQuestion ,
StudentExamQuetions , TextQuestion , ExamQuetionPool
where
Student.ID=@StudentID AND
TextQuestion.QuestionPoolID=StudentExamQuetions.QuestionPoolID AND
TextQuestion.QuestionPoolID = QuestionPool.ID AND
StudentTextQuestion.ExamID= Exam.ID AND
StudentTextQuestion.StudentID = Student.ID AND
QuestionPool.ID=TextQuestion.QuestionPoolID AND
Student.ID = StudentExamQuetions.StudentID AND
Exam.ID=StudentExamQuetions.ExamID AND
Exam.ID = ExamQuetionPool.ExamID AND
QuestionPool.ID=ExamQuetionPool.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID AND
StudentExamQuetions.QuestionPoolID = StudentTextQuestion.QuestionPoolID AND
QuestionPool.ID = StudentExamQuetions.QuestionPoolID
)
END
go
declare @TMarks int
declare @SID int
Set @SID=2
exec ShowTotalMarksofStudentinTQinExam @SID, @TMarks output
Select str(@TMarks) + '   Total marks in TextQ int theexam for this student'




/*Return Student Degree of Specific Question*/
Create proc Degree(@ExamID int , @StudentID int , @QuestionPoolID int, @TotalMarks int output)
As
Begin
declare @StudentAnswer varchar(255)
declare @ModelAnswer varchar(255)

if @QuestionPoolID=11 or @QuestionPoolID=12
begin
set @StudentAnswer = (
select distinct Answer from StudentTFQuestion where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
)
set @ModelAnswer = (
select distinct Answer from TFQuestion where TFQuestion.QuestionPoolID=@QuestionPoolID
)
end

else if @QuestionPoolID=1 or @QuestionPoolID=4 or @QuestionPoolID=5
begin
set @StudentAnswer = (
select distinct Answer from StudentTextQuestion where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
)
set @ModelAnswer = (
select distinct Answer from TextQuestion where TextQuestion.QuestionPoolID=@QuestionPoolID
)
end
if @StudentAnswer=@ModelAnswer
begin 
set @TotalMarks=5
if @QuestionPoolID=11 or @QuestionPoolID=12
begin
Update StudentTFQuestion set Sumtion=@TotalMarks where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
end
else if @QuestionPoolID=1 or @QuestionPoolID=4 or @QuestionPoolID=5
begin
Update StudentTextQuestion set Sumtion=@TotalMarks where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
end
end
else 
begin
set @TotalMarks=0
if @QuestionPoolID=11 or @QuestionPoolID=12
begin
Update StudentTFQuestion set Sumtion=@TotalMarks where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
end
else if @QuestionPoolID=1 or @QuestionPoolID=4 or @QuestionPoolID=5
begin
Update StudentTextQuestion set Sumtion=@TotalMarks where ExamID=@ExamID and StudentID=@StudentID AND QuestionPoolID=@QuestionPoolID
end
end
END
go
/*Test Procedure */
declare @ExamID int 
Declare @StudentID int
Declare @QuestionPoolID int
declare @TMarks int
Set @ExamID=1;
set @StudentID=5;
set @QuestionPoolID=12;
exec Degree @ExamID, @StudentID , @QuestionPoolID, @TMarks output
Select str(@TMarks)



/* Exam Result at specific student and Exam total mark */
alter proc Result(@ExamID int , @StudentID int , @Result int output , @TotalMarksOfExam int output)
As
Begin
declare @TFAnswerDegree int
declare @TextAnswerDegree int
set @TFAnswerDegree = (select  sum(Sumtion) from StudentTFQuestion where ExamID=@ExamID and StudentID=@StudentID )
set @TextAnswerDegree = (select  sum(Sumtion) from StudentTextQuestion where ExamID=@ExamID and StudentID=@StudentID )
set @Result=@TFAnswerDegree+@TextAnswerDegree
update ExamStudent set Result = @Result where ExamID=@ExamID AND StudentID=@StudentID;
set @TotalMarksOfExam=(select Sum(ExamQuetionPool.Mark) from ExamQuetionPool where ExamID=@ExamID)
END
go
declare @ExamID int 
Declare @StudentID int
declare @Result int
declare @TotalMarksOfExam int
Set @ExamID=1;
set @StudentID=1;
exec Result @ExamID, @StudentID , @Result output , @TotalMarksOfExam output
Select str(@Result) As 'Student Result in Exam' , str(@TotalMarksOfExam) AS 'Total Marks Of Exam'



/*Add True False Questions by Insructor to the course which he teach it*/
create proc AddTrueorFalseQuestion (@AccountID int,@CourseCode varchar(3),@QText varchar(255),@QuestionID int , @Answer nvarchar(50),@TFQuestionID int)
  as 
   begin
   
     if exists ( select Name from Instructor where AccountID=@AccountID)
	 begin
	Declare @InstructorID int 
	
	 set @InstructorID=(select ID from Instructor where AccountID=@AccountID)
		 if exists (select CourseCode from Course where CourseCode=@CourseCode and InstructorID= @InstructorID)
			  begin
			  insert into QuestionPool values (@QuestionID,@QText,@CourseCode);
			  insert into TFQuestion values (@TFQuestionID,@Answer,@QuestionID)
			  end 
		else 
			  begin
			  print 'You Do Not Have a Permission to Add a Question To This Course'
			  end
		end
		else
			begin
			print 'You Do not hava Account'
			end
		end
		Go
declare @AccountID int 
Declare @CourseCode varchar(3)
declare @Qtext varchar(255)
declare @QuestionID int
declare @Answer varchar(50)
declare @TFQuestionID int
set @AccountID=2
set @CourseCode='MVC'
set @Qtext='What is MVC TESTTTTT'
set @QuestionID=31
set @Answer='True'
set @TFQuestionID=10
exec AddTrueorFalseQuestion @AccountID, @CourseCode , @Qtext , @QuestionID , @Answer , @TFQuestionID


/*Add Text Questions by Insructor to the course which he teach it*/
create proc AddTextQuestion (@AccountID int,@CourseCode varchar(3),@QText varchar(255),@QuestionID int , @Answer nvarchar(255),@TextQuestionID int)
  as 
   begin
   
     if exists ( select Name from Instructor where AccountID=@AccountID)
	 begin
	Declare @InstructorID int 
	
	 set @InstructorID=(select ID from Instructor where AccountID=@AccountID)
		 if exists (select CourseCode from Course where CourseCode=@CourseCode and InstructorID= @InstructorID)
			  begin
			  insert into QuestionPool values (@QuestionID,@QText,@CourseCode);
			  insert into TextQuestion values (@TextQuestionID,@Answer,@QuestionID)
			  end 
		else 
			  begin
			  print 'You Do Not Have a Permission to Add a Question To This Course'
			  end
		end
		else
			begin
			print 'You Do not hava Account'
			end
		end
		Go
declare @AccountID int 
Declare @CourseCode varchar(3)
declare @Qtext varchar(255)
declare @QuestionID int
declare @Answer varchar(255)
declare @TextQuestionID int
set @AccountID=2
set @CourseCode='MVC'
set @Qtext='What is MVC text Question texst'
set @QuestionID=32
set @Answer='AnswerQ13'
set @TextQuestionID=13  
exec AddTextQuestion @AccountID, @CourseCode , @Qtext , @QuestionID , @Answer , @TextQuestionID;


/*show all courses that teach by an insructor by insert isnstructor id*/
alter proc CourseNameWhichInsructorTeachIt(@InstructorID int)
AS
begin
select Name As 'Courses which teach by this instructor' from Course where InstructorID=@InstructorID
end
Go
declare @InstructorID int
set @InstructorID=1;
exec CourseNameWhichInsructorTeachIt @InstructorID;


/*Show All Students Who Do This Exam*/
create proc ShowAllStudentsWhoDoThisExam (@ExamID int)
AS
Begin
select Name from Student,ExamStudent where ID=ExamStudent.StudentID AND ExamStudent.ExamID=@ExamID;
End
GO
Declare @ExamID int
set @ExamID=2;
exec ShowAllStudentsWhoDoThisExam @ExamID;

/* show ExamType(Name) and its questions and mark of each question by ExamID*/
create proc ShowExamTypeanditsquestionsbyExamID(@ExamID int)
AS
Begin
select Exam.EType,QuestionPool.QText,ExamQuetionPool.Mark
from Exam,QuestionPool,ExamQuetionPool
where Exam.ID=ExamQuetionPool.ExamID and QuestionPool.ID=ExamQuetionPool.QuestionPoolID;
End
GO
Declare @ExamID int
set @ExamID=2;
exec ShowExamTypeanditsquestionsbyExamID @ExamID;

/*Show ExamType(Name) and instructor name who put this Exam in an Branch by BranchID*/
create proc ShowExamTypeAndInstructorNameWhoPutThisExamInAnBranchByBranchID(@BrachID int)
AS 
Begin
select Exam.EType , Instructor.Name , Branch.Location
from [dbo].[InstructorExamBranchIntakeTrack],[dbo].[Exam],[dbo].[Branch],[dbo].[Instructor]
where InstructorExamBranchIntakeTrack.ExamID = Exam.ID AND
InstructorExamBranchIntakeTrack.InstructorID = Instructor.ID AND
InstructorExamBranchIntakeTrack.BranchID = Branch.ID AND
Branch.ID=@BrachID;
END
GO
Declare @BranchID int
set @BranchID=2;
exec ShowExamTypeAndInstructorNameWhoPutThisExamInAnBranchByBranchID @BranchID;

/*Show All Student Names Who Enroll in Each Course by Course Code*/
alter proc ShowAllStudentNamesWhoEnrollInEachCourseByCourseCode(@courseCode varchar(3))
AS
Begin
select Student.Name , Course.Name from Student,Course,StudentCourse where ID=StudentCourse.StudentID 
AND StudentCourse.CourseCode=@courseCode And Course.CourseCode=@courseCode;
End
GO
Declare @CourseCode varchar(3)
set @CourseCode='MVC';
exec ShowAllStudentNamesWhoEnrollInEachCourseByCourseCode @CourseCode;
