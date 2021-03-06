USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateecpTabProgram]    Script Date: 26/1/2559 12:32:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<Update ecpTabProgram>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateecpTabProgram]
	 @programCode varchar(5)
	,@majorCode varchar(4)
	,@groupNum varchar(1)
	,@facultyId varchar(5)
	,@dLevel varchar(1)
	,@id int 
AS
BEGIN
DECLARE @facultyCode varchar(2),@programId varchar(15)

SELECT @facultyCode = bf.facultyCode,@programId = cp.id
FROM	acaProgram AS cp 
		INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id
		where cp.facultyid = @facultyId and cp.dLevel = @dLevel
		and cp.programCode = @programCode and cp.majorCode=@majorCode and cp.groupNum =@groupNum

UPDATE ecpTabProgram SET
       [ProgramCode] = @programCode
      ,[MajorCode] = @majorCode
      ,[GroupNum] = @groupNum
      ,[FacultyCode] = @facultyCode
      ,[facultyId] = @facultyId
      ,[programId] = @programId
      ,[Dlevel] = @dLevel
	WHERE ID = @id
END
