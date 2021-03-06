USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_eProfile]    Script Date: 05/13/2015 16:08:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๗/๑๒/๒๕๕๖>
-- Description	: <สำหรับใช้กับระบบ e-Profile>
-- Parameter
--  1. orderTable			เป็น INT		รับค่าลำดับคำสั่ง
--	2. tableName			เป็น VARCHAR	รับค่าชื่อตารางในฐานข้อมูล
--  3. personId				เป็น VARCHAR	รับค่ารหัสบุคคล
--  4. studentId			เป็น VARCHAR	รับค่ารหัสนักศึกษา
--  5. username				เป็น VARCHAR	รับค่าชื่อผู้ใช้งาน
--  6. password				เป็น VARCHAR	รับค่ารหัสผ่านผู้ใช้งาน
--  7. idCard				เป็น VARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  8. gender				เป็น NVARCHAR	รับค่าเพศ
--  9. date					เป็น VARCHAR	รับค่าวันที่
-- 10. countryId			เป็น VARCHAR	รับค่ารหัสประเทศ
-- 11. provinceId			เป็น VARCHAR	รับค่ารหัสจังหวัด
-- 12. districtId			เป็น VARCHAR	รับค่ารหัสอำเภอ
-- 13. educationalLevelId	เป็น VARCHAR	รับค่ารหัสระดับการศึกษา
-- 14. relationshipId		เป็น VARCHAR	รับค่ารหัสความสัมพันธ์ในครอบครัว
-- 15. keyword				เป็น NVARCHAR	รับค่าคำค้น
-- 16. facultyId			เป็น VARCHAR	รับค่ารหัสคณะ
-- 17. programId			เป็น VARCHAR	รับค่าหลักสูตร
-- 18. yearAttended			เป็น VARCHAR	รับค่าปีที่เข้าศึกษา
-- 19. entranceTypeId		เป็น VARCHAR	รับค่าระบบการสอบเข้า
-- 20. studentStatusId		เป็น VARCHAR	รับค่าสถานภาพการเป็นนักศึกษา
-- 21. studentRecordsStatus	เป็น VARCHAR	รับค่าสถานะการบันทึกระเบียนประวัตินักศึกษา
-- 22. cancelStatus			เป็น VARCHAR	รับค่าสถานะการยกเลิก
-- 23. userlevel			เป็น VARCHAR	รับค่าระดับผู้ใช้งาน
-- 24. systemGroup			เป็น VARCHAR	รับค่าชื่อระบบงาน
-- =============================================
ALTER PROCEDURE [dbo].[sp_eProfile]
(
	@orderTable INT = NULL,
	@tableName VARCHAR(MAX) = NULL,
	@sortOrderBy VARCHAR(MAX) = NULL,
	@sortExpression VARCHAR(MAX) = NULL,	
	@personId VARCHAR(MAX) = NULL,
	@studentId VARCHAR(MAX) = NULL,
	@username VARCHAR(MAX) = NULL,
	@password VARCHAR(MAX) = NULL,	
	@idCard VARCHAR(MAX) = NULL,
	@gender NVARCHAR(MAX) = NULL,
	@date VARCHAR(MAX) = NULL,
	@countryId VARCHAR(MAX) = NULL,
	@provinceId VARCHAR(MAX) = NULL,
	@districtId VARCHAR(MAX) = NULL,
	@educationalLevelId VARCHAR(MAX) = NULL,
	@relationshipId VARCHAR(MAX) = NULL,	
	@keyword NVARCHAR(MAX) = NULL,
	@facultyId VARCHAR(MAX) = NULL,
	@programId VARCHAR(MAX) = NULL,
	@yearAttended VARCHAR(MAX) = NULL,
	@entranceTypeId VARCHAR(MAX) = NULL,
	@studentStatusId VARCHAR(MAX) = NULL,
	@studentRecordsStatus VARCHAR(MAX) = NULL,
	@cancelStatus VARCHAR(MAX) = NULL,
	@userlevel VARCHAR(MAX) = NULL,
	@systemGroup VARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @sql VARCHAR(MAX) = ''
	DECLARE @where VARCHAR(MAX) = ''
	DECLARE @studentJoin VARCHAR(MAX) = ''
	
	SET @sortExpression =
		CASE @sortExpression
			WHEN 'Ascending'	THEN 'ASC'
			WHEN 'Descending'	THEN 'DESC'
			ELSE 'ASC'
		END
	
	SET @studentJoin = 'stdStudent AS stdstd LEFT JOIN
						acaFaculty AS acafac1 ON stdstd.facultyId = acafac1.id LEFT JOIN
						acaProgram AS acaprg ON stdstd.facultyId = acaprg.facultyId AND stdstd.programId = acaprg.id LEFT JOIN										
						acaFaculty AS acafac2 ON acaprg.facultyId = acafac2.id LEFT JOIN
						acaMajor AS acamaj ON acaprg.majorId = acamaj.id LEFT JOIN
						stdDegreeLevel AS stddgl ON stdstd.degree = stddgl.id LEFT JOIN
						perEntranceType AS perent ON stdstd.admissionType = perent.id LEFT JOIN
						stdStatusType AS stdstt ON stdstd.status= stdstt.id INNER JOIN'
	
	/*แสดงข้อมูลจำนวนเรคคอร์ด*/
	IF (@orderTable = 1)
	BEGIN
		SET @tableName = UPPER(@tableName)
		DECLARE @recordCount INT = 0
		
		SET @recordCount =
			CASE
				WHEN (@tableName = 'PERSON')			THEN (SELECT COUNT(id) FROM perPerson WHERE id = @personId)
				WHEN (@tableName = 'PERSONAL')			THEN (SELECT COUNT(id) FROM perPerson WHERE id = @personId)
				WHEN (@tableName = 'ADDRESS')			THEN (SELECT COUNT(perPersonId) FROM perAddress WHERE perPersonId = @personId)
				WHEN (@tableName = 'PERMANENTADDRESS')	THEN (SELECT COUNT(perPersonId) FROM perAddress WHERE perPersonId = @personId)
				WHEN (@tableName = 'CURRENTADDRESS')	THEN (SELECT COUNT(perPersonId) FROM perAddress WHERE perPersonId = @personId)
				WHEN (@tableName = 'EDUCATION')			THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)
				WHEN (@tableName = 'PRIMARYSCHOOL')		THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)
				WHEN (@tableName = 'JUNIORHIGHSCHOOL')	THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)
				WHEN (@tableName = 'HIGHSCHOOL')		THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)					
				WHEN (@tableName = 'UNIVERSITY')		THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)
				WHEN (@tableName = 'ADMISSIONSCORES')	THEN (SELECT COUNT(perPersonId) FROM perEducation WHERE perPersonId = @personId)					
				WHEN (@tableName = 'TALENT')			THEN (SELECT COUNT(perPersonId) FROM perActivity WHERE perPersonId = @personId)
				WHEN (@tableName = 'HEALTHY')			THEN (SELECT COUNT(perPersonId) FROM perHealthy WHERE perPersonId = @personId)
				WHEN (@tableName = 'WORK')				THEN (SELECT COUNT(perPersonId) FROM perWork WHERE perPersonId = @personId)
				WHEN (@tableName = 'FINANCIAL')			THEN (SELECT COUNT(perPersonId) FROM perFinancial WHERE perPersonId = @personId)					
				WHEN (@tableName = 'PARENT')			THEN (SELECT COUNT(perPersonId) FROM perParent WHERE perPersonId = @personId)
			END

		SELECT @recordCount				
	END
	
	/*แสดงข้อมูลนักศึกษา*/
	IF (@orderTable = 2)
	BEGIN	
		SET @sql = ''
		SET @where = ''
		
		IF (@personId IS NOT NULL AND LEN(@personId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perper.id = "' + @personId + '")'													
		END				

		IF (@studentId IS NOT NULL AND LEN(@studentId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((stdstd.id = "' + @studentId + '") OR (stdstd.studentCode = "' + @studentId + '"))'
		END				
		
		IF (@idCard IS NOT NULL AND LEN(@idCard) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perper.idCard = "' + @idCard + '")'													
		END		
		
		IF (@date IS NOT NULL AND LEN(@date) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perper.birthDate = "' + CONVERT(VARCHAR, CONVERT(DATE, @date, 103)) + '")'
		END		

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
									
		SET @sql = 'SELECT	perper.id, stdstd.id AS studentId, stdstd.studentCode, perper.idCard, perper.thBirthDate, perper.enBirthDate,
							perper.thTitleFullName, perper.thTitleInitials,	perper.enTitleInitials, perper.enTitleFullName,
							perper.firstName, perper.middleName, perper.lastName,
							perper.enFirstName,	perper.enMiddleName, perper.enLastName,
							stddgl.thDegreeLevelName, stddgl.enDegreeLevelName, stdstd.admissionType AS perEntranceTypeId,
							stdstd.facultyId, acafac1.nameTh AS thFacultyName, acafac1.nameEn AS enFacultyName,
							stdstd.programId, acaprg.nameTh AS thProgramName, acaprg.nameEn AS enProgramName,
							stdstd.yearEntry
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id'
														
		SET @sql = @sql + @where
		
		EXEC (@sql)	
	END
	
	/*แสดงข้อมูลส่วนตัว*/
	IF (@orderTable = 3)
	BEGIN		
		SELECT * FROM fnc_perGetListPerson(ISNULL(@personId, ''), '', '')
	END		

	/*แสดงข้อมูลที่อยู่*/
	IF (@orderTable = 4)
	BEGIN		
		SELECT * FROM fnc_perGetListAddress(ISNULL(@personId, ''), '', '')
	END		
	
	/*แสดงข้อมูลการศึกษา*/
	IF (@orderTable = 5)
	BEGIN		
		SELECT * FROM fnc_perGetListEducation(ISNULL(@personId, ''), '', '')
	END		

	/*แสดงข้อมูลความสามารถพิเศษ*/
	IF (@orderTable = 6)
	BEGIN		
		SELECT * FROM fnc_perGetListActivity(ISNULL(@personId, ''), '', '')
	END		

	/*แสดงข้อมูลสุขภาพ*/
	IF (@orderTable = 7)
	BEGIN		
		SELECT * FROM fnc_perGetListHealthy(ISNULL(@personId, ''), '', '')
	END		

	/*แสดงข้อมูลการทำงาน*/
	IF (@orderTable = 8)
	BEGIN		
		SELECT * FROM fnc_perGetListWork(ISNULL(@personId, ''), '', '')
	END
	
	/*แสดงข้อมูลการเงิน*/
	IF (@orderTable = 9)
	BEGIN		
		SELECT * FROM fnc_perGetListFinancial(ISNULL(@personId, ''), '', '')
	END		
	
	/*แสดงข้อมูลรหัสบุคลากรของครอบครัว*/
	IF (@orderTable = 10)
	BEGIN		
		SELECT	perps.id, perpr.perPersonIdFather, perpr.perPersonIdMother, perpr.perPersonIdParent,
				perpr.perRelationshipId, perrs.enRelationshipName
		FROM	fnc_perGetListPerson(ISNULL(@personId, ''), '', '') AS perps LEFT JOIN
				perParent AS perpr ON perps.id = perpr.perPersonId LEFT JOIN
				perRelationship AS perrs ON perpr.perRelationshipId = perrs.id				
	END
	
	/*แสดงข้อมูลครอบครัว*/
	IF (@orderTable = 11)
	BEGIN		
		SELECT * FROM fnc_perGetListPersonParent(ISNULL(@personId, ''), '', '')	
		SELECT * FROM fnc_perGetListAddressParent(ISNULL(@personId, ''), '', '')
		SELECT * FROM fnc_perGetListWorkParent(ISNULL(@personId, ''), '', '')	
	END		

	/*แสดงข้อมูลระดับการศึกษา*/
	IF (@orderTable = 12)
	BEGIN		
		SET @sql = 'SELECT	 id, thEducationalLevelName, enEducationalLevelName
					FROM	 perEducationalLevel
					WHERE	 cancel = "N"
					ORDER BY id'							 
		
		EXEC (@sql)
	END			

	/*แสดงข้อมูลคำนำหน้าชื่อ*/
	IF (@orderTable = 13)
	BEGIN		
		IF (@gender IS NOT NULL AND LEN(@gender) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((pergd.id = "' + @gender + '") OR (pergd.enGenderInitials = "' + @gender + '") OR (pertp.perGenderId IS NULL))'
		END
					
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where

		SET @sql = 'SELECT	 pertp.id, pertp.thTitleFullName, pertp.thTitleInitials, pertp.thDescription,
							 pertp.enTitleFullName, pertp.enTitleInitials, pertp.enDescription, pertp.perGenderId
					FROM	 perTitlePrefix AS pertp LEFT JOIN
							 perGender AS pergd ON pertp.perGenderId = pergd.id
					WHERE	 (pertp.cancel = "N")' + @where + ' ' + '
					ORDER BY pertp.id'
		
		EXEC (@sql)
	END	
		
	/*แสดงข้อมูลเพศ*/
	IF (@orderTable = 14)
	BEGIN		
		SET @sql = 'SELECT	 id, thGenderFullName, thGenderInitials, enGenderFullName, enGenderInitials
					FROM	 perGender
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลประเทศ*/
	IF (@orderTable = 15)
	BEGIN		
		SET @sql = 'SELECT	 id, thCountryName, enCountryName, isoCountryCodes2Letter, isoCountryCodes3Letter
					FROM	 plcCountry
					WHERE	 cancel = "N"
					ORDER BY thCountryName'
		
		EXEC (@sql)
	END		
		
	/*แสดงข้อมูลสัญชาติ*/
	IF (@orderTable = 16)
	BEGIN		
		SET @sql = 'SELECT	 id, thNationalityName, enNationalityName
					FROM	 perNationality
					WHERE	 cancel = "N"
					ORDER BY thNationalityName'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลศาสนา*/
	IF (@orderTable = 17)
	BEGIN		
		SET @sql = 'SELECT   id, thReligionName, enReligionName
					FROM	 perReligion 
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลหมู่เลือด*/
	IF (@orderTable = 18)
	BEGIN		
		SET @sql = 'SELECT	 id, thBloodTypeName, enBloodTypeName
					FROM	 perBloodType
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลสถานภาพทางการสมรส*/
	IF (@orderTable = 19)
	BEGIN		
		SET @sql = 'SELECT	 id, thMaritalStatusName, enMaritalStatusName
					FROM	 perMaritalStatus
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลวุฒิการศึกษา*/
	IF (@orderTable = 20)
	BEGIN		
		IF (@educationalLevelId IS NOT NULL AND LEN(@educationalLevelId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perel.id IN(' + @educationalLevelId + '))'
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where

		SET @sql = 'SELECT	 pereb.id, pereb.thEducationalBackgroundName, pereb.enEducationalBackgroundName,
							 perel.id AS educationalLevelId, perel.thEducationalLevelName, perel.enEducationalLevelName
					FROM	 perEducationalBackground AS pereb INNER JOIN
							 perEducationalLevel AS perel ON pereb.perEducationalLevelId = perel.id
					WHERE	 (pereb.cancel = "N")' + @where + '	' +	'		 
					ORDER BY pereb.id'							 
		
		EXEC (@sql)
	END			
	
	/*แสดงข้อมูลสถานที่*/
	IF (@orderTable = 21)
	BEGIN		
		IF (@countryId IS NOT NULL AND LEN(@countryId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plccut.id = "' + @countryId + '")'													
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where

		SET @sql = 'SELECT	 plccut.id AS countryId, plccut.thCountryName, plccut.enCountryName, plccut.isoCountryCodes2Letter, plccut.isoCountryCodes3Letter,
							 plcprv.id, plcprv.thPlaceName, plcprv.enPlaceName
					FROM	 plcProvince AS plcprv INNER JOIN
							 plcCountry AS plccut ON plcprv.plcCountryId = plccut.id
					WHERE	 (plcprv.cancel = "N")' + @where + ' ' + '
					ORDER BY plcprv.thPlaceName'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลอำเภอ*/
	IF (@orderTable = 22)
	BEGIN		
		IF (@provinceId IS NOT NULL AND LEN(@provinceId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcprv.id = "' + @provinceId + '")'													
		END
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where

		SET @sql = 'SELECT	 plcprv.id AS provinceId, plcprv.thPlaceName, plcprv.enPlaceName,
							 plcdtr.id, plcdtr.thDistrictName, plcdtr.enDistrictName, plcdtr.zipCode
					FROM	 plcDistrict AS plcdtr INNER JOIN
							 plcProvince AS plcprv ON plcdtr.plcProvinceId = plcprv.id
					WHERE	 (plcdtr.cancel = "N")' + @where + ' ' + '
					ORDER BY plcdtr.id'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลตำบล*/
	IF (@orderTable = 23)
	BEGIN		
		IF (@districtId IS NOT NULL AND LEN(@districtId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcdtr.id = "' + @districtId + '")'													
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where
			
		SET @sql = 'SELECT	 plcdtr.id AS districtId, plcdtr.thDistrictName, plcdtr.enDistrictName, plcdtr.zipCode,
							 plcsdt.id, plcsdt.thSubdistrictName, plcsdt.enSubdistrictName
					FROM	 plcSubdistrict AS plcsdt INNER JOIN
							 plcDistrict AS plcdtr ON plcsdt.plcDistrictId = plcdtr.id
					WHERE	 (plcsdt.cancel = "N")' + @where + ' ' + '
					ORDER BY plcsdt.id'
		
		EXEC (@sql)
	END		
		
	/*แสดงข้อมูลสายการเรียน*/
	IF (@orderTable = 24)
	BEGIN		
		SET @sql = 'SELECT	 id, thEducationalMajorName, enEducationalMajorName
					FROM	 perEducationalMajor
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลประเภทการสอบเข้ามหาวิทยาลัยมหิดล*/
	IF (@orderTable = 25)
	BEGIN		
		SET @sql = 'SELECT	 id, thEntranceTypeName, enEntranceTypeName
					FROM	 perEntranceType
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลโรค*/
	IF (@orderTable = 26)
	BEGIN		
		SET @sql = 'SELECT	 id, thDiseasesName, enDiseasesName
					FROM	 perDiseases
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END	

	/*แสดงข้อมูลความบกพร่อง*/
	IF (@orderTable = 27)
	BEGIN		
		SET @sql = 'SELECT	 id, thImpairmentsName, enImpairmentsName
					FROM	 perImpairments
					WHERE	 cancel = "N"
					ORDER BY id'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลต้นสังกัดหน่วยงาน*/
	IF (@orderTable = 28)
	BEGIN		
		SET @sql = 'SELECT	 id, thAgencyName, enAgencyName
					FROM	 perAgency
					WHERE	 cancel = "N"
					ORDER BY thAgencyName'
		
		EXEC (@sql)
	END	

	/*แสดงข้อมูลความสัมพันธ์ในครอบครัว*/
	IF (@orderTable = 29)
	BEGIN		
		IF (@relationshipId IS NOT NULL AND LEN(@relationshipId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perrs.id IN(' + @relationshipId + '))'
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where

		SET @sql = 'SELECT	 perrs.id, perrs.thRelationshipName, perrs.enRelationshipName, perrs.perGenderId	
					FROM	 perRelationship AS perrs LEFT JOIN
							 perGender AS pergd ON perrs.perGenderId = pergd.id
					WHERE	 (perrs.cancel = "N")' + @where + ' ' + '
					ORDER BY perrs.id'					
		
		EXEC (@sql)
	END
	
	--//==============================================================================================================================
	
	/*แสดงข้อมูลสิทธิ์การใช้งานระบบ ตามรหัสผู้ใช้งาน*/
	IF (@orderTable = 30)
	BEGIN		
		SET @sql = 'SELECT	*
					FROM	autUserAccessProgram
					WHERE	(username = "' + @username + '") AND
							(systemGroup = "' + @systemGroup + '")'
					
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	autUserAccessProgram
					WHERE	(username = "' + @username + '") AND
							(level = "' + @userlevel + '") AND
							(systemGroup = "' + @systemGroup + '")'	
							
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลคณะ*/
	IF (@orderTable = 31)
	BEGIN
		IF (@facultyId IS NOT NULL AND LEN(@facultyId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(id = "' + @facultyId + '")'													
		END
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where
						
		SET @sql = 'SELECT	 id, facultyCode, nameTh, nameEn
					FROM	 acaFaculty
					WHERE	 (cancelStatus IS NULL)' + @where + ' ' + '
					ORDER BY id'
					
		EXEC (@sql)
	END  
	
	/*แสดงข้อมูลหลักสูตร*/
	IF (@orderTable = 32)
	BEGIN
		IF (@facultyId IS NOT NULL AND LEN(@facultyId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(acaprg.facultyId = "' + @facultyId + '")'													
		END

		IF (@programId IS NOT NULL AND LEN(@programId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(acaprg.id = "' + @programId + '")'													
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' AND ' + @where	
	
		SET @sql = 'SELECT	 acafac.facultyCode, acaprg.facultyId, acaprg.id, acaprg.majorId,
							 acaprg.programCode, acaprg.majorCode, acaprg.groupNum, acaprg.dLevel, acaprg.nameTh, acaprg.nameEn
					FROM	 acaProgram AS acaprg LEFT JOIN
							 acaFaculty AS acafac ON acaprg.facultyId = acafac.id LEFT JOIN
							 acaMajor AS acamaj ON acaprg.majorId = acamaj.id LEFT JOIN
							 stdDegreeLevel AS stddgl ON acaprg.dLevel = stddgl.id
					WHERE	 (acaprg.cancelStatus IS NULL)' + @where + ' ' + '
					ORDER BY acaprg.id'
					
		EXEC (@sql)
	END

	/*แสดงข้อมูลปีที่เข้าศึกษา*/
	IF (@orderTable = 33)
	BEGIN
		SET @sql = 'SELECT	 yearEntry
					FROM	 stdStudent
					GROUP BY yearEntry
					HAVING	 yearEntry IS NOT NULL
					ORDER BY yearEntry DESC'

		EXEC (@sql)
	END
			
	/*แสดงข้อมูลสถานภาพการเป็นนักศึกษา*/
	IF (@orderTable = 34)
	BEGIN
		SET @sql = 'SELECT	 id, nameTh, nameEn
					FROM	 stdStatusType
					WHERE	 cancelStatus IS NULL
					ORDER BY id'
					
		EXEC (@sql)
	END	

	/*แสดงข้อมูลนักศึกษา ของระบบจัดการข้อมูลระเบียนประวัตินักศึกษา*/
	IF (@orderTable = 35)
	BEGIN
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "Student ID"	THEN "stdstd.studentCode"
				WHEN "Name"			THEN "perper.firstName"
				WHEN "Faculty"		THEN "stdstd.facultyId"
				WHEN "Program"		THEN "stdstd.programId"
				WHEN "Year Entry"	THEN "stdstd.yearEntry"
				ELSE "stdstd.studentCode"		
			END
					
		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((stdstd.studentCode LIKE "%' + @keyword + '%") OR
						   ((ISNULL(perper.thTitleFullName, "") + ISNULL(perper.thTitleInitials, "") + ISNULL(perper.enTitleInitials, "") + ISNULL(perper.enTitleFullName, "")) LIKE "%' + @keyword + '%") OR
						   ((ISNULL(perper.firstName, "") + ISNULL(perper.middleName, "") + ISNULL(perper.lastName, "")) LIKE "%' + @keyword + '%") OR
						   ((ISNULL(perper.enFirstName, "") + ISNULL(perper.enMiddleName, "") + ISNULL(perper.enLastName, "")) LIKE "%' + @keyword + '%"))'
		END				
		
		IF (@facultyId IS NOT NULL AND LEN(@facultyId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdstd.facultyId = "' + @facultyId + '")'													
		END		
		
		IF (@programId IS NOT NULL AND LEN(@programId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdstd.programId = "' + @programId + '")'													
		END

		IF (@yearAttended IS NOT NULL AND LEN(@yearAttended) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdstd.yearEntry = "' + @yearAttended + '")'
		END
		
		IF (@entranceTypeId IS NOT NULL AND LEN(@entranceTypeId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdstd.admissionType = "' + @entranceTypeId + '")'													
		END

		IF (@studentStatusId IS NOT NULL AND LEN(@studentStatusId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdstd.status = "' + @studentStatusId + '")'													
		END
		
		IF (@studentRecordsStatus IS NOT NULL AND LEN(@studentRecordsStatus) > 0)
		BEGIN
			IF (@studentRecordsStatus = 'Y' OR @studentRecordsStatus = 'N')
			BEGIN			
				IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
				SET @where = @where + '((
										 ISNULL(countPerson.countID, 0) +
										 ISNULL(countAddress.countID, 0) +
										 ISNULL(countEducation.countID, 0) +
										 ISNULL(countActivity.countID, 0) +
										 ISNULL(countHealthy.countID, 0) +
										 ISNULL(countWork.countID, 0) +
										 ISNULL(countFinancial.countID, 0) +
										 ISNULL(countParent.countID, 0)
									    )'
				
				IF (@studentRecordsStatus = 'Y') SET @where = @where + ' = 8)'
				IF (@studentRecordsStatus = 'N') SET @where = @where + ' < 8)'
			END											
		END												

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
											
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									perper.id AS personId, stdstd.id AS studentId, stdstd.studentCode, perper.idCard, perper.thBirthDate, perper.enBirthDate,
									perper.thTitleFullName, perper.thTitleInitials,	perper.enTitleInitials, perper.enTitleFullName,
									perper.firstName, perper.middleName, perper.lastName,
									perper.enFirstName,	perper.enMiddleName, perper.enLastName,
									stddgl.thDegreeLevelName, stddgl.enDegreeLevelName,
									stdstd.facultyId, acafac1.facultyCode, acafac1.nameTh AS thFacultyName, acafac1.nameEn AS enFacultyName,
									stdstd.programId, acaprg.programCode, acaprg.majorCode, acaprg.groupNum, acaprg.nameTh AS thProgramName, acaprg.nameEn AS enProgramName,
									stdstd.yearEntry, stdstd.admissionType AS perEntranceTypeId, perent.thEntranceTypeName, perent.enEntranceTypeName,
									stdstd.status AS stdStatusTypeId, stdstt.nameTh AS thStatusTypeName, stdstt.nameEn AS enStatusTypeName,
									ISNULL(countPerson.countID, 0) AS countPerson,
									ISNULL(countAddress.countID, 0) AS countAddress,
									ISNULL(countEducation.countID, 0) AS countEducation,
									ISNULL(countActivity.countID, 0) AS countActivity,
									ISNULL(countHealthy.countID, 0) AS countHealthy,
									ISNULL(countWork.countID, 0) AS countWork,
									ISNULL(countFinancial.countID, 0) AS countFinancial,
									ISNULL(countParent.countID, 0) AS countParent,
									(
										ISNULL(countPerson.countID, 0) +
										ISNULL(countAddress.countID, 0) +
										ISNULL(countEducation.countID, 0) +
										ISNULL(countActivity.countID, 0) +
										ISNULL(countHealthy.countID, 0) +
										ISNULL(countWork.countID, 0) +
										ISNULL(countFinancial.countID, 0) +
										ISNULL(countParent.countID, 0)
									) AS countStudentRecords
							 FROM	' + @studentJoin + ' 
									fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id LEFT JOIN
									(SELECT id, COUNT(id) AS countID FROM perPerson GROUP BY id) AS countPerson ON perper.id = countPerson.id LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perAddress GROUP BY perPersonId) AS countAddress ON perper.id = countAddress.perPersonId LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perEducation GROUP BY perPersonId) AS countEducation ON perper.id = countEducation.perPersonId LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perActivity GROUP BY perPersonId) AS countActivity ON perper.id = countActivity.perPersonId LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perHealthy GROUP BY perPersonId) AS countHealthy ON perper.id = countHealthy.perPersonId LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perWork GROUP BY perPersonId) AS countWork ON perper.id = countWork.perPersonId LEFT JOIN
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perFinancial GROUP BY perPersonId) AS countFinancial ON perper.id = countFinancial.perPersonId LEFT JOIN				
									(SELECT perPersonId, COUNT(perPersonId) AS countID FROM perParent GROUP BY perPersonId) AS countParent ON perper.id = countParent.perPersonId' +
							 @where + ') AS stdstd'
		 
		EXEC (@sql)
		
		SET @sql = 'SELECT	COUNT(perper.id)
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson("", "", "") AS perper ON stdstd.personId = perper.id'
		 
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลส่วนตัวและรหัสนักศึกษา*/
	IF (@orderTable = 36)
	BEGIN		
		SET @sql = 'SELECT	perper.*, stdstd.id AS studentId, stdstd.studentCode,							
							stddgl.thDegreeLevelName, stddgl.enDegreeLevelName,
							acafac1.nameTh AS thFacultyName, acafac1.nameEn AS enFacultyName,
							acaprg.nameTh AS thProgramName, acaprg.nameEn AS enProgramName,
							stdstt.nameTh AS thStatusTypeName, stdstt.nameEn AS enStatusTypeName,
							stdstd.yearEntry, perent.thEntranceTypeName, perent.enEntranceTypeName,
							stdpic.FolderName AS folderPictureName, stdpic.FileName AS profilePictureName
					FROM	' + @studentJoin + ' 
							fnc_perGetListPerson(ISNULL("' + @personId + '", ""), "", "") AS perper ON stdstd.personId = perper.id LEFT JOIN
							MUStudent..SPictureLookup AS stdpic ON stdstd.studentCode = stdpic.StudentID'
									 
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลคำนำหน้าชื่อ*/	
	IF (@orderTable = 37)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "pertp.id"
				WHEN "Full Name ( TH )"	THEN "pertp.thTitleFullName"
				WHEN "Initials ( TH )"	THEN "pertp.thTitleInitials"
				WHEN "Full Name ( EN )"	THEN "pertp.enTitleFullName"
				WHEN "Initials ( EN )"	THEN "pertp.enTitleInitials"
				WHEN "Gender"			THEN "pergd.enGenderInitials"
				WHEN "Cancel"			THEN "pertp.cancel"
				WHEN "Create Date"		THEN "pertp.createDate"
				WHEN "Modify Date"		THEN "pertp.modifyDate"
				ELSE "pertp.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((pertp.id LIKE "%' + @keyword + '%") OR
						   (pertp.thTitleFullName LIKE "%' + @keyword + '%") OR
						   (pertp.thTitleInitials LIKE "%' + @keyword + '%") OR
						   (pertp.thDescription LIKE "%' + @keyword + '%") OR
						   (pertp.enTitleFullName LIKE "%' + @keyword + '%") OR
						   (pertp.enTitleInitials LIKE "%' + @keyword + '%") OR
						   (pertp.enDescription LIKE "%' + @keyword + '%"))'
		END

		IF (@gender IS NOT NULL AND LEN(@gender) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((pergd.id = "' + @gender + '") OR (pertp.perGenderId IS NULL))'
		END
		
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(pertp.cancel = "' + @cancelStatus + '")'
		END	
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where

		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									pertp.id, pertp.thTitleFullName, pertp.thTitleInitials, pertp.thDescription,
									pertp.enTitleFullName, pertp.enTitleInitials, pertp.enDescription, pertp.perGenderId, 
									pergd.thGenderFullName, pergd.thGenderInitials, pergd.enGenderFullName, pergd.enGenderInitials,
									pertp.cancel, pertp.createDate, pertp.modifyDate
							 FROM	perTitlePrefix AS pertp LEFT JOIN
									perGender AS pergd ON pertp.perGenderId = pergd.id' +
							 @where + ') AS pertp'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	COUNT(pertp.id)
					FROM	perTitlePrefix AS pertp LEFT JOIN
							perGender AS pergd ON pertp.perGenderId = pergd.id'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลเพศ*/
	IF (@orderTable = 38)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "pergd.id"
				WHEN "Full Name ( TH )"	THEN "pergd.thGenderFullName"
				WHEN "Initials ( TH )"	THEN "pergd.thGenderInitials"
				WHEN "Full Name ( EN )"	THEN "pergd.enGenderFullName"
				WHEN "Initials ( EN )"	THEN "pergd.enGenderInitials"
				WHEN "Cancel"			THEN "pergd.cancel"
				WHEN "Create Date"		THEN "pergd.createDate"
				WHEN "Modify Date"		THEN "pergd.modifyDate"
				ELSE "pergd.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((pergd.id LIKE "%' + @keyword + '%") OR
						   (pergd.thGenderFullName LIKE "%' + @keyword + '%") OR
						   (pergd.thGenderInitials LIKE "%' + @keyword + '%") OR
						   (pergd.enGenderFullName LIKE "%' + @keyword + '%") OR
						   (pergd.enGenderInitials LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(pergd.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where	
	
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 pergd.id, pergd.thGenderFullName, pergd.thGenderInitials, pergd.enGenderFullName, pergd.enGenderInitials,
									 pergd.cancel, pergd.createDate, pergd.modifyDate
							  FROM	 perGender AS pergd' +
							  @where + ') AS pergd'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(pergd.id)
					FROM	 perGender AS pergd'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลสัญชาติ*/
	IF (@orderTable = 39)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perna.id"
				WHEN "Full Name ( TH )"	THEN "perna.thNationalityName"
				WHEN "Full Name ( EN )"	THEN "perna.enNationalityName"
				WHEN "ISO ALPHA-2"		THEN "perna.isoCountryCodes2Letter"
				WHEN "ISO ALPHA-3"		THEN "perna.isoCountryCodes3Letter"
				WHEN "Cancel"			THEN "perna.cancel"
				WHEN "Create Date"		THEN "perna.createDate"
				WHEN "Modify Date"		THEN "perna.modifyDate"
				ELSE "perna.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perna.id LIKE "%' + @keyword + '%") OR
						   (perna.thNationalityName LIKE "%' + @keyword + '%") OR
						   (perna.enNationalityName LIKE "%' + @keyword + '%") OR
						   (perna.isoCountryCodes2Letter LIKE "%' + @keyword + '%") OR
						   (perna.isoCountryCodes3Letter LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perna.cancel = "' + @cancelStatus + '")'
		END		
	
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where	
	
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,	
									 perna.id, perna.thNationalityName, perna.enNationalityName, perna.isoCountryCodes2Letter, perna.isoCountryCodes3Letter,
									 perna.cancel, perna.createDate, perna.modifyDate
							  FROM	 perNationality AS perna' +
							  @where + ') AS perna'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perna.id)
					FROM	 perNationality AS perna'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลศาสนา*/
	IF (@orderTable = 40)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perrg.id"
				WHEN "Full Name ( TH )"	THEN "perrg.thReligionName"
				WHEN "Full Name ( EN )"	THEN "perrg.enReligionName"
				WHEN "Cancel"			THEN "perrg.cancel"
				WHEN "Create Date"		THEN "perrg.createDate"
				WHEN "Modify Date"		THEN "perrg.modifyDate"
				ELSE "perrg.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perrg.id LIKE "%' + @keyword + '%") OR
						   (perrg.thReligionName LIKE "%' + @keyword + '%") OR
						   (perrg.enReligionName LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perrg.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,	
									 perrg.id, perrg.thReligionName, perrg.enReligionName,
									 perrg.cancel, perrg.createDate, perrg.modifyDate
							  FROM	 perReligion AS perrg' +
							  @where + ') AS perrg'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perrg.id)
					FROM	 perReligion AS perrg'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลหมู่เลือด*/
	IF (@orderTable = 41)
	BEGIN
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perbt.id"
				WHEN "Full Name ( TH )"	THEN "perbt.thBloodTypeName"
				WHEN "Full Name ( EN )"	THEN "perbt.enBloodTypeName"
				WHEN "Cancel"			THEN "perbt.cancel"
				WHEN "Create Date"		THEN "perbt.createDate"
				WHEN "Modify Date"		THEN "perbt.modifyDate"
				ELSE "perbt.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perbt.id LIKE "%' + @keyword + '%") OR
						   (perbt.thBloodTypeName LIKE "%' + @keyword + '%") OR
						   (perbt.enBloodTypeName LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perbt.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perbt.id, perbt.thBloodTypeName, perbt.enBloodTypeName,
									 perbt.cancel, perbt.createDate, perbt.modifyDate
							  FROM	 perBloodType AS perbt' +
							  @where + ') AS perbt'
		
		EXEC (@sql)

		SET @sql = 'SELECT	 COUNT(perbt.id)
					FROM	 perBloodType AS perbt'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลสถานภาพทางการสมรส*/
	IF (@orderTable = 42)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perms.id"
				WHEN "Full Name ( TH )"	THEN "perms.thMaritalStatusName"
				WHEN "Full Name ( EN )"	THEN "perms.enMaritalStatusName"
				WHEN "Cancel"			THEN "perms.cancel"
				WHEN "Create Date"		THEN "perms.createDate"
				WHEN "Modify Date"		THEN "perms.modifyDate"
				ELSE "perms.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perms.id LIKE "%' + @keyword + '%") OR
						   (perms.thMaritalStatusName LIKE "%' + @keyword + '%") OR
						   (perms.enMaritalStatusName LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perms.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perms.id, perms.thMaritalStatusName, perms.enMaritalStatusName,
									 perms.cancel, perms.createDate, perms.modifyDate
							  FROM	 perMaritalStatus AS perms' +
							  @where + ') AS perms'
							  
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perms.id)
					FROM	 perMaritalStatus AS perms'							  
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลความสัมพันธ์ในครอบครัว*/
	IF (@orderTable = 43)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perrs.id"
				WHEN "Full Name ( TH )"	THEN "perrs.thRelationshipName"
				WHEN "Full Name ( EN )"	THEN "perrs.enRelationshipName"
				WHEN "Gender"			THEN "pergd.enGenderInitials"
				WHEN "Cancel"			THEN "perrs.cancel"
				WHEN "Create Date"		THEN "perrs.createDate"
				WHEN "Modify Date"		THEN "perrs.modifyDate"
				ELSE "perrs.id"			
			END
			
		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perrs.id LIKE "%' + @keyword + '%") OR
						   (perrs.thRelationshipName LIKE "%' + @keyword + '%") OR
						   (perrs.enRelationshipName LIKE "%' + @keyword + '%"))'
		END

		IF (@gender IS NOT NULL AND LEN(@gender) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '((pergd.id = "' + @gender + '") OR (perrs.perGenderId IS NULL))'
		END
		
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perrs.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perrs.id, perrs.thRelationshipName, perrs.enRelationshipName,
									 perrs.perGenderId, pergd.enGenderInitials,
									 perrs.cancel, perrs.createDate, perrs.modifyDate
							  FROM	 perRelationship AS perrs LEFT JOIN
									 perGender AS pergd ON perrs.perGenderId = pergd.id' +
							  @where + ') AS perrs'
				
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perrs.id)
					FROM	 perRelationship AS perrs LEFT JOIN
							 perGender AS pergd ON perrs.perGenderId = pergd.id'
				
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลต้นสังกัดหน่วยงาน*/
	IF (@orderTable = 44)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perag.id"
				WHEN "Full Name ( TH )"	THEN "perag.thAgencyName"
				WHEN "Full Name ( EN )"	THEN "perag.enAgencyName"
				WHEN "Cancel"			THEN "perag.cancel"
				WHEN "Create Date"		THEN "perag.createDate"
				WHEN "Modify Date"		THEN "perag.modifyDate"
				ELSE "perag.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perag.id LIKE "%' + @keyword + '%") OR
						   (perag.thAgencyName LIKE "%' + @keyword + '%") OR
						   (perag.enAgencyName LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perag.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perag.id, perag.thAgencyName, perag.enAgencyName,
									 perag.cancel, perag.createDate, perag.modifyDate
							  FROM	 perAgency AS perag' +
							  @where + ') AS perag'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perag.id)
					FROM	 perAgency AS perag'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลระดับการศึกษา*/
	IF (@orderTable = 45)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "perel.id"
				WHEN "Full Name ( TH )"	THEN "perel.thEducationalLevelName"
				WHEN "Full Name ( EN )"	THEN "perel.enEducationalLevelName"
				WHEN "Cancel"			THEN "perel.cancel"
				WHEN "Create Date"		THEN "perel.createDate"
				WHEN "Modify Date"		THEN "perel.modifyDate"
				ELSE "perel.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perel.id LIKE "%' + @keyword + '%") OR
						   (perel.thEducationalLevelName LIKE "%' + @keyword + '%") OR
						   (perel.enEducationalLevelName LIKE "%' + @keyword + '%"))'
		END
	
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perel.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perel.id, perel.thEducationalLevelName, perel.enEducationalLevelName,
									 perel.cancel, perel.createDate, perel.modifyDate
							  FROM	 perEducationalLevel AS perel' +
							  @where + ') AS perel'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perel.id)
					FROM	 perEducationalLevel AS perel'
		
		EXEC (@sql)
	END				
	
	/*แสดงข้อมูลวุฒิการศึกษา*/
	IF (@orderTable = 46)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"						THEN "pereb.id"
				WHEN "Full Name ( TH )"			THEN "pereb.thEducationalBackgroundName"
				WHEN "Educational Level ( TH )"	THEN "perel.thEducationalLevelName"
				WHEN "Full Name ( EN )"			THEN "pereb.enEducationalBackgroundName"				
				WHEN "Educational Level ( EN )"	THEN "perel.enEducationalLevelName"
				WHEN "Cancel"					THEN "pereb.cancel"
				WHEN "Create Date"				THEN "pereb.createDate"
				WHEN "Modify Date"				THEN "pereb.modifyDate"
				ELSE "pereb.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((pereb.id LIKE "%' + @keyword + '%") OR
						   (pereb.thEducationalBackgroundName LIKE "%' + @keyword + '%") OR
						   (pereb.enEducationalBackgroundName LIKE "%' + @keyword + '%"))'
		END

		IF (@educationalLevelId IS NOT NULL AND LEN(@educationalLevelId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perel.id = "' + @educationalLevelId + '")'
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(pereb.cancel = "' + @cancelStatus + '")'
		END	
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 pereb.id, pereb.thEducationalBackgroundName, pereb.enEducationalBackgroundName,
									 pereb.perEducationalLevelId, perel.thEducationalLevelName, perel.enEducationalLevelName,
									 pereb.cancel, pereb.createDate, pereb.modifyDate
							  FROM	 perEducationalBackground AS pereb INNER JOIN
									 perEducationalLevel AS perel ON pereb.perEducationalLevelId = perel.id' +
							  @where + ') AS pereb'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(pereb.id)
					FROM	 perEducationalBackground AS pereb INNER JOIN
							 perEducationalLevel AS perel ON pereb.perEducationalLevelId = perel.id'
							 		
		EXEC (@sql)
	END			
	
	/*แสดงข้อมูลสายการเรียน*/
	IF (@orderTable = 47)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"						THEN "perem.id"
				WHEN "Full Name ( TH )"			THEN "perem.thEducationalMajorName"
				WHEN "Full Name ( EN )"			THEN "perem.enEducationalMajorName"
				WHEN "Cancel"					THEN "perem.cancel"
				WHEN "Create Date"				THEN "perem.createDate"
				WHEN "Modify Date"				THEN "perem.modifyDate"
				ELSE "perem.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perem.id LIKE "%' + @keyword + '%") OR
						   (perem.thEducationalMajorName LIKE "%' + @keyword + '%") OR
						   (perem.enEducationalMajorName LIKE "%' + @keyword + '%"))'
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perem.cancel = "' + @cancelStatus + '")'
		END	

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perem.id, perem.thEducationalMajorName, perem.enEducationalMajorName,
									 perem.cancel, perem.createDate, perem.modifyDate
							  FROM	 perEducationalMajor AS perem' +
							  @where + ') AS perem'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perem.id)
					FROM	 perEducationalMajor AS perem'
							
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลประเภทการสอบเข้ามหาวิทยาลัยมหิดล*/
	IF (@orderTable = 48)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"						THEN "peret.id"
				WHEN "Full Name ( TH )"			THEN "peret.thEntranceTypeName"
				WHEN "Full Name ( EN )"			THEN "peret.enEntranceTypeName"
				WHEN "Cancel"					THEN "peret.cancel"
				WHEN "Create Date"				THEN "peret.createDate"
				WHEN "Modify Date"				THEN "peret.modifyDate"
				ELSE "peret.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((peret.id LIKE "%' + @keyword + '%") OR
						   (peret.thEntranceTypeName LIKE "%' + @keyword + '%") OR
						   (peret.enEntranceTypeName LIKE "%' + @keyword + '%"))'
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(peret.cancel = "' + @cancelStatus + '")'
		END
			
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 peret.id, peret.thEntranceTypeName, peret.enEntranceTypeName,
									 peret.cancel, peret.createDate, peret.modifyDate
							  FROM	 perEntranceType AS peret' +
							  @where + ') AS peret'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(peret.id)
					FROM	 perEntranceType AS peret'
		
		EXEC (@sql)
	END			
	
	/*แสดงข้อมูลสถานภาพการเป็นนักศึกษา*/
	IF (@orderTable = 49)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"						THEN "stdst.id"
				WHEN "Full Name ( TH )"			THEN "stdst.nameTh"
				WHEN "Full Name ( EN )"			THEN "stdst.nameEn"
				WHEN "Cancel"					THEN "stdst.cancelStatus"
				WHEN "Create Date"				THEN "stdst.createdDate"				
				ELSE "stdst.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((stdst.id LIKE "%' + @keyword + '%") OR
						   (stdst.nameTh LIKE "%' + @keyword + '%") OR
						   (stdst.nameEn LIKE "%' + @keyword + '%"))'
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(stdst.cancelStatus = "' + @cancelStatus + '")'
		END
			
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 stdst.id, stdst.nameTh, stdst.nameEn,
									 stdst.cancelStatus, stdst.createdDate
							  FROM	 stdStatusType AS stdst' +
							  @where + ') AS stdst'

		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(stdst.id)
					FROM	 stdStatusType AS stdst'

		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลประเทศ*/
	IF (@orderTable = 50)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "plcco.id"
				WHEN "Full Name ( TH )"	THEN "plcco.thCountryName"
				WHEN "Full Name ( EN )"	THEN "plcco.enCountryName"
				WHEN "ISO ALPHA-2"		THEN "plcco.isoCountryCodes2Letter"
				WHEN "ISO ALPHA-3"		THEN "plcco.isoCountryCodes3Letter"
				WHEN "Cancel"			THEN "plcco.cancel"
				WHEN "Create Date"		THEN "plcco.createDate"
				WHEN "Modify Date"		THEN "plcco.modifyDate"
				ELSE "plcco.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((plcco.id LIKE "%' + @keyword + '%") OR
						   (plcco.thCountryName LIKE "%' + @keyword + '%") OR
						   (plcco.enCountryName LIKE "%' + @keyword + '%") OR
						   (plcco.isoCountryCodes2Letter LIKE "%' + @keyword + '%") OR
						   (plcco.isoCountryCodes3Letter LIKE "%' + @keyword + '%"))'
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcco.cancel = "' + @cancelStatus + '")'
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,					
									 plcco.id, plcco.thCountryName, plcco.enCountryName, plcco.isoCountryCodes2Letter, plcco.isoCountryCodes3Letter,
									 plcco.cancel, plcco.createDate, plcco.modifyDate
							  FROM	 plcCountry AS plcco' +
							  @where + ') AS plcco'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(plcco.id)
					FROM	 plcCountry AS plcco'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลสถานที่*/
	IF (@orderTable = 51)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"				THEN "plcpv.id"
				WHEN "Country"			THEN "plcco.isoCountryCodes3Letter"
				WHEN "Full Name ( TH )"	THEN "plcpv.thPlaceName"
				WHEN "Full Name ( EN )"	THEN "plcpv.enPlaceName"				
				WHEN "Cancel"			THEN "plcpv.cancel"
				WHEN "Create Date"		THEN "plcpv.createDate"
				WHEN "Modify Date"		THEN "plcpv.modifyDate"
				ELSE "plcpv.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((plcpv.id LIKE "%' + @keyword + '%") OR
						   (plcpv.thPlaceName LIKE "%' + @keyword + '%") OR
						   (plcpv.enPlaceName LIKE "%' + @keyword + '%"))'
		END
		
		IF (@countryId IS NOT NULL AND LEN(@countryId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcpv.plcCountryId = "' + @countryId + '")'													
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcpv.cancel = "' + @cancelStatus + '")'
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 plcpv.id, plcpv.plcCountryId, plcco.isoCountryCodes3Letter, plcpv.thPlaceName, plcpv.enPlaceName,
									 plcpv.cancel, plcpv.createDate, plcpv.modifyDate
							  FROM	 plcProvince AS plcpv INNER JOIN
									 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id' +
							  @where + ') AS plcpv'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(plcpv.id)
					FROM	 plcProvince AS plcpv INNER JOIN
							 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id'
		
		EXEC (@sql)
	END	
	
	/*แสดงข้อมูลอำเภอ*/
	IF (@orderTable = 52)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"					THEN "plcdi.id"
				WHEN "Country"				THEN "plcco.isoCountryCodes3Letter"
				WHEN "Province ( TH )"		THEN "plcpv.thPlaceName"
				WHEN "Full Name ( TH )"		THEN "plcdi.thDistrictName"
				WHEN "Province ( EN )"		THEN "plcpv.enPlaceName"				
				WHEN "Full Name ( EN )"		THEN "plcdi.enDistrictName"	
				WHEN "ZIP / Postal Code"	THEN "plcdi.zipCode"
				WHEN "Cancel"				THEN "plcpv.cancel"
				WHEN "Create Date"			THEN "plcpv.createDate"
				WHEN "Modify Date"			THEN "plcpv.modifyDate"
				ELSE "plcdi.id"			
			END
            
		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((plcdi.id LIKE "%' + @keyword + '%") OR
						   (plcdi.thDistrictName LIKE "%' + @keyword + '%") OR
						   (plcdi.enDistrictName LIKE "%' + @keyword + '%") OR
						   (plcdi.zipCode LIKE "%' + @keyword + '%")) '
		END

		IF (@countryId IS NOT NULL AND LEN(@countryId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcpv.plcCountryId = "' + @countryId + '")'													
		END
				
		IF (@provinceId IS NOT NULL AND LEN(@provinceId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcdi.plcProvinceId = "' + @provinceId + '")'													
		END
		
		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcdi.cancel = "' + @cancelStatus + '")'
		END		
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 plcdi.id, plcpv.plcCountryId, plcco.isoCountryCodes3Letter, 
									 plcdi.plcProvinceId, plcpv.thPlaceName, plcpv.enPlaceName,
									 plcdi.thDistrictName, plcdi.enDistrictName, plcdi.zipCode,
									 plcdi.cancel, plcdi.createDate, plcdi.modifyDate
							  FROM	 plcDistrict AS plcdi INNER JOIN
									 plcProvince AS plcpv ON plcdi.plcProvinceId = plcpv.id INNER JOIN
									 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id' + 
							  @where + ') AS plcdi'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(plcdi.id)
					FROM	 plcDistrict AS plcdi INNER JOIN
							 plcProvince AS plcpv ON plcdi.plcProvinceId = plcpv.id INNER JOIN
							 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id'
		
		EXEC (@sql)
	END
	
	/*แสดงข้อมูลตำบล*/
	IF (@orderTable = 53)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"						THEN "plcsd.id"
				WHEN "Country"					THEN "plcco.isoCountryCodes3Letter"
				WHEN "Province ( TH )"			THEN "plcpv.thPlaceName"
				WHEN "District / Area ( TH )"	THEN "plcdi.thDistrictName"
				WHEN "Full Name ( TH )"			THEN "plcsd.thSubdistrictName"
				WHEN "Province ( EN )"			THEN "plcpv.enPlaceName"	
				WHEN "District / Area ( EN )"	THEN "plcdi.enDistrictName"
				WHEN "Full Name ( EN )"			THEN "plcsd.enSubdistrictName"	
				WHEN "ZIP / Postal Code"		THEN "plcdi.zipCode"
				WHEN "Cancel"					THEN "plcsd.cancel"
				WHEN "Create Date"				THEN "plcsd.createDate"
				WHEN "Modify Date"				THEN "plcsd.modifyDate"
				ELSE "plcsd.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((plcsd.id LIKE "%' + @keyword + '%") OR
						   (plcsd.thSubdistrictName LIKE "%' + @keyword + '%") OR
						   (plcsd.enSubdistrictName LIKE "%' + @keyword + '%") OR
						   (plcdi.zipCode LIKE "%' + @keyword + '%")) '
		END
		
		IF (@countryId IS NOT NULL AND LEN(@countryId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcpv.plcCountryId = "' + @countryId + '")'													
		END
				
		IF (@provinceId IS NOT NULL AND LEN(@provinceId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcdi.plcProvinceId = "' + @provinceId + '")'													
		END

		IF (@districtId IS NOT NULL AND LEN(@districtId) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcsd.plcDistrictId = "' + @districtId + '")'													
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(plcsd.cancel = "' + @cancelStatus + '")'
		END
		
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,			
									 plcsd.id, plcpv.plcCountryId, plcco.isoCountryCodes3Letter, 
									 plcdi.plcProvinceId, plcpv.thPlaceName, plcpv.enPlaceName,
									 plcsd.plcDistrictId, plcdi.thDistrictName, plcdi.enDistrictName, plcdi.zipCode,				
									 plcsd.thSubdistrictName, plcsd.enSubdistrictName,
									 plcsd.cancel, plcsd.createDate, plcsd.modifyDate
							  FROM	 plcSubdistrict AS plcsd INNER JOIN
									 plcDistrict AS plcdi ON plcsd.plcDistrictId = plcdi.id INNER JOIN
									 plcProvince AS plcpv ON plcdi.plcProvinceId = plcpv.id INNER JOIN
									 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id' +
							  @where + ') AS plcsd'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(plcsd.id)
					FROM	 plcSubdistrict AS plcsd INNER JOIN
							 plcDistrict AS plcdi ON plcsd.plcDistrictId = plcdi.id INNER JOIN
							 plcProvince AS plcpv ON plcdi.plcProvinceId = plcpv.id INNER JOIN
							 plcCountry AS plcco ON plcpv.plcCountryId = plcco.id'
							 		
		EXEC (@sql)
	END			
	
	/*แสดงข้อมูลโรค*/
	IF (@orderTable = 54)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"					THEN "perdi.id"
				WHEN "Full Name ( TH )"		THEN "perdi.thDiseasesName"
				WHEN "Full Name ( EN )"		THEN "perdi.enDiseasesName"
				WHEN "Cancel"				THEN "perdi.cancel"
				WHEN "Create Date"			THEN "perdi.createDate"	
				WHEN "Modify Date"			THEN "perdi.modifyDate"
				ELSE "perdi.id"			
			END

		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perdi.id LIKE "%' + @keyword + '%") OR
						   (perdi.thDiseasesName LIKE "%' + @keyword + '%") OR
						   (perdi.enDiseasesName LIKE "%' + @keyword + '%")) '
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perdi.cancel = "' + @cancelStatus + '")'
		END

		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,		
									 perdi.id, perdi.thDiseasesName, perdi.enDiseasesName,
									 perdi.cancel, perdi.createDate, perdi.modifyDate
							  FROM	 perDiseases AS perdi' +
							  @where + ') AS perdi'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perdi.id)
					FROM	 perDiseases AS perdi'
		
		EXEC (@sql)
	END		
	
	/*แสดงข้อมูลความบกพร่อง*/
	IF (@orderTable = 55)
	BEGIN		
		SET @sortOrderBy =
			CASE @sortOrderBy
				WHEN "ID"					THEN "perim.id"
				WHEN "Full Name ( TH )"		THEN "perim.thImpairmentsName"
				WHEN "Full Name ( EN )"		THEN "perim.enImpairmentsName"
				WHEN "Cancel"				THEN "perim.cancel"
				WHEN "Create Date"			THEN "perim.createDate"	
				WHEN "Modify Date"			THEN "perim.modifyDate"
				ELSE "perim.id"			
			END	
	
		IF (@keyword IS NOT NULL AND LEN(@keyword) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where +
						 '((perim.id LIKE "%' + @keyword + '%") OR
						   (perim.thImpairmentsName LIKE "%' + @keyword + '%") OR
						   (perim.enImpairmentsName LIKE "%' + @keyword + '%")) '
		END

		IF (@cancelStatus IS NOT NULL AND LEN(@cancelStatus) > 0)
		BEGIN
			IF (@where IS NOT NULL AND LEN(@where) > 0) SET @where = @where + ' AND '
			SET @where = @where + '(perim.cancel = "' + @cancelStatus + '")'
		END
	
		IF (@where IS NOT NULL AND LEN(@where) > 0)
			SET @where = ' WHERE ' + @where
				
		SET @sql = 'SELECT	 *
					FROM	 (SELECT ROW_NUMBER() OVER(ORDER BY (' + @sortOrderBy + ') ' + @sortExpression + ') AS rowNum,
									 perim.id, perim.thImpairmentsName, perim.enImpairmentsName,
									 perim.cancel, perim.createDate, perim.modifyDate
							  FROM	 perImpairments AS perim' +
							  @where + ') AS perim'
		
		EXEC (@sql)
		
		SET @sql = 'SELECT	 COUNT(perim.id)
					FROM	 perImpairments AS perim'
		
		EXEC (@sql)
	END	
END	