USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListFacultyAccess]    Script Date: 18/1/2559 12:24:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลคณะที่ให้มีการทำสัญญาการศึกษาตามสิทธิ์ผู้ใช้งาน>
--	1. username		เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. systemGroup	เป็น VARCHAR	รับค่าชื่อระบบงาน
--	3. faculty		เป็น VARCHAR	รับค่ารหัสคณะ
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListFacultyAccess]
(
	@username VARCHAR(100) = NULL,
	@systemGroup VARCHAR(50) = NULL,
	@faculty VARCHAR(15) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 DISTINCT
			 autfac.facultyId,
			 autfac.facultyCode,
			 autfac.nameTh AS facultyNameTH,
			 autfac.nameEn AS facultyNameEN,
			 autfac.abbrevTh AS facultyAbbrevTH,
			 autfac.abbrevEn AS facultyAbbrevEN	
	FROM	 Infinity..fnc_autGetListFacultyAccess(@username, @systemGroup) AS autfac INNER JOIN
			 Infinity..acaFaculty AS acafac ON autfac.facultyId = acafac.id LEFT JOIN
			 Infinity..acaProgram AS acaprg ON acafac.id = acaprg.facultyId INNER JOIN
			 Infinity..ecpProgramContract AS ecppgc ON ecppgc.acaProgramId = acaprg.id
	WHERE	 (autfac.facultyId <> 'MU-01') AND
			 (ecppgc.cancelledStatus = 'N') AND
			 (
				(1 = (CASE WHEN (@faculty IS NOT NULL AND LEN(@faculty) > 0 AND @faculty <> 'MU-01') THEN 0 ELSE 1 END)) OR					 
				(autfac.facultyId = @faculty)
			 )
	ORDER BY autfac.facultyId
END