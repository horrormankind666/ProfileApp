USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_hcsGetListPersonStudentWithAuthenStaff]    Script Date: 10-10-2016 13:51:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๙/๐๗/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username			เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--	2. userlevel		เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
--	3. systemGroup		เป็น VARCHAR	รับค่าชื่อระบบงาน
--	4. keyword			เป็น NVARCHAR	รับค่าคำค้น
--	5. degreeLevel		เป็น VARCHAR	รับค่าระดับปริญญา
--  6. faculty			เป็น VARCHAR	รับค่ารหัสคณะ
--	7. program			เป็น VARCHAR	รับค่าหน่วยงานที่ขึ้นทะเบียนสิทธิรักษาพยาบาล
--  8. yearEntry		เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
--  9. entranceType		เป็น VARCHAR	รับค่าระบบการสอบเข้า
-- 10. studentStatus	เป็น VARCHAR	รับค่าสถานภาพการเป็นนักศึกษา
-- 11. hcsJoin			เป็น VARCHAR	รับค่ามีสิทธิขึ้นทะเบียนสิทธิรักษาพยาบาลหรือไม่
-- 12. registrationForm	เป็น VARCHAR	รับค่าแบบฟอร์มบริการสุขภาพ
-- 13. downloadStatus	เป็น VARCHAR	รับค่าสถานะการดาว์นโหลด
-- 14. sortOrderBy		เป็น VARCHAR	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 15. sortExpression	เป็น VARCHAR	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER PROCEDURE [dbo].[sp_hcsGetListPersonStudentWithAuthenStaff]
(
	@username VARCHAR(255) = NULL,
	@userlevel VARCHAR(20) = NULL,
	@systemGroup VARCHAR(50) = NULL,
	@keyword NVARCHAR(MAX) = NULL,	
	@degreeLevel NVARCHAR(2) = NULL,
	@faculty VARCHAR(15) = NULL,
	@program VARCHAR(15) = NULL,	
	@yearEntry VARCHAR(4) = NULL,
	@entranceType VARCHAR(20) = NULL,
	@studentStatus VARCHAR(3) = NULL,
	@hcsJoin VARCHAR(1) = NULL,	
	@registrationForm NVARCHAR(50) = NULL,		
	@downloadStatus VARCHAR(1) = NULL,	
	@sortOrderBy VARCHAR(255) = NULL,
	@sortExpression VARCHAR(255) = NULL			
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @username = LTRIM(RTRIM(@username))
	SET @userlevel = LTRIM(RTRIM(@userlevel))
	SET @systemGroup = LTRIM(RTRIM(@systemGroup))
	SET @keyword = LTRIM(RTRIM(@keyword))	
	SET @degreeLevel = LTRIM(RTRIM(@degreeLevel))
	SET @faculty = LTRIM(RTRIM(@faculty))
	SET @program = LTRIM(RTRIM(@program))		
	SET @yearEntry = LTRIM(RTRIM(@yearEntry))
	SET @entranceType = LTRIM(RTRIM(@entranceType))	
	SET @studentStatus = LTRIM(RTRIM(@studentStatus))
	SET @hcsJoin = LTRIM(RTRIM(@hcsJoin))
	SET @registrationForm = LTRIM(RTRIM(@registrationForm))
	SET @downloadStatus = LTRIM(RTRIM(@downloadStatus))
	SET @sortOrderBy = LTRIM(RTRIM(@sortOrderBy))
	SET @sortExpression = LTRIM(RTRIM(@sortExpression))		
	
	DECLARE	@userFaculty VARCHAR(15) = NULL
	DECLARE @userProgram VARCHAR(15) = NULL
	DECLARE @sort VARCHAR(255) = ''	
	DECLARE @keywordIn VARCHAR(10) = ''
	DECLARE @forPublicServant VARCHAR(1) = 'N'
	DECLARE @cancelledStatus VARCHAR(1) = 'N'
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
	WHERE	 (logForm = @registrationForm) AND (logBy <> 'Student')

	IF (LEN(ISNULL(@registrationForm, '')) > 0)
	BEGIN
		SELECT	@forPublicServant = hcsfrm.forPublicServant,
				@cancelledStatus = hcsfrm.cancel
		FROM	hcsForm AS hcsfrm
		WHERE  (hcsfrm.id = @registrationForm)
	END
	
	SELECT	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	FROM	autUserAccessProgram AS autusr
	WHERE	(autusr.username = @username) AND
			(autusr.level = @userlevel) AND
			(autusr.systemGroup = @systemGroup)

	SET @userFaculty = ISNULL(@userFaculty, '')
	SET @userProgram = ISNULL(@userProgram, '')
				
	SELECT	stdper.id,
			stdper.studentId,
			stdper.studentCode,
			stdper.idCard,
			stdper.perTitlePrefixId,
			stdper.titlePrefixFullNameTH,
			stdper.titlePrefixInitialsTH,					
			stdper.titlePrefixFullNameEN,
			stdper.titlePrefixInitialsEN,
			stdper.firstName,
			stdper.middleName,
			stdper.lastName,
			stdper.firstNameEN,
			stdper.middleNameEN,
			stdper.lastNameEN,
			stdper.perNationalityId,
			stdper.perOriginId,
			stdper.perBloodTypeId,
			perblo.thBloodTypeName AS bloodTypeNameTH,
			perblo.enBloodTypeName AS bloodTypeNameEN,
			perhel.bodyMassDetail,
			stdper.degree,
			stdper.facultyId,
			stdper.facultyCode,
			stdper.programId,			
			stdper.programCode,
			stdper.majorCode,
			stdper.groupNum,
			stdper.yearEntry,
			stdper.perEntranceTypeId,
			stdper.status,			
			stdper.statusGroup,
			perpar.occupationFather,
			perpar.occupationMother,
			(CASE WHEN (hcsagc.acaProgramId IS NOT NULL) THEN 'Y' ELSE 'N' END) AS hcsJoin,
			hcsagc.acaProgramId AS hcsProgramId,			
			hcsagc.hcsHospitalId,
			hcsagc.hcsRegistrationFormId,
			hcstmp.perPersonId,
			hcstmp.logForm,
			hcstmp.latestDateDownload,
			hcstmp.countDownload,
			hcstmp.logBy
	INTO	#hcsTemp2
	FROM	vw_perGetListPersonStudent AS stdper LEFT JOIN
			perNationality AS pernat ON stdper.perNationalityId = pernat.id LEFT JOIN
			perBloodType AS perblo ON stdper.perBloodTypeId = perblo.id LEFT JOIN
			perHealthy AS perhel ON stdper.id = perhel.perPersonId LEFT JOIN
			perImpairments AS perimp ON perhel.perImpairmentsId = perimp.id  LEFT JOIN
			vw_perGetListParent AS perpar ON stdper.id = perpar.id LEFT JOIN
			hcsAgency AS hcsagc ON (stdper.yearEntry = hcsagc.yearEntry) AND (stdper.programId = hcsagc.acaProgramId) LEFT JOIN
			hcsHospital AS hcshpt ON hcsagc.hcsHospitalId = hcshpt.id LEFT JOIN
			#hcsTemp1 AS hcstmp ON stdper.id = hcstmp.perPersonId		
	WHERE	(1 = (CASE WHEN (@userFaculty <> 'MU-01') THEN 0 ELSE 1 END) OR stdper.facultyId = @userFaculty) AND
			(1 = (CASE WHEN (LEN(@userProgram) > 0 AND LEN(@userFaculty) > 0) THEN 0 ELSE 1 END) OR stdper.programId = @userProgram) AND
			(stdper.programCancelStatus IS NULL) AND			
			(1 = (CASE WHEN (LEN(ISNULL(@registrationForm, '')) > 0) THEN 0 ELSE 1 END) OR
				(
					((hcshpt.cancel + @cancelledStatus) = 'NN') AND
					(hcsagc.hcsRegistrationFormId LIKE ('%' + @registrationForm + '%')) AND
					(
						(1 = (CASE WHEN (@forPublicServant = 'Y') THEN 0 ELSE 1 END) OR
							(perpar.occupationFather = '01') OR
							(perpar.occupationMother = '01'))
					)
				))

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
			(1 = (CASE WHEN (@hcsJoin = 'Y' OR @hcsJoin = 'N') THEN 0 ELSE 1 END) OR
				(CASE WHEN (hcsProgramId IS NOT NULL) THEN 'Y' ELSE 'N' END) = @hcsJoin) AND
			(1 = (CASE WHEN (LEN(ISNULL(@downloadStatus, '')) > 0) THEN 0 ELSE 1 END) OR
				(ISNULL(hcstmp.countDownload, 0) = (CASE WHEN (@downloadStatus = 'N') THEN 0 ELSE -1 END)) OR
				(ISNULL(hcstmp.countDownload, 0) > (CASE WHEN (@downloadStatus = 'Y') THEN 0 ELSE 666 END)))

	SELECT	ROW_NUMBER() OVER(ORDER BY 
				CASE WHEN @sort = 'Student ID Ascending'	THEN (ISNULL(yearEntry, '') + ISNULL(studentCode, '')) END ASC,
				CASE WHEN @sort = 'Student ID Descending'	THEN (ISNULL(yearEntry, '') + ISNULL(studentCode, '')) END DESC
			) AS rowNum,
			*
	FROM	#hcsTemp3
END