USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetProgramScholarships]    Script Date: 18/1/2559 13:25:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลทุนการศึกษาแต่ละหลักสูตร>
--  1. program	เป็น VARCHAR	รับค่ารหัสหลักสูตร
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetProgramScholarships]
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
			ecppgs.ecpProgramContractId,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.nameTh AS programNameTH,
			acaprg.nameEn AS programNameEN,
			acaprg.dLevel AS degreeLevel,
			stddlv.thDegreeLevelName AS degreeLevelNameTH,
			stddlv.enDegreeLevelName AS degreeLevelNameEN,
			ecppgs.amountScholarship,
			ecppgs.cancelledStatus
	FROM	Infinity..ecpProgramScholarships AS ecppgs INNER JOIN
			Infinity..ecpProgramContract AS ecppgc ON ecppgs.ecpProgramContractId = ecppgc.acaProgramId INNER JOIN
			Infinity..acaProgram AS acaprg ON ecppgc.acaProgramId = acaprg.id LEFT JOIN
			Infinity..acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
			Infinity..stdDegreeLevel AS stddlv ON acaprg.dLevel = stddlv.id
	 WHERE	(acaprg.cancelStatus IS NULL) AND
			(ecppgc.cancelledStatus = 'N') AND
			(ecppgs.ecpProgramContractId = @program)
END