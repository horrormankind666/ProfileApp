USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListPerson]    Script Date: 05/21/2015 13:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๕/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perPerson ครั้งละหลายเรคคอร์ด>
--  1. order						เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id 							เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. idCard						เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  4. perTitlePrefixId				เป็น VARCHAR	รับค่ารหัสคำนำหน้าชื่อ
--  5. firstName					เป็น NVARCHAR	รับค่าชื่อ
--  6. middleName					เป็น NVARCHAR	รับค่าชื่อกลาง
--  7. lastName						เป็น NVARCHAR	รับค่านามสกุล
--  8. enFirstName					เป็น NVARCHAR	รับค่าชื่อภาษาอังกฤษ
--  9. enMiddleName					เป็น NVARCHAR	รับค่าชื่อกลางภาษาอังกฤษ
-- 10. enLastName					เป็น NVARCHAR	รับค่านามสกุลภาษาอังกฤษ
-- 11. perGenderId					เป็น VARCHAR	รับค่ารหัสเพศ
-- 12. alive						เป็น VARCHAR	รับค่าสถานะการมีชีวิต
-- 13. birthDate					เป็น VARCHAR	รับค่าวันเกิด
-- 14. plcCountryId 				เป็น VARCHAR	รับค่ารหัสประเทศบ้านเกิด
-- 15. perNationalityId 			เป็น VARCHAR	รับค่ารหัสสัญชาติ
-- 16. perOriginId 					เป็น VARCHAR	รับค่ารหัสเชื้อชาติ
-- 17. perReligionId 				เป็น VARCHAR	รับค่ารหัสศาสนา
-- 18. perBloodTypeId				เป็น VARCHAR	รับค่ารหัสหมู่เลือด
-- 19. perMaritalStatusId			เป็น VARCHAR	รับค่ารหัสสถานะภาพการสมรส
-- 20. perEducationalBackgroundId	เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษา
-- 21. email						เป็น NVARCHAR	รับค่าอีเมล์
-- 22. brotherhoodNumber			เป็น VARCHAR	รับค่าจำนวนพี่น้อง
-- 23. childhoodNumber				เป็น VARCHAR	รับค่านักศึกษาเป็นบุตรคนที่
-- 24. studyhoodNumber				เป็น VARCHAR	รับค่าจำนวนพี่น้องที่กำลังศึกษาอยู่
-- 25. by							เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================

/*EXEC	sp_perSetListPerson
		@order = '1;2;3;4;5',
		@idCard = '1200900176870;1100702037947;1619900229382;1100501141887;1100501179451',
		/*@perTitlePrefixId = '003;001;003;001;003',
		@firstName = 'กชกร;กนกพล;ธีราพร;ธีวรัตน์;กรรวี',
		@middleName = ';;;;',
		@lastName = 'ปรีดีคณิต;ศุภสิริมนตรี;อมราสิงห์;เวสารัชอารีย์กุล;เทศบรรทัด',
		@enFirstName = 'KODCHAKORN;KANOKPHOL;TEERAPORN;TEWARAT;KORNRAWEE',
		@enMiddleName = ';;;;',
		@enLastName = 'PREDEEKANIT;SUPASIRIMONTRI;AMARASINGH;WASARUCHAREEKUL;TETBUNTAD',
		@perGenderId = '02;01;02;01;02',
		@birthDate = '06/01/2538;16/01/2538;12/09/2537;11/10/2537;01/03/2538',
		@perCountryId = '217;217;217;217;217',
		@perNationalityId = '177;177;177;177;177',
		@perOriginId = '177;177;177;177;177',
		@perReligionId = '06;06;06;06;06',
		@perBloodTypeId = '04;02;01;01;02',
		@perMaritalStatusId = '01;01;01;01;01',
		@email = 'kodchakorn06@hotmail.com;fielddekclassic27@hotmail.com;rabbitz_style@hotmail.com;aum_tewarat@hotmail.com;kamehoho@hotmail.com',*/
		@by = 'system'*/
		
ALTER PROCEDURE [dbo].[sp_perSetListPerson]
(
	@order VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,	
	@perTitlePrefixId VARCHAR(MAX) = NULL,
	@firstName NVARCHAR(MAX) = NULL,
	@middleName NVARCHAR(MAX) = NULL,
	@lastName NVARCHAR(MAX) = NULL,
	@enFirstName NVARCHAR(MAX) = NULL,
	@enMiddleName NVARCHAR(MAX) = NULL,
	@enLastName NVARCHAR(MAX) = NULL,
	@perGenderId VARCHAR(MAX) = NULL,
	@alive VARCHAR(MAX) = NULL,	
	@birthDate VARCHAR(MAX) = NULL,
	@plcCountryId VARCHAR(MAX) = NULL,
	@perNationalityId VARCHAR(MAX) = NULL,
	@perOriginId VARCHAR(MAX) = NULL,
	@perReligionId VARCHAR(MAX) = NULL,
	@perBloodTypeId VARCHAR(MAX) = NULL,
	@perMaritalStatusId VARCHAR(MAX) = NULL,
	@perEducationalBackgroundId VARCHAR(MAX) = NULL,
	@email NVARCHAR(MAX) = NULL,
	@brotherhoodNumber VARCHAR(MAX) = NULL,
	@childhoodNumber VARCHAR(MAX) = NULL,
	@studyhoodNumber VARCHAR(MAX) = NULL,	
	@by NVARCHAR(255) = NULL   
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @idCard = LTRIM(RTRIM(@idCard))
	SET @perTitlePrefixId = LTRIM(RTRIM(@perTitlePrefixId))
	SET @firstName = LTRIM(RTRIM(@firstName))
	SET @middleName = LTRIM(RTRIM(@middleName))
	SET @lastName = LTRIM(RTRIM(@lastName))
	SET @enFirstName = LTRIM(RTRIM(@enFirstName))
	SET @enMiddleName = LTRIM(RTRIM(@enMiddleName))
	SET @enLastName = LTRIM(RTRIM(@enLastName))
	SET @perGenderId = LTRIM(RTRIM(@perGenderId))
	SET @alive = LTRIM(RTRIM(@alive))	
	SET @birthDate = LTRIM(RTRIM(@birthDate))
	SET @plcCountryId = LTRIM(RTRIM(@plcCountryId))
	SET @perNationalityId = LTRIM(RTRIM(@perNationalityId))
	SET @perOriginId = LTRIM(RTRIM(@perOriginId))
	SET @perReligionId = LTRIM(RTRIM(@perReligionId))
	SET @perBloodTypeId = LTRIM(RTRIM(@perBloodTypeId))
	SET @perMaritalStatusId = LTRIM(RTRIM(@perMaritalStatusId))
	SET @perEducationalBackgroundId = LTRIM(RTRIM(@perEducationalBackgroundId))
	SET @email = LTRIM(RTRIM(@email))
	SET @brotherhoodNumber = LTRIM(RTRIM(@brotherhoodNumber))
	SET @childhoodNumber = LTRIM(RTRIM(@childhoodNumber))
	SET @studyhoodNumber = LTRIM(RTRIM(@studyhoodNumber))	
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perPerson'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idCardSlice NVARCHAR(MAX) = NULL
	DECLARE @perTitlePrefixIdSlice VARCHAR(MAX) = NULL
	DECLARE @firstNameSlice NVARCHAR(MAX) = NULL
	DECLARE @middleNameSlice NVARCHAR(MAX) = NULL
	DECLARE @lastNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enFirstNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enMiddleNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enLastNameSlice NVARCHAR(MAX) = NULL
	DECLARE @perGenderIdSlice VARCHAR(MAX) = NULL
	DECLARE @aliveSlice VARCHAR(MAX) = NULL	
	DECLARE @birthDateSlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdSlice VARCHAR(MAX) = NULL
	DECLARE @perNationalityIdSlice VARCHAR(MAX) = NULL
	DECLARE	@perOriginIdSlice VARCHAR(MAX) = NULL
	DECLARE	@perReligionIdSlice VARCHAR(MAX) = NULL
	DECLARE @perBloodTypeIdSlice VARCHAR(MAX) = NULL
	DECLARE @perMaritalStatusIdSlice VARCHAR(MAX) = NULL
	DECLARE @perEducationalBackgroundIdSlice VARCHAR(MAX) = NULL
	DECLARE @emailSlice NVARCHAR(MAX) = NULL	
	DECLARE	@brotherhoodNumberSlice VARCHAR(MAX) = NULL
	DECLARE @childhoodNumberSlice VARCHAR(MAX) = NULL
	DECLARE @studyhoodNumberSlice VARCHAR(MAX) = NULL	
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL	
	DECLARE @personId VARCHAR(10) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()		
	
	WHILE (LEN(@order) > 0)
	BEGIN
		EXEC	sp_perGeneratePersonId
				@personId = @personId OUTPUT
					
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))
		
		SET @idCardSlice = (SELECT stringSlice FROM fnc_perParseString(@idCard, @delimiter))
		SET @idCard = (SELECT string FROM fnc_perParseString(@idCard, @delimiter))
		
		SET @perTitlePrefixIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perTitlePrefixId, @delimiter))
		SET @perTitlePrefixId = (SELECT string FROM fnc_perParseString(@perTitlePrefixId, @delimiter))

		SET @firstNameSlice = (SELECT stringSlice FROM fnc_perParseString(@firstName, @delimiter))
		SET @firstName = (SELECT string FROM fnc_perParseString(@firstName, @delimiter))		
		
		SET @middleNameSlice = (SELECT stringSlice FROM fnc_perParseString(@middleName, @delimiter))
		SET @middleName = (SELECT string FROM fnc_perParseString(@middleName, @delimiter))	

		SET @lastNameSlice = (SELECT stringSlice FROM fnc_perParseString(@lastName, @delimiter))
		SET @lastName = (SELECT string FROM fnc_perParseString(@lastName, @delimiter))			
		
		SET @enFirstNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enFirstName, @delimiter))
		SET @enFirstName = (SELECT string FROM fnc_perParseString(@enFirstName, @delimiter))
		
		SET @enMiddleNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enMiddleName, @delimiter))
		SET @enMiddleName = (SELECT string FROM fnc_perParseString(@enMiddleName, @delimiter))		

		SET @enLastNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enLastName, @delimiter))
		SET @enLastName = (SELECT string FROM fnc_perParseString(@enLastName, @delimiter))		
		
		SET @perGenderIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perGenderId, @delimiter))
		SET @perGenderId = (SELECT string FROM fnc_perParseString(@perGenderId, @delimiter))		
		
		SET @aliveSlice = (SELECT stringSlice FROM fnc_perParseString(@alive, @delimiter))
		SET @alive = (SELECT string FROM fnc_perParseString(@alive, @delimiter))
		
		SET @birthDateSlice = (SELECT stringSlice FROM fnc_perParseString(@birthDate, @delimiter))
		SET @birthDate = (SELECT string FROM fnc_perParseString(@birthDate, @delimiter))
		
		SET @plcCountryIdSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryId, @delimiter))
		SET @plcCountryId = (SELECT string FROM fnc_perParseString(@plcCountryId, @delimiter))

		SET @perNationalityIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perNationalityId, @delimiter))
		SET @perNationalityId = (SELECT string FROM fnc_perParseString(@perNationalityId, @delimiter))		

		SET @perOriginIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perOriginId, @delimiter))
		SET @perOriginId = (SELECT string FROM fnc_perParseString(@perOriginId, @delimiter))		

		SET @perReligionIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perReligionId, @delimiter))
		SET @perReligionId = (SELECT string FROM fnc_perParseString(@perReligionId, @delimiter))		
		
		SET @perBloodTypeIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perBloodTypeId, @delimiter))
		SET @perBloodTypeId = (SELECT string FROM fnc_perParseString(@perBloodTypeId, @delimiter))		
		
		SET @perMaritalStatusIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perMaritalStatusId, @delimiter))
		SET @perMaritalStatusId = (SELECT string FROM fnc_perParseString(@perMaritalStatusId, @delimiter))		

		SET @perEducationalBackgroundIdSlice = (SELECT stringSlice FROM fnc_perParseString(@perEducationalBackgroundId, @delimiter))
		SET @perEducationalBackgroundId = (SELECT string FROM fnc_perParseString(@perEducationalBackgroundId, @delimiter))
		
		SET @emailSlice = (SELECT stringSlice FROM fnc_perParseString(@email, @delimiter))
		SET @email = (SELECT string FROM fnc_perParseString(@email, @delimiter))	

		SET @brotherhoodNumberSlice = (SELECT stringSlice FROM fnc_perParseString(@brotherhoodNumber, @delimiter))
		SET @brotherhoodNumber = (SELECT string FROM fnc_perParseString(@brotherhoodNumber, @delimiter))	
		
		SET @childhoodNumberSlice = (SELECT stringSlice FROM fnc_perParseString(@childhoodNumber, @delimiter))
		SET @childhoodNumber = (SELECT string FROM fnc_perParseString(@childhoodNumber, @delimiter))	

		SET @studyhoodNumberSlice = (SELECT stringSlice FROM fnc_perParseString(@studyhoodNumber, @delimiter))
		SET @studyhoodNumber = (SELECT string FROM fnc_perParseString(@studyhoodNumber, @delimiter))	

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN ('"' + @personId + '"') ELSE 'NULL' END) + ', ' +
						 'idCard=' + (CASE WHEN (@idCardSlice IS NOT NULL AND LEN(@idCardSlice) > 0 AND CHARINDEX(@idCardSlice, @strBlank) = 0) THEN ('"' + @idCardSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perTitlePrefixId=' + (CASE WHEN (@perTitlePrefixIdSlice IS NOT NULL AND LEN(@perTitlePrefixIdSlice) > 0 AND CHARINDEX(@perTitlePrefixIdSlice, @strBlank) = 0) THEN ('"' + @perTitlePrefixIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'firstName=' + (CASE WHEN (@firstNameSlice IS NOT NULL AND LEN(@firstNameSlice) > 0 AND CHARINDEX(@firstNameSlice, @strBlank) = 0) THEN ('"' + @firstNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'middleName=' + (CASE WHEN (@middleNameSlice IS NOT NULL AND LEN(@middleNameSlice) > 0 AND CHARINDEX(@middleNameSlice, @strBlank) = 0) THEN ('"' + @middleNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'lastName=' + (CASE WHEN (@lastNameSlice IS NOT NULL AND LEN(@lastNameSlice) > 0 AND CHARINDEX(@lastNameSlice, @strBlank) = 0) THEN ('"' + @lastNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enFirstName=' + (CASE WHEN (@enFirstNameSlice IS NOT NULL AND LEN(@enFirstNameSlice) > 0 AND CHARINDEX(@enFirstNameSlice, @strBlank) = 0) THEN ('"' + @enFirstNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enMiddleName=' + (CASE WHEN (@enMiddleNameSlice IS NOT NULL AND LEN(@enMiddleNameSlice) > 0 AND CHARINDEX(@enMiddleNameSlice, @strBlank) = 0) THEN ('"' + @enMiddleNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enLastName=' + (CASE WHEN (@enLastNameSlice IS NOT NULL AND LEN(@enLastNameSlice) > 0 AND CHARINDEX(@enLastNameSlice, @strBlank) = 0) THEN ('"' + @enLastNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perGenderId=' + (CASE WHEN (@perGenderIdSlice IS NOT NULL AND LEN(@perGenderIdSlice) > 0 AND CHARINDEX(@perGenderIdSlice, @strBlank) = 0) THEN ('"' + @perGenderIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'alive=' + (CASE WHEN (@aliveSlice IS NOT NULL AND LEN(@aliveSlice) > 0 AND CHARINDEX(@aliveSlice, @strBlank) = 0) THEN ('"' + @aliveSlice + '"') ELSE 'NULL' END) + ', ' +						 
						 'birthDate=' + (CASE WHEN (@birthDateSlice IS NOT NULL AND LEN(@birthDateSlice) > 0 AND CHARINDEX(@birthDateSlice, @strBlank) = 0) THEN ('"' + @birthDateSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryId=' + (CASE WHEN (@plcCountryIdSlice IS NOT NULL AND LEN(@plcCountryIdSlice) > 0 AND CHARINDEX(@plcCountryIdSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perNationalityId=' + (CASE WHEN (@perNationalityIdSlice IS NOT NULL AND LEN(@perNationalityIdSlice) > 0 AND CHARINDEX(@perNationalityIdSlice, @strBlank) = 0) THEN ('"' + @perNationalityIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perOriginId=' + (CASE WHEN (@perOriginIdSlice IS NOT NULL AND LEN(@perOriginIdSlice) > 0 AND CHARINDEX(@perOriginIdSlice, @strBlank) = 0) THEN ('"' + @perOriginIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perReligionId=' + (CASE WHEN (@perReligionIdSlice IS NOT NULL AND LEN(@perReligionIdSlice) > 0 AND CHARINDEX(@perReligionIdSlice, @strBlank) = 0) THEN ('"' + @perReligionIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perBloodTypeId=' + (CASE WHEN (@perBloodTypeIdSlice IS NOT NULL AND LEN(@perBloodTypeIdSlice) > 0 AND CHARINDEX(@perBloodTypeIdSlice, @strBlank) = 0) THEN ('"' + @perBloodTypeIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perMaritalStatusId=' + (CASE WHEN (@perMaritalStatusIdSlice IS NOT NULL AND LEN(@perMaritalStatusIdSlice) > 0 AND CHARINDEX(@perMaritalStatusIdSlice, @strBlank) = 0) THEN ('"' + @perMaritalStatusIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'perEducationalBackgroundId=' + (CASE WHEN (@perEducationalBackgroundIdSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdSlice, @strBlank) = 0) THEN ('"' + @perEducationalBackgroundIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'email=' + (CASE WHEN (@emailSlice IS NOT NULL AND LEN(@emailSlice) > 0 AND CHARINDEX(@emailSlice, @strBlank) = 0) THEN ('"' + LOWER(@emailSlice) + '"') ELSE 'NULL' END) + ', ' +
						 'brotherhoodNumber=' + (CASE WHEN (@brotherhoodNumberSlice IS NOT NULL AND LEN(@brotherhoodNumberSlice) > 0 AND CHARINDEX(@brotherhoodNumberSlice, @strBlank) = 0) THEN ('"' + @brotherhoodNumberSlice + '"') ELSE 'NULL' END) + ', ' +
						 'childhoodNumber=' + (CASE WHEN (@childhoodNumberSlice IS NOT NULL AND LEN(@childhoodNumberSlice) > 0 AND CHARINDEX(@childhoodNumberSlice, @strBlank) = 0) THEN ('"' + @childhoodNumberSlice + '"') ELSE 'NULL' END) + ', ' +
						 'studyhoodNumber=' + (CASE WHEN (@studyhoodNumberSlice IS NOT NULL AND LEN(@studyhoodNumberSlice) > 0 AND CHARINDEX(@studyhoodNumberSlice, @strBlank) = 0) THEN ('"' + @studyhoodNumberSlice + '"') ELSE 'NULL' END)
			
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perPerson
					(
						id,
						idCard,
						perTitlePrefixId,
						firstName,
						middleName,
						lastName,
						enFirstName,
						enMiddleName,
						enLastName,
						perGenderId,
						alive,						
						birthDate,
						plcCountryId,
						perNationalityId,
						perOriginId,
						perReligionId,
						perBloodTypeId,
						perMaritalStatusId,
						perEducationalBackgroundId,
						email,
						brotherhoodNumber,
						childhoodNumber,
						studyhoodNumber,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp		
					)
					VALUES
					(
						CASE WHEN (@personId IS NOT NULL AND LEN(@personId) > 0 AND CHARINDEX(@personId, @strBlank) = 0) THEN @personId ELSE NULL END,
						CASE WHEN (@idCardSlice IS NOT NULL AND LEN(@idCardSlice) > 0 AND CHARINDEX(@idCardSlice, @strBlank) = 0) THEN @idCardSlice ELSE NULL END,
						CASE WHEN (@perTitlePrefixIdSlice IS NOT NULL AND LEN(@perTitlePrefixIdSlice) > 0 AND CHARINDEX(@perTitlePrefixIdSlice, @strBlank) = 0) THEN @perTitlePrefixIdSlice ELSE NULL END,
						CASE WHEN (@firstNameSlice IS NOT NULL AND LEN(@firstNameSlice) > 0 AND CHARINDEX(@firstNameSlice, @strBlank) = 0) THEN @firstNameSlice ELSE NULL END,
						CASE WHEN (@middleNameSlice IS NOT NULL AND LEN(@middleNameSlice) > 0 AND CHARINDEX(@middleNameSlice, @strBlank) = 0) THEN @middleNameSlice ELSE NULL END,
						CASE WHEN (@lastNameSlice IS NOT NULL AND LEN(@lastNameSlice) > 0 AND CHARINDEX(@lastNameSlice, @strBlank) = 0) THEN @lastNameSlice ELSE NULL END,
						CASE WHEN (@enFirstNameSlice IS NOT NULL AND LEN(@enFirstNameSlice) > 0 AND CHARINDEX(@enFirstNameSlice, @strBlank) = 0) THEN @enFirstNameSlice ELSE NULL END,
						CASE WHEN (@enMiddleNameSlice IS NOT NULL AND LEN(@enMiddleNameSlice) > 0 AND CHARINDEX(@enMiddleNameSlice, @strBlank) = 0) THEN @enMiddleNameSlice ELSE NULL END,
						CASE WHEN (@enLastNameSlice IS NOT NULL AND LEN(@enLastNameSlice) > 0 AND CHARINDEX(@enLastNameSlice, @strBlank) = 0) THEN @enLastNameSlice ELSE NULL END,
						CASE WHEN (@perGenderIdSlice IS NOT NULL AND LEN(@perGenderIdSlice) > 0 AND CHARINDEX(@perGenderIdSlice, @strBlank) = 0) THEN @perGenderIdSlice ELSE NULL END,
						CASE WHEN (@aliveSlice IS NOT NULL AND LEN(@aliveSlice) > 0 AND CHARINDEX(@aliveSlice, @strBlank) = 0) THEN @aliveSlice ELSE NULL END,						
						CASE WHEN (@birthDateSlice IS NOT NULL AND LEN(@birthDateSlice) > 0 AND CHARINDEX(@birthDateSlice, @strBlank) = 0) THEN CONVERT(DATETIME, @birthDateSlice, 103) ELSE NULL END,
						CASE WHEN (@plcCountryIdSlice IS NOT NULL AND LEN(@plcCountryIdSlice) > 0 AND CHARINDEX(@plcCountryIdSlice, @strBlank) = 0) THEN @plcCountryIdSlice ELSE NULL END,
						CASE WHEN (@perNationalityIdSlice IS NOT NULL AND LEN(@perNationalityIdSlice) > 0 AND CHARINDEX(@perNationalityIdSlice, @strBlank) = 0) THEN @perNationalityIdSlice ELSE NULL END,
						CASE WHEN (@perOriginIdSlice IS NOT NULL AND LEN(@perOriginIdSlice) > 0 AND CHARINDEX(@perOriginIdSlice, @strBlank) = 0) THEN @perOriginIdSlice ELSE NULL END,
						CASE WHEN (@perReligionIdSlice IS NOT NULL AND LEN(@perReligionIdSlice) > 0 AND CHARINDEX(@perReligionIdSlice, @strBlank) = 0) THEN @perReligionIdSlice ELSE NULL END,
						CASE WHEN (@perBloodTypeIdSlice IS NOT NULL AND LEN(@perBloodTypeIdSlice) > 0 AND CHARINDEX(@perBloodTypeIdSlice, @strBlank) = 0) THEN @perBloodTypeIdSlice ELSE NULL END,
						CASE WHEN (@perMaritalStatusIdSlice IS NOT NULL AND LEN(@perMaritalStatusIdSlice) > 0 AND CHARINDEX(@perMaritalStatusIdSlice, @strBlank) = 0) THEN @perMaritalStatusIdSlice ELSE NULL END,
						CASE WHEN (@perEducationalBackgroundIdSlice IS NOT NULL AND LEN(@perEducationalBackgroundIdSlice) > 0 AND CHARINDEX(@perEducationalBackgroundIdSlice, @strBlank) = 0) THEN @perEducationalBackgroundIdSlice ELSE NULL END,
						CASE WHEN (@emailSlice IS NOT NULL AND LEN(@emailSlice) > 0 AND CHARINDEX(@emailSlice, @strBlank) = 0) THEN LOWER(@emailSlice) ELSE NULL END,
						CASE WHEN (@brotherhoodNumberSlice IS NOT NULL AND LEN(@brotherhoodNumberSlice) > 0 AND CHARINDEX(@brotherhoodNumberSlice, @strBlank) = 0) THEN @brotherhoodNumberSlice ELSE NULL END,
						CASE WHEN (@childhoodNumberSlice IS NOT NULL AND LEN(@childhoodNumberSlice) > 0 AND CHARINDEX(@childhoodNumberSlice, @strBlank) = 0) THEN @childhoodNumberSlice ELSE NULL END,
						CASE WHEN (@studyhoodNumberSlice IS NOT NULL AND LEN(@studyhoodNumberSlice) > 0 AND CHARINDEX(@studyhoodNumberSlice, @strBlank) = 0) THEN @studyhoodNumberSlice ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL						
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO InfinityLog..perErrorLog
				(
					errorDatabase,
					errorTable,
					errorAction,
					errorValue,
					errorMessage,
					errorNumber,
					errorSeverity,
					errorState,
					errorLine,
					errorProcedure,
					errorActionDate,
					errorActionBy,
					errorIp
				)
				VALUES
				(
					DB_NAME(),
					@table,
					@action,
					@value,
					ERROR_MESSAGE(),
					ERROR_NUMBER(),
					ERROR_SEVERITY(),
					ERROR_STATE(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					GETDATE(),
					CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
					@ip
				)				
			END CATCH
		END		
	END

	SELECT @rowCount
END