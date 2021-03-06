USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertecpTabScholarship]    Script Date: 26/1/2559 12:30:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<INSERT ecpTabScholarship>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetInsertecpTabScholarship]
	@facultyId varchar(5)
	,@programCode varchar(5)
	,@majorCode varchar(4)
	,@groupNum varchar(1)
	,@scholarshipmoney float
	,@dLevel varchar(1)
AS
BEGIN
DECLARE @facultyCode varchar(2),@programId varchar(15)

SELECT @facultyCode = bf.facultyCode,@programId = cp.id
FROM	acaProgram AS cp 
		INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id
		where cp.facultyid = @facultyId and cp.dLevel = @dLevel
		and cp.programCode = @programCode and cp.majorCode=@majorCode and cp.groupNum =@groupNum

INSERT INTO ecpTabScholarship
      ([facultyId]
      ,[FacultyCode]
      ,[ProgramCode]
      ,[programId]
      ,[MajorCode]
      ,[GroupNum]
      ,[ScholarshipMoney]
      ,[Dlevel])
SELECT @facultyId,@facultyCode,@programCode,@programId,@majorCode,@groupNum,@scholarshipmoney,@dLevel
END
