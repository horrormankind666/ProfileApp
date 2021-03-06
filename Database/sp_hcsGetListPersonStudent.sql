USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListPersonStudent]    Script Date: 06/12/2015 10:38:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๒/๐๕/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาสำหรับระบบขึ้นทะเบียนสิทธิรักษาพยาบาลของนักศึกษา>
-- Parameter
--  1. personId		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. studentId	เป็น VARCHAR	รับค่ารหัสนักศึกษา
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListPersonStudent]
(
	@personId VARCHAR(MAX) = NULL,
	@studentId VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	SET @studentId = LTRIM(RTRIM(@studentId))	
		
	IF ((@personId IS NOT NULL AND LEN(@personId) > 0) OR (@studentId IS NOT NULL AND LEN(@studentId) > 0))
	BEGIN
		SELECT	stdstd.*,		
				hcsprg.stdHSCHospitalId,
				hcshpt.thHospitalName,
				hcshpt.enHospitalName,
				peradd.*,
				perwkparent.*
		FROM	fnc_perGetListPersonStudent(@personId, @studentId, '', '', '', '', '') AS stdstd INNER JOIN
				hcsProgram AS hcsprg ON stdstd.programId = hcsprg.acaProgramId INNER JOIN
				hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id LEFT JOIN
				fnc_perGetListAddress(@personId, '', '') AS peradd ON stdstd.id = peradd.id LEFT JOIN
				fnc_perGetListWorkParent(@personId, '', '') AS perwkparent ON stdstd.id = perwkparent.id
	END
	ELSE
		BEGIN
			SELECT	stdstd.id,		
					stdstd.studentId,
					stdstd.studentCode
			FROM	fnc_perGetListPersonStudent('', '', '', '', '', '', '') AS stdstd INNER JOIN
					hcsProgram AS hcsprg ON stdstd.programId = hcsprg.acaProgramId INNER JOIN
					hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id
		END		
END