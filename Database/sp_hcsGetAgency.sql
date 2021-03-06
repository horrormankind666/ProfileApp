USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetAgency]    Script Date: 5/4/2559 11:54:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๒/๐๗/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล>
--  1. id	เป็น VARCHAR	รับค่ารหัสหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetAgency]
(
	@id VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @id = LTRIM(RTRIM(@id))		

	SELECT	(hcsagc.yearEntry + hcsagc.acaProgramId) AS id,
			hcsagc.yearEntry,
			acaprg.facultyId,
			acafac.facultyCode,
			acafac.nameTh AS facultyNameTH,
			acafac.nameEn AS facultyNameEN,
			hcsagc.acaProgramId,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			acaprg.nameTh AS programNameTH,
			acaprg.nameEn AS programNameEN,
			acaprg.address AS programAddress,
			acaprg.telephone AS programTelephone,			
			acaprg.dLevel AS degreeLevel,
			hcsagc.hcsHospitalId,
			hcshpt.thHospitalName AS hospitalNameTH,
			hcshpt.enHospitalName AS hospitalNameEN,
			hcsagc.hcsRegistrationFormId,
			hcsagc.cancelledStatus
	FROM	hcsAgency AS hcsagc INNER JOIN
			hcsHospital AS hcshpt ON hcsagc.hcsHospitalId = hcshpt.id INNER JOIN
			acaProgram AS acaprg ON hcsagc.acaProgramId = acaprg.id LEFT JOIN
			acaFaculty AS acafac ON acaprg.facultyId = acafac.id
	WHERE	((hcsagc.yearEntry + hcsagc.acaProgramId) = @id)
END