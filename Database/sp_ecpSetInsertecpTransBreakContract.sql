USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertecpTransBreakContract]    Script Date: 26/1/2559 12:31:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<INSERT ecpTransBreakContract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetInsertecpTransBreakContract]
	@studentCode varchar(7)
	,@titlecode varchar(3)
	,@titlenameeng varchar(10)
	,@titlenametha varchar(10)
	,@firstnameeng varchar(50)
	,@lastnameeng varchar(50)
	,@firstnametha varchar(50)
	,@lastnametha varchar(50)
	,@facultyId varchar(5)
	,@programcode varchar(10)
	,@majorcode varchar(10)
	,@groupnum varchar(1)
	,@dlevel varchar(1)
	,@pursuantbook varchar(200)
	,@pursuant varchar(50)
	,@pursuantbookdate varchar(10)
	,@location varchar(50)
	,@inputdate varchar(10)
	,@statelocation varchar(50)
	,@statelocationdate varchar(10)
	,@contractdate varchar(10)
	,@contractdateagreement varchar(10)
	,@guarantor varchar(50)
	,@scholarflag int
	,@scholarshipmoney float
	,@scholarshipyear int
	,@scholarshipmonth int
	,@educationdate varchar(10)
	,@graduatedate varchar(10)
	,@contractforcedatestart varchar(10)
	,@contractforcedateend varchar(10)
	,@casegraduate int
	,@civilflag int
	,@caldatecondition int
	,@indemnitoryear int
	,@indemnitorcash float

AS
BEGIN
DECLARE @facultyCode varchar(2)
       ,@programId varchar(15)
	   ,@facultyname varchar(200)
	   ,@programname varchar(200)
	   ,@studentId varchar(20)


SELECT @facultyCode = bf.facultyCode,@programId = cp.id,@facultyname=bf.nameTh,@programname=cp.nameTh
FROM	acaProgram AS cp 
		INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id
		where cp.facultyid = @facultyId and cp.dLevel = @dLevel
		and cp.programCode = @programCode and cp.majorCode=@majorCode and cp.groupNum =@groupNum

SELECT @studentId= id
FROM stdStudent WHERE studentCode = @studentCode


	INSERT INTO ecpTransBreakContract( 
	   [StudentID]
      ,[stdId]
      ,[TitleCode]
      ,[TitleEName]
      ,[TitleTName]
      ,[FirstEName]
      ,[LastEName]
      ,[FirstTName]
      ,[LastTName]
      ,[FacultyCode]
      ,[facultyId]
      ,[FacultyName]
      ,[ProgramCode]
      ,[programId]
      ,[ProgramName]
      ,[MajorCode]
      ,[GroupNum]
      ,[DLevel]
      ,[PursuantBook]
      ,[Pursuant]
      ,[PursuantBookDate]
      ,[Location]
      ,[InputDate]
      ,[StateLocation]
      ,[StateLocationDate]
      ,[ContractDate]
      ,[ContractDateAgreement]
      ,[Guarantor]
      ,[ScholarFlag]
      ,[ScholarshipMoney]
      ,[ScholarshipYear]
      ,[ScholarshipMonth]
      ,[EducationDate]
      ,[GraduateDate]
      ,[ContractForceStartDate]
      ,[ContractForceEndDate]
      ,[CaseGraduate]
      ,[CivilFlag]
      ,[CalDateCondition]
      ,[IndemnitorYear]
      ,[IndemnitorCash]
      ,[StatusSend]
      ,[StatusReceiver]
      ,[StatusEdit]
      ,[StatusCancel]
      ,[DateTimeCreate]
		)
	SELECT @studentCode
	,@studentId
	,@titlecode
	,@titlenameeng
	,@titlenametha
	,@firstnameeng
	,@lastnameeng
	,@firstnametha
	,@lastnametha
	,@facultyCode
	,@facultyId
	,@facultyname
	,@programcode
	,@programId
	,@programname
	,@majorcode
	,@groupnum
	,@dlevel
	,@pursuantbook
	,@pursuant
	,@pursuantbookdate
	,@location
	,@inputdate
	,@statelocation
	,@statelocationdate
	,@contractdate
	,@contractdateagreement
	,@guarantor 
	,@scholarflag 
	,@scholarshipmoney 
	,@scholarshipyear 
	,@scholarshipmonth 
	,@educationdate 
	,@graduatedate 
	,@contractforcedatestart 
	,@contractforcedateend 
	,@casegraduate 
	,@civilflag 
	,@caldatecondition 
	,@indemnitoryear 
	,@indemnitorcash 
	,'1'
	,'1'
	,'1'
	,'1'
	,GETDATE()
END
