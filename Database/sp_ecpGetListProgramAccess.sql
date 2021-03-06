USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpGetListProgramAccess]    Script Date: 18/1/2559 12:25:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๓/๐๑/๒๕๕๙>
-- Description	: <สำหรับแสดงข้อมูลหลักสูตรที่ให้มีการทำสัญญาการศึกษาตามสิทธิ์ผู้ใช้งาน>
--	1. username		เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. systemGroup	เป็น VARCHAR	รับค่าชื่อระบบงาน
--	3. degreeLevel	เป็น VARCHAR	รับค่าระดับปริญญา
--	4. faculty		เป็น VARCHAR	รับค่ารหัสคณะ
--	5. program		เป็น VARCHAR	รับค่ารหัสหลักสูตร
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpGetListProgramAccess]
(
	@username VARCHAR(100) = NULL,
	@systemGroup VARCHAR(50) = NULL,
	@degreeLevel VARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL
)	
AS
BEGIN
	SET NOCOUNT ON

	SELECT	 autprg.programId,
			 autprg.programCode,
			 autprg.majorCode,
			 autprg.groupNum,			 
			 autprg.nameTh AS programNameTH,
			 autprg.nameEn AS programNameEN,
			 acaprg.dLevel AS degreeLevel,
			 acaprg.studyYear AS programYear	
	FROM	 Infinity..fnc_autGetListProgramAccess(@username, @faculty, @systemGroup) AS autprg INNER JOIN
			 Infinity..acaProgram AS acaprg ON autprg.programId = acaprg.id INNER JOIN
			 Infinity..ecpProgramContract AS ecppgc ON ecppgc.acaProgramId = acaprg.id
	WHERE	 (ecppgc.cancelledStatus = 'N') AND
			 (	
				(1 = (CASE WHEN (@degreeLevel IS NOT NULL AND LEN(@degreeLevel) > 0) THEN 0 ELSE 1 END)) OR					 
				(acaprg.dLevel = @degreeLevel)
			 ) AND
			 (	
				(1 = (CASE WHEN (@program IS NOT NULL AND LEN(@program) > 0) THEN 0 ELSE 1 END)) OR					 
				(ecppgc.acaProgramId = @program)
			 )
	ORDER BY autprg.programId
END