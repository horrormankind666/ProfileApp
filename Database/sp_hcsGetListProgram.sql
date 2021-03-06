USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListProgram]    Script Date: 11/16/2015 15:37:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลแบบฟอร์มบริการสุขภาพ>
--	1. facultyId		เป็น VARCHAR	รับค่ารหัสคณะ
--  2. programId		เป็น VARCHAR	รับค่าหลักสูตร
--  3. hospital			เป็น VARCHAR	รับค่าหน่วยบริการสุขภาพ
--	4. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
--	5. showForm			เป็น VARCHAR	รับค่าการแสดงแบบฟอร์มบริการสุขภาพ
--	6. cancel			เป็น VARCHAR	รับค่าสถานะการยกเลิก
--  7. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
--  8. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListProgram]
(
	@facultyId VARCHAR(15) = NULL,
	@programId VARCHAR(15) = NULL,
	@hospital VARCHAR(15) = NULL,
	@registrationForm VARCHAR(50) = NULL,
	@activeForm VARCHAR(1) = NULL,
	@cancel VARCHAR(1) = NULL,
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @facultyId = LTRIM(RTRIM(@facultyId))
	SET @programId = LTRIM(RTRIM(@programId))		
	SET @hospital = LTRIM(RTRIM(@hospital))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))
	SET @activeForm = LTRIM(RTRIM(@activeForm))
	SET @cancel = LTRIM(RTRIM(@cancel))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))	
	
	DECLARE @sort VARCHAR(255) = ''
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Program' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	SELECT	*
	FROM	(SELECT ROW_NUMBER() OVER(ORDER BY 
						CASE WHEN @sort = 'Program Ascending'						THEN hcsprg.acaProgramId END ASC,
						CASE WHEN @sort = 'Hospital Ascending'						THEN hcsprg.stdHSCHospitalId END ASC,
						CASE WHEN @sort = 'Active RARegisForm Ascending'			THEN hcsprg.showRARegisForm END ASC,
						CASE WHEN @sort = 'Active SIRegisForm Ascending'			THEN hcsprg.showSIRegisForm END ASC,
						CASE WHEN @sort = 'Active RAPatientRegisForm Ascending'		THEN hcsprg.showRAPatientRegisForm END ASC,
						CASE WHEN @sort = 'Active SIPatientRegisForm Ascending'		THEN hcsprg.showSIPatientRegisForm END ASC,
						CASE WHEN @sort = 'Active TMPatientRegisForm Ascending'		THEN hcsprg.showTMPatientRegisForm END ASC,
						CASE WHEN @sort = 'Active GJPatientRegisForm Ascending'		THEN hcsprg.showGJPatientRegisForm END ASC,
						CASE WHEN @sort = 'Active KN001Form Ascending'				THEN hcsprg.showKN001Form END ASC,					
						CASE WHEN @sort = 'Active KN002Form Ascending'				THEN hcsprg.showKN002Form END ASC,					
						CASE WHEN @sort = 'Active KN003Form Ascending'				THEN hcsprg.showKN003Form END ASC,					
						CASE WHEN @sort = 'Cancel Ascending'						THEN hcsprg.cancel END ASC,
						CASE WHEN @sort = 'Create Date Ascending'					THEN hcsprg.createDate END ASC,
						CASE WHEN @sort = 'Modify Date Ascending'					THEN hcsprg.modifyDate END ASC,

						CASE WHEN @sort = 'Program Descending'						THEN hcsprg.acaProgramId END DESC,
						CASE WHEN @sort = 'Hospital Descending'						THEN hcsprg.stdHSCHospitalId END DESC,
						CASE WHEN @sort = 'Active RARegisForm Descending'			THEN hcsprg.showRARegisForm END DESC,
						CASE WHEN @sort = 'Active SIRegisForm Descending'			THEN hcsprg.showSIRegisForm END DESC,
						CASE WHEN @sort = 'Active RAPatientRegisForm Descending'	THEN hcsprg.showRAPatientRegisForm END DESC,
						CASE WHEN @sort = 'Active SIPatientRegisForm Descending'	THEN hcsprg.showSIPatientRegisForm END DESC,
						CASE WHEN @sort = 'Active TMPatientRegisForm Descending'	THEN hcsprg.showTMPatientRegisForm END DESC,
						CASE WHEN @sort = 'Active GJPatientRegisForm Descending'	THEN hcsprg.showGJPatientRegisForm END DESC,
						CASE WHEN @sort = 'Active KN001Form Descending'				THEN hcsprg.showKN001Form END DESC,					
						CASE WHEN @sort = 'Active KN002Form Descending'				THEN hcsprg.showKN002Form END DESC,					
						CASE WHEN @sort = 'Active KN003Form Descending'				THEN hcsprg.showKN003Form END DESC,					
						CASE WHEN @sort = 'Cancel Descending'						THEN hcsprg.cancel END DESC,
						CASE WHEN @sort = 'Create Date Descending'					THEN hcsprg.createDate END DESC,
						CASE WHEN @sort = 'Modify Date Descending'					THEN hcsprg.modifyDate END DESC
					) AS rowNum,
					acaprg.facultyId,
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
			 WHERE	(
						(1 = (CASE WHEN (LTRIM(RTRIM(@facultyId)) IS NOT NULL AND LEN(LTRIM(RTRIM(@facultyId))) > 0) THEN 0 ELSE 1 END)) OR
						(acaprg.facultyId = (CASE WHEN (LTRIM(RTRIM(@facultyId)) IS NOT NULL AND LEN(LTRIM(RTRIM(@facultyId))) > 0) THEN @facultyId ELSE '' END))
					) AND
					(
						(1 = (CASE WHEN (LTRIM(RTRIM(@programId)) IS NOT NULL AND LEN(LTRIM(RTRIM(@programId))) > 0) THEN 0 ELSE 1 END)) OR
						(hcsprg.acaProgramId = (CASE WHEN (LTRIM(RTRIM(@programId)) IS NOT NULL AND LEN(LTRIM(RTRIM(@programId))) > 0) THEN @programId ELSE '' END))
					) AND
					(
						(1 = (CASE WHEN (LTRIM(RTRIM(@hospital)) IS NOT NULL AND LEN(LTRIM(RTRIM(@hospital))) > 0) THEN 0 ELSE 1 END)) OR
						(hcsprg.stdHSCHospitalId = (CASE WHEN (LTRIM(RTRIM(@hospital)) IS NOT NULL AND LEN(LTRIM(RTRIM(@hospital))) > 0) THEN @hospital ELSE '' END))
					) AND					
					(
						(1 = (CASE WHEN (@activeForm IS NOT NULL AND LEN(@activeForm) > 0) THEN 0 ELSE 1 END)) OR 					 
						(
							(CASE WHEN (@registrationForm IS NOT NULL AND LEN(@registrationForm) > 0) THEN
								CASE @registrationForm
									WHEN 'RARegisForm'			THEN hcsprg.showRARegisForm
									WHEN 'SIRegisForm'			THEN hcsprg.showSIRegisForm
									WHEN 'RAPatientRegisForm'	THEN hcsprg.showRAPatientRegisForm
									WHEN 'SIPatientRegisForm'	THEN hcsprg.showSIPatientRegisForm
									WHEN 'TMPatientRegisForm'	THEN hcsprg.showTMPatientRegisForm
									WHEN 'GJPatientRegisForm'	THEN hcsprg.showGJPatientRegisForm
									WHEN 'KN001Form'			THEN hcsprg.showKN001Form
									WHEN 'KN002Form'			THEN hcsprg.showKN002Form
									WHEN 'KN003Form'			THEN hcsprg.showKN003Form
								END
							 ELSE
								(hcsprg.showRARegisForm + 
								 hcsprg.showSIRegisForm + 
								 hcsprg.showRAPatientRegisForm + 
								 hcsprg.showSIPatientRegisForm + 
								 hcsprg.showTMPatientRegisForm + 
								 hcsprg.showGJPatientRegisForm +
								 hcsprg.showKN001Form +
								 hcsprg.showKN002Form +
								 hcsprg.showKN003Form)
							 END) LIKE ('%' + @activeForm + '%')
						)
					) AND
					(
						(1 = (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0) THEN 0 ELSE 1 END)) OR					 
						(hcsprg.cancel = (CASE WHEN (@cancel IS NOT NULL AND LEN(@cancel) > 0) THEN @cancel ELSE '' END))
					)) AS hcsprg

	SELECT	COUNT(hcsprg.acaProgramId)
	FROM	hcsProgram AS hcsprg INNER JOIN
			hcsHospital AS hcshpt ON hcsprg.stdHSCHospitalId = hcshpt.id INNER JOIN
			acaProgram AS acaprg ON hcsprg.acaProgramId = acaprg.id LEFT JOIN
			acaFaculty AS acafac ON acaprg.facultyId = acafac.id	
END