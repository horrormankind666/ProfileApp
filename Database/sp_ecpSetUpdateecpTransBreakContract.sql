USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateecpTransBreakContract]    Script Date: 26/1/2559 12:33:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE ecpTransBreakContract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateecpTransBreakContract]
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
	,@id int
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

UPDATE ecpTransBreakContract SET
	   [StudentID] = @studentCode
      ,[stdId] = @studentId
	  ,[TitleCode] = @titlecode
      ,[TitleEName] = @titlenameeng
      ,[TitleTName] = @titlenametha
      ,[FirstEName] = @firstnameeng
      ,[LastEName] = @lastnameeng
      ,[FirstTName] = @firstnametha
      ,[LastTName] = @lastnametha
      ,[FacultyCode] = @facultyCode
      ,[facultyId] = @facultyId
      ,[FacultyName] = @facultyname
      ,[ProgramCode] = @programcode
      ,[programId] = @programId
      ,[ProgramName] = @programname
      ,[MajorCode] = @majorcode
      ,[GroupNum] = @groupnum
      ,[DLevel] = @dlevel
	  ,[PursuantBook] = @pursuantbook
      ,[Pursuant] = @pursuant
      ,[PursuantBookDate] = @pursuantbookdate
      ,[Location] = @location
      ,[InputDate] = @inputdate
      ,[StateLocation] = @statelocation
      ,[StateLocationDate] = @statelocationdate
      ,[ContractDate] = @contractdate
      ,[ContractDateAgreement] = @contractdateagreement
      ,[Guarantor] = @guarantor
      ,[ScholarFlag] = @scholarflag
      ,[ScholarshipMoney] = @scholarshipmoney
      ,[ScholarshipYear] = @scholarshipyear
      ,[ScholarshipMonth] = @scholarshipmonth
      ,[EducationDate] = @educationdate
      ,[GraduateDate] = @graduatedate
      ,[ContractForceStartDate] = @contractforcedatestart
      ,[ContractForceEndDate] = @contractforcedateend
      ,[CaseGraduate] = @casegraduate
      ,[CivilFlag] = @civilflag
      ,[CalDateCondition] = @caldatecondition
      ,[IndemnitorYear] = @indemnitoryear
      ,[IndemnitorCash] = @indemnitorcash
      ,[StatusEdit] = '1'
	  ,[DateTimeModify] = GETDATE()
	  WHERE ID = @id

END
