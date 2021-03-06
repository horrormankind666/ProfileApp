USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListDownloadLog]    Script Date: 23-09-2016 12:20:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๐๔/๒๕๕๙>
-- Description	: <สำหรับเรียกดูข้อมูลการดาวน์โหลดแบบฟอร์มบริการสุขภาพตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username			เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel		เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup		เป็น VARCHAR	รับค่าชื่อระบบงาน
--	4. reportName		เป็น VARCHAR	รับค่าชื่อรายงาน
--	5. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	6. degreeLevel		เป็น VARCHAR	รับค่าระดับปริญญา
--  7. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	8. program			เป็น VARCHAR	รับค่าหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล
--  9. yearEntry		เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
-- 10. entranceType		เป็น VARCHAR	รับค่าระบบการสอบเข้า
-- 11. studentStatus	เป็น VARCHAR	รับค่าสถานภาพการเป็นนักศึกษา
-- 12. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
-- 13. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 14. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListDownloadLog]
(
	@username VARCHAR(255) = NULL,
	@userlevel VARCHAR(20) = NULL,
	@systemGroup VARCHAR(50) = NULL,
	@reportName VARCHAR(100) = NULL,
	@keyword NVARCHAR(MAX) = NULL,	
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,	
	@yearEntry VARCHAR(4) = NULL,
	@entranceType VARCHAR(20) = NULL,
	@studentStatus VARCHAR(3) = NULL,
	@registrationForm NVARCHAR(50) = NULL,		
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON

	SET @username = LTRIM(RTRIM(@username))
	SET @userlevel = LTRIM(RTRIM(@userlevel))
	SET @systemGroup = LTRIM(RTRIM(@systemGroup))
	SET @reportName = LTRIM(RTRIM(@reportName))
	SET @keyword = LTRIM(RTRIM(@keyword))	
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))		
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @entranceType = LTRIM(RTRIM(@entranceType))	
	SET @studentStatus = LTRIM(RTRIM(@studentStatus))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))

	DECLARE	@userFaculty VARCHAR(15) = NULL
	DECLARE @userProgram VARCHAR(15) = NULL
	DECLARE @sort VARCHAR(255) = ''	
	DECLARE @keywordIn VARCHAR(10) = ''
	DECLARE @xml XML
	
	SET @sortOrderBy = (CASE WHEN (@sortOrderBy IS NOT NULL) AND (LEN(@sortOrderBy) > 0) THEN @sortOrderBy ELSE 'Student ID' END)
	SET @sortExpression = (CASE WHEN (@sortExpression IS NOT NULL) AND (LEN(@sortExpression) > 0) THEN @sortExpression ELSE 'Ascending' END)
	SET @sort = (@sortOrderBy + ' ' + @sortExpression)

	IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
	BEGIN
		IF (SUBSTRING(@keyword, 1, 8) = 'INPERSON')
			SET @keywordIn = 'INPERSON'
		ELSE
			IF (SUBSTRING(@keyword, 1, 2) = 'IN')				
				SET @keywordIn = 'IN'
			
		IF (@keywordIn = 'INPERSON' OR @keywordIn = 'IN')
			SET @keyword = REPLACE(@keyword, (@keywordIn + ' '), '')			
	END

	SET @xml = CAST(('<A>' + REPLACE(@keyword, '|', '</A><A>') + '</A>') AS XML)

	SELECT	A.value('.', 'VARCHAR(MAX)') as keyword
	INTO	#keywordTemp
	FROM	@xml.nodes('A') AS FN(A)
	
	SELECT	 *
	INTO	 #hcsTemp1
	FROM	 vw_hcsGetDownloadLog

	SELECT	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	FROM	autUserAccessProgram AS autusr
	WHERE	(autusr.username = @username) AND
			(autusr.level = @userlevel) AND
			(autusr.systemGroup = @systemGroup)

	SELECT	perpes.id,
			stdstd.id AS studentId,
			stdstd.studentCode,
			pertpl.thTitleFullName AS titlePrefixFullNameTH,
			pertpl.thTitleInitials AS titlePrefixInitialsTH,					
			pertpl.enTitleFullName AS titlePrefixFullNameEN,
			pertpl.enTitleInitials AS titlePrefixInitialsEN,
			perpes.firstName,
			perpes.middleName,
			perpes.lastName,
			perpes.enFirstName AS firstNameEN,
			perpes.enMiddleName AS middleNameEN,
			perpes.enLastName AS lastNameEN,
			perpes.idCard,
			stdstd.degree,
			stdstd.facultyId,
			acafac.facultyCode,
			stdstd.programId,
			acaprg.programCode,
			acaprg.majorCode,
			acaprg.groupNum,
			stdstd.yearEntry,
			stdstd.admissionType AS perEntranceTypeId,
			stdstd.status,
			stdstt.[group] AS statusGroup,
			hcsFrm.orderForm,
			hcstmp.logForm,
			hcstmp.countDownload,
			hcstmp.latestDateDownload
	INTO	#hcsTemp2
	FROM	stdStudent AS stdstd LEFT JOIN
			acaFaculty AS acafac ON stdstd.facultyId = acafac.id LEFT JOIN
			acaProgram AS acaprg ON stdstd.facultyId = acaprg.facultyId AND stdstd.programId = acaprg.id LEFT JOIN
			stdStatusType AS stdstt ON stdstd.status = stdstt.id INNER JOIN
			perPerson AS perpes ON stdstd.personId = perpes.id LEFT JOIN
			perTitlePrefix AS pertpl ON perpes.perTitlePrefixId = pertpl.id INNER JOIN
			#hcsTemp1 AS hcstmp ON perpes.id = hcstmp.perPersonId INNER JOIN
			hcsForm AS hcsfrm ON hcstmp.logForm = hcsfrm.id
	WHERE	(1 = (CASE WHEN (@userFaculty <> 'MU-01') THEN 0 ELSE 1 END) OR stdstd.facultyId = @userFaculty) AND
			(1 = (CASE WHEN (LEN(@userProgram) > 0 AND LEN(@userFaculty) > 0) THEN 0 ELSE 1 END) OR stdstd.programId = @userProgram) AND 
			(acaprg.cancelStatus IS NULL)

	SELECT	hcstmp.*,
			keytmp1.keyword AS keywordPersonId,
			keytmp2.keyword AS keywordStudentCode
	INTO	#hcsTemp3
	FROM	#hcsTemp2 AS hcstmp LEFT JOIN
			#keywordTemp AS keytmp1 ON keytmp1.keyword = hcstmp.id LEFT JOIN
			#keywordTemp AS keytmp2 ON keytmp2.keyword = hcstmp.studentCode
	WHERE	(1 = (CASE WHEN (@keywordIn = 'INPERSON') THEN 0 ELSE 1 END) OR keytmp1.keyword IS NOT NULL) AND					
			(1 = (CASE WHEN (@keywordIn = 'IN') THEN 0 ELSE 1 END) OR keytmp2.keyword IS NOT NULL) AND
			(1 = (CASE WHEN (LEN(ISNULL(@keywordIn, '')) = 0 AND LEN(ISNULL(@keyword, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(hcstmp.studentCode, '') LIKE (@keyword + '%')) OR
				(ISNULL(hcstmp.titlePrefixFullNameTH, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.titlePrefixInitialsTH, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.titlePrefixFullNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.titlePrefixInitialsEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.firstName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.middleName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.lastName, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.firstNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.middleNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.lastNameEN, '') LIKE ('%' + @keyword + '%')) OR
				(ISNULL(hcstmp.idCard, '') LIKE ('%' + @keyword + '%'))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@degreeLevel, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.degree = @degreeLevel) AND
			(1 = (CASE WHEN (LEN(ISNULL(@faculty, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.facultyId = @faculty) AND
			(1 = (CASE WHEN (LEN(ISNULL(@program, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.programId = @program) AND
			(1 = (CASE WHEN (LEN(ISNULL(@yearEntry, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.yearEntry = @yearEntry) AND
			(1 = (CASE WHEN (LEN(ISNULL(@entranceType, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.perEntranceTypeId = @entranceType) AND
			(1 = (CASE WHEN (LEN(ISNULL(@studentStatus, '')) > 0) THEN 0 ELSE 1 END) OR
				(hcstmp.status = @studentStatus) OR
				(hcstmp.statusGroup = (CASE WHEN (@studentStatus = '100') THEN '01' ELSE '' END))) AND
			(1 = (CASE WHEN (LEN(ISNULL(@registrationForm, '')) > 0) THEN 0 ELSE 1 END) OR hcstmp.logForm = @registrationForm)

	SELECT	 ISNULL(SUM(ISNULL(countDownload, 0)), 0)
	FROM	 #hcsTemp3

	SELECT	 COUNT(hcstmp.id)
	FROM	 (
				SELECT	 id
				FROM	 #hcsTemp3
				GROUP BY id
				) AS hcstmp

	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF (@reportName = 'StatisticsDownloadHealthCareServiceFormViewChart')		
	BEGIN
		SELECT	 logForm,
				 SUM(ISNULL(countDownload, 0)) AS countDownload,
				 COUNT(id) AS countPeople
		FROM	 #hcsTemp3
		GROUP BY orderForm, logForm
		ORDER BY orderForm
	END

	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF (@reportName = 'StatisticsDownloadHealthCareServiceFormViewChart' OR
		@reportName = 'StatisticsDownloadHealthCareServiceFormLevel1ViewTable')
	BEGIN
		SELECT	 (logForm + yearEntry) AS id,
				 logForm,
				 yearEntry,
				 SUM(ISNULL(countDownload, 0)) AS countDownload,
				 COUNT(id) AS countPeople
		FROM	 #hcsTemp3
		GROUP BY orderForm, logForm, yearEntry
		ORDER BY orderForm, yearEntry
		
		IF (@reportName = 'StatisticsDownloadHealthCareServiceFormViewChart')
		BEGIN
			SELECT   logForm,
					 yearEntry,
					 facultyCode,					 
					 SUM(ISNULL(countDownload, 0)) AS countDownload,
					 COUNT(id) AS countPeople
			FROM	 #hcsTemp3
			GROUP BY orderForm, logForm, yearEntry, facultyCode
			ORDER BY orderForm, yearEntry, facultyCode
		END
	END

	------------------------------------------------------------------------------------------------------------------------------------------------------

	IF (@reportName = 'StatisticsDownloadHealthCareServiceFormLevel2ViewTable')
	BEGIN		
		SELECT	*
		FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY
							CASE WHEN @sort = 'Student ID Ascending'		THEN (ISNULL(hcstmp.yearEntry, '') + ISNULL(hcstmp.studentCode, '')) END ASC,
							CASE WHEN @sort = 'Name Ascending'				THEN ISNULL(hcstmp.firstName, '') END ASC,
							CASE WHEN @sort = 'Faculty Ascending'			THEN (ISNULL(hcstmp.facultyId, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END ASC,
							CASE WHEN @sort = 'Program Ascending'			THEN (ISNULL(hcstmp.programId, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END ASC,
							CASE WHEN @sort = 'Year Attended Ascending'		THEN (ISNULL(hcstmp.yearEntry, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END ASC,
							
							CASE WHEN @sort = 'Student ID Descending'		THEN (ISNULL(hcstmp.yearEntry, '') + ISNULL(hcstmp.studentCode, '')) END DESC,
							CASE WHEN @sort = 'Name Descending'				THEN ISNULL(hcstmp.firstName, '') END DESC,
							CASE WHEN @sort = 'Faculty Descending'			THEN (ISNULL(hcstmp.facultyId, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END DESC,
							CASE WHEN @sort = 'Program Descending'			THEN (ISNULL(hcstmp.programId, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END DESC,
							CASE WHEN @sort = 'Year Attended Descending'	THEN (ISNULL(hcstmp.yearEntry, '') + ISNULL(hcstmp.studentCode, hcstmp.id)) END DESC
						) AS rowNum,
						hcstmp.*
				 FROM	#hcsTemp3 AS hcstmp) AS stdstd
	END
END
