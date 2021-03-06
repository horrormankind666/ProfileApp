USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertecpTabProgram]    Script Date: 26/1/2559 12:25:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<Insert ecpTabProgram>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetInsertecpTabProgram]
	 @programCode varchar(5)
	,@majorCode varchar(4)
	,@groupNum varchar(1)
	,@facultyId varchar(5)
	,@dLevel varchar(1)

AS
BEGIN

  INSERT INTO ecpTabProgram (
       [ProgramCode]
      ,[MajorCode]
      ,[GroupNum]
      ,[FacultyCode]
      ,[facultyId]
      ,[programId]
      ,[Dlevel])
    SELECT	cp.ProgramCode, cp.MajorCode, cp.GroupNum,bf.facultyCode,@facultyId,cp.id,cp.DLevel	
				    FROM	acaProgram AS cp 
						    INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id
							where cp.facultyid = @facultyId and cp.dLevel = @dLevel
							and cp.programCode = @programCode and cp.majorCode=@majorCode and cp.groupNum =@groupNum
END
