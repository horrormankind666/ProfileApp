USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetProgram]    Script Date: 11/16/2015 15:21:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๒/๐๗/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล>
--  1. programId	เป็น VARCHAR	รับค่ารหัสหลักสูตร
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetProgram]
(
	@programId VARCHAR(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @programId = LTRIM(RTRIM(@programId))		

	SELECT	acaprg.facultyId,
			acafac.facultyCode,
			acafac.nameTh AS thFacultyName,
			acafac.nameEn AS enFacultyName,
			hcsprg.acaProgramId,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.nameTh AS thProgramName,
			acaprg.nameEn AS enProgramName,					
			hcsprg.stdHSCHospitalId,
			hcshpt.thHospitalName,
			hcshpt.enHospitalName,
			hcsprg.showRARegisForm,
			hcsprg.showSIRegisForm,
			hcsprg.showRAPatientRegisForm,
			hcsprg.showSIPatientRegisForm,
			hcsprg.showTMPatientRegisForm,
			hcsprg.showGJPatientRegisForm,
			hcsprg.showKN001Form,
			hcsprg.showKN002Form,
			hcsprg.showKN003Form,
			hcsprg.cancel,
			hcsprg.createDate,
			hcsprg.modifyDate
	FROM	hcsProgram AS hcsprg INNER JOIN
			hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id INNER JOIN
			acaProgram AS acaprg ON hcsprg.acaProgramId = acaprg.id LEFT JOIN
			acaFaculty AS acafac ON acaprg.facultyId = acafac.id
	WHERE	(hcsprg.acaProgramId = @programId)
END