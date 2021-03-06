USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListAgency]    Script Date: 05-08-2016 14:20:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล>
--  1. yearEntry		เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
--	2. degreeLevel		เป็น VARCHAR	รับค่าระดับปริญญา
--	3. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	4. program			เป็น VARCHAR	รับค่าหลักสูตร
--  5. hospital			เป็น VARCHAR	รับค่าหน่วยบริการสุขภาพ
--	6. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
--	7. cancelledStatus	เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  8. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  9. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListAgency]
(
	@yearEntry VARCHAR(4) = NULL,
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,
	@hospital VARCHAR(15) = NULL,
	@registrationForm VARCHAR(50) = NULL,
	@cancelledStatus VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))		
	SET @hospital = LTRIM(RTRIM(@hospital))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))
	SET @cancelledStatus = LTRIM(RTRIM(@cancelledStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Program' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

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
			hcsagc.cancelledStatus,
			hcsagc.createDate,
			hcsagc.modifyDate
	INTO	#hcsTemp1
	FROM	hcsAgency AS hcsagc INNER JOIN
			hcsHospital AS hcshpt ON hcsagc.hcsHospitalId = hcshpt.id INNER JOIN
			acaProgram AS acaprg ON hcsagc.acaProgramId = acaprg.id LEFT JOIN
			acaFaculty AS acafac ON acaprg.facultyId = acafac.id	
	WHERE	(acaprg.cancelStatus IS NULL) AND
			(1 = (CASE WHEN (LEN(ISNULL(@yearEntry, '')) > 0) THEN 0 ELSE 1 END) OR hcsagc.yearEntry = @yearEntry) AND
			(1 = (CASE WHEN (LEN(ISNULL(@degreeLevel, '')) > 0) THEN 0 ELSE 1 END) OR acaprg.dLevel = @degreeLevel) AND
			(1 = (CASE WHEN (LEN(ISNULL(@faculty, '')) > 0 AND @faculty <> 'MU-01') THEN 0 ELSE 1 END) OR acaprg.facultyId = @faculty) AND
			(1 = (CASE WHEN (LEN(ISNULL(@program, '')) > 0) THEN 0 ELSE 1 END) OR hcsagc.acaProgramId = @program) AND
			(1 = (CASE WHEN (LEN(ISNULL(@hospital, '')) > 0) THEN 0 ELSE 1 END) OR hcsagc.hcsHospitalId = @hospital) AND					
			(1 = (CASE WHEN (LEN(ISNULL(@registrationForm, '')) > 0) THEN 0 ELSE 1 END) OR hcsagc.hcsRegistrationFormId LIKE ('%' + @registrationForm + '%')) AND
			(1 = (CASE WHEN (LEN(ISNULL(@cancelledStatus, '')) > 0) THEN 0 ELSE 1 END) OR hcsagc.cancelledStatus = @cancelledStatus)

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'Year Attended Ascending'		THEN yearEntry END ASC,
				CASE WHEN @sort = 'Program Ascending'			THEN acaProgramId END ASC,
				CASE WHEN @sort = 'Hospital Ascending'			THEN hcsHospitalId END ASC,
				CASE WHEN @sort = 'Cancelled Status Ascending'	THEN cancelledStatus END ASC,
				CASE WHEN @sort = 'Create Date Ascending'		THEN createDate END ASC,
				CASE WHEN @sort = 'Modify Date Ascending'		THEN modifyDate END ASC,

				CASE WHEN @sort = 'Year Attended Descending'	THEN yearEntry END DESC,
				CASE WHEN @sort = 'Program Descending'			THEN acaProgramId END DESC,
				CASE WHEN @sort = 'Hospital Descending'			THEN hcsHospitalId END DESC,
				CASE WHEN @sort = 'Cancelled Status Descending'	THEN cancelledStatus END DESC,
				CASE WHEN @sort = 'Create Date Descending'		THEN createDate END DESC,
				CASE WHEN @sort = 'Modify Date Descending'		THEN modifyDate END DESC
			) AS rowNum,
			*
	FROM	#hcsTemp1
END