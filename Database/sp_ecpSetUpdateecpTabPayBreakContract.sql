USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateecpTabPayBreakContract]    Script Date: 26/1/2559 12:32:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE ecpTabPayBreakContract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateecpTabPayBreakContract]
	@facultyId varchar(5)
	,@programCode varchar(5)
	,@majorCode varchar(4)
	,@groupNum varchar(1)
	,@amountCash float
	,@dLevel varchar(1)
	,@casegraduate int
	,@caldatecondition int
	,@amtindemnitoryear int
	,@id int
AS
BEGIN
DECLARE @facultyCode varchar(2),@programId varchar(15)

SELECT @facultyCode = bf.facultyCode,@programId = cp.id
FROM	acaProgram AS cp 
		INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id
		where cp.facultyid = @facultyId and cp.dLevel = @dLevel
		and cp.programCode = @programCode and cp.majorCode=@majorCode and cp.groupNum =@groupNum

	UPDATE ecpTabPayBreakContract SET
       [facultyId] = @facultyId
      ,[FacultyCode] =@facultyCode
      ,[programId] = @programId
      ,[ProgramCode] = @programCode
      ,[MajorCode] = @majorCode
      ,[GroupNum] = @groupNum
      ,[AmountCash] = @amountCash
      ,[Dlevel] = @dLevel
      ,[CaseGraduate] = @casegraduate
      ,[CalDateCondition] = @caldatecondition
      ,[AmtIndemnitorYear] = @amtindemnitoryear
	WHERE ID = @id
END
