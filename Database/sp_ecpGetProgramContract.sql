USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetProgramContract]    Script Date: 18/1/2559 12:10:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๘/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลหลักสูตรที่ให้มีการทำสัญญาการศึกษา>
--  1. program	เป็น VARCHAR	รับค่ารหัสหลักสูตร
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetProgramContract]
(
	@program VARCHAR(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @program = LTRIM(RTRIM(@program))		

	SELECT	acaprg.facultyId,
			acafac.facultyCode,
			acafac.nameTh AS facultyNameTH,
			acafac.nameEn AS facultyNameEN,
			ecppgc.acaProgramId,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.nameTh AS programNameTH,
			acaprg.nameEn AS programNameEN,
			acaprg.dLevel AS degreeLevel,
			ecppgc.cancelledStatus
	FROM	Infinity..ecpProgramContract AS ecppgc INNER JOIN
			Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
			Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
			Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id
	WHERE	(acaprg.cancelStatus IS NULL) AND
			(ecppgc.acaProgramId = @program)
END