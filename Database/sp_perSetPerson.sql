USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetPerson]    Script Date: 06-07-2016 13:12:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perPerson ครั้งละ ๑ เรคคอร์ด>
--  1. action					เป็น VARCHAR	รับค่าการกระทำกับฐานข้อมูล
--  2. id 						เป็น VARCHAR	รับค่ารหัสบุคคล
--  3. idCard					เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  4. titlePrefix				เป็น VARCHAR	รับค่ารหัสคำนำหน้าชื่อ
--  5. firstName				เป็น NVARCHAR	รับค่าชื่อ
--  6. middleName				เป็น NVARCHAR	รับค่าชื่อกลาง
--  7. lastName					เป็น NVARCHAR	รับค่านามสกุล
--  8. firstNameEN				เป็น NVARCHAR	รับค่าชื่อภาษาอังกฤษ
--  9. middleNameEN				เป็น NVARCHAR	รับค่าชื่อกลางภาษาอังกฤษ
-- 10. lastNameEN				เป็น NVARCHAR	รับค่านามสกุลภาษาอังกฤษ
-- 11. gender					เป็น VARCHAR	รับค่ารหัสเพศ
-- 12. alive					เป็น VARCHAR	รับค่าสถานะการมีชีวิต
-- 13. birthDate				เป็น VARCHAR	รับค่าวันเกิด
-- 14. country 					เป็น VARCHAR	รับค่ารหัสประเทศบ้านเกิด
-- 15. nationality 				เป็น VARCHAR	รับค่ารหัสสัญชาติ
-- 16. origin 					เป็น VARCHAR	รับค่ารหัสเชื้อชาติ
-- 17. religion 				เป็น VARCHAR	รับค่ารหัสศาสนา
-- 18. bloodType				เป็น VARCHAR	รับค่ารหัสหมู่เลือด
-- 19. maritalStatus			เป็น VARCHAR	รับค่ารหัสสถานะภาพการสมรส
-- 20. educationalBackground	เป็น VARCHAR	รับค่ารหัสวุฒิการศึกษา
-- 21. email					เป็น NVARCHAR	รับค่าอีเมล์
-- 22. brotherhoodNumber		เป็น VARCHAR	รับค่าจำนวนพี่น้อง
-- 23. childhoodNumber			เป็น VARCHAR	รับค่านักศึกษาเป็นบุตรคนที่
-- 24. studyhoodNumber			เป็น VARCHAR	รับค่าจำนวนพี่น้องที่กำลังศึกษาอยู่
-- 25. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 26. ip						เป็น VARCHAR	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetPerson]
(
	@action VARCHAR(10) = NULL,
	@id VARCHAR(10) = NULL,
	@idCard NVARCHAR(20) = NULL,	
	@titlePrefix VARCHAR(3) = NULL,
	@firstName NVARCHAR(100) = NULL,
	@middleName NVARCHAR(100) = NULL,
	@lastName NVARCHAR(100) = NULL,
	@firstNameEN NVARCHAR(100) = NULL,
	@middleNameEN NVARCHAR(100) = NULL,
	@lastNameEN NVARCHAR(100) = NULL,
	@gender VARCHAR(2) = NULL,
	@alive VARCHAR(1) = NULL,	
	@birthDate VARCHAR(20) = NULL,
	@country VARCHAR(3) = NULL,
	@nationality VARCHAR(3) = NULL,
	@origin VARCHAR(3) = NULL,
	@religion VARCHAR(2) = NULL,
	@bloodType VARCHAR(2) = NULL,
	@maritalStatus VARCHAR(2) = NULL,
	@educationalBackground VARCHAR(2) = NULL,
	@email NVARCHAR(255) = NULL,		
	@brotherhoodNumber VARCHAR(10) = NULL,
	@childhoodNumber VARCHAR(10) = NULL,
	@studyhoodNumber VARCHAR(10) = NULL,
	@by NVARCHAR(255) = NULL,
	@ip VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @action = LTRIM(RTRIM(@action))
	SET @id = LTRIM(RTRIM(@id))
	SET @idCard = LTRIM(RTRIM(@idCard))
	SET @titlePrefix = LTRIM(RTRIM(@titlePrefix))
	SET @firstName = LTRIM(RTRIM(@firstName))
	SET @middleName = LTRIM(RTRIM(@middleName))
	SET @lastName = LTRIM(RTRIM(@lastName))
	SET @firstNameEN = LTRIM(RTRIM(@firstNameEN))
	SET @middleNameEN = LTRIM(RTRIM(@middleNameEN))
	SET @lastNameEN = LTRIM(RTRIM(@lastNameEN))
	SET @gender = LTRIM(RTRIM(@gender))
	SET @alive = LTRIM(RTRIM(@alive))	
	SET @birthDate = LTRIM(RTRIM(@birthDate))
	SET @country = LTRIM(RTRIM(@country))
	SET @nationality = LTRIM(RTRIM(@nationality))
	SET @origin = LTRIM(RTRIM(@origin))
	SET @religion = LTRIM(RTRIM(@religion))
	SET @bloodType = LTRIM(RTRIM(@bloodType))
	SET @maritalStatus = LTRIM(RTRIM(@maritalStatus))
	SET @educationalBackground = LTRIM(RTRIM(@educationalBackground))
	SET @email = LTRIM(RTRIM(@email))
	SET @brotherhoodNumber = LTRIM(RTRIM(@brotherhoodNumber))
	SET @childhoodNumber = LTRIM(RTRIM(@childhoodNumber))
	SET @studyhoodNumber = LTRIM(RTRIM(@studyhoodNumber))
	SET @by = LTRIM(RTRIM(@by))
	SET @ip = LTRIM(RTRIM(@ip))
		
	DECLARE @table VARCHAR(50) = 'perPerson'
	DECLARE @rowCount INT = 0
	DECLARE @rowCountUpdate INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL
	DECLARE @personId VARCHAR(10) = NULL
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	
	SET @action = UPPER(@action)
	
	IF (@action = 'INSERT' OR @action = 'UPDATE' OR @action = 'DELETE')
	BEGIN
		IF (@action = 'INSERT')
		BEGIN
			EXEC	sp_perGeneratePersonId
					@personId = @personId OUTPUT
					
			SET @id = @personId					
		END			

		SET @value = 'id=' + (CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN ('"' + @id + '"') ELSE 'NULL' END) + ', ' +
					 'idCard=' + (CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0 AND CHARINDEX(@idCard, @strBlank) = 0) THEN ('"' + @idCard + '"') ELSE 'NULL' END) + ', ' +
					 'perTitlePrefixId=' + (CASE WHEN (@titlePrefix IS NOT NULL AND LEN(@titlePrefix) > 0 AND CHARINDEX(@titlePrefix, @strBlank) = 0) THEN ('"' + @titlePrefix + '"') ELSE 'NULL' END) + ', ' +
					 'firstName=' + (CASE WHEN (@firstName IS NOT NULL AND LEN(@firstName) > 0 AND CHARINDEX(@firstName, @strBlank) = 0) THEN ('"' + @firstName + '"') ELSE 'NULL' END) + ', ' +
					 'middleName=' + (CASE WHEN (@middleName IS NOT NULL AND LEN(@middleName) > 0 AND CHARINDEX(@middleName, @strBlank) = 0) THEN ('"' + @middleName + '"') ELSE 'NULL' END) + ', ' +
					 'lastName=' + (CASE WHEN (@lastName IS NOT NULL AND LEN(@lastName) > 0 AND CHARINDEX(@lastName, @strBlank) = 0) THEN ('"' + @lastName + '"') ELSE 'NULL' END) + ', ' +
					 'enFirstName=' + (CASE WHEN (@firstNameEN IS NOT NULL AND LEN(@firstNameEN) > 0 AND CHARINDEX(@firstNameEN, @strBlank) = 0) THEN ('"' + @firstNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'enMiddleName=' + (CASE WHEN (@middleNameEN IS NOT NULL AND LEN(@middleNameEN) > 0 AND CHARINDEX(@middleNameEN, @strBlank) = 0) THEN ('"' + @middleNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'enLastName=' + (CASE WHEN (@lastNameEN IS NOT NULL AND LEN(@lastNameEN) > 0 AND CHARINDEX(@lastNameEN, @strBlank) = 0) THEN ('"' + @lastNameEN + '"') ELSE 'NULL' END) + ', ' +
					 'perGenderId=' + (CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN ('"' + @gender + '"') ELSE 'NULL' END) + ', ' +
					 'alive=' + (CASE WHEN (@alive IS NOT NULL AND LEN(@alive) > 0 AND CHARINDEX(@alive, @strBlank) = 0) THEN ('"' + @alive + '"') ELSE 'NULL' END) + ', ' +					 
					 'birthDate=' + (CASE WHEN (@birthDate IS NOT NULL AND LEN(@birthDate) > 0 AND CHARINDEX(@birthDate, @strBlank) = 0) THEN ('"' + @birthDate + '"') ELSE 'NULL' END) + ', ' +
					 'plcCountryId=' + (CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN ('"' + @country + '"') ELSE 'NULL' END) + ', ' +
					 'perNationalityId=' + (CASE WHEN (@nationality IS NOT NULL AND LEN(@nationality) > 0 AND CHARINDEX(@nationality, @strBlank) = 0) THEN ('"' + @nationality + '"') ELSE 'NULL' END) + ', ' +
					 'perOriginId=' + (CASE WHEN (@origin IS NOT NULL AND LEN(@origin) > 0 AND CHARINDEX(@origin, @strBlank) = 0) THEN ('"' + @origin + '"') ELSE 'NULL' END) + ', ' +
					 'perReligionId=' + (CASE WHEN (@religion IS NOT NULL AND LEN(@religion) > 0 AND CHARINDEX(@religion, @strBlank) = 0) THEN ('"' + @religion + '"') ELSE 'NULL' END) + ', ' +
					 'perBloodTypeId=' + (CASE WHEN (@bloodType IS NOT NULL AND LEN(@bloodType) > 0 AND CHARINDEX(@bloodType, @strBlank) = 0) THEN ('"' + @bloodType + '"') ELSE 'NULL' END) + ', ' +
					 'perMaritalStatusId=' + (CASE WHEN (@maritalStatus IS NOT NULL AND LEN(@maritalStatus) > 0 AND CHARINDEX(@maritalStatus, @strBlank) = 0) THEN ('"' + @maritalStatus + '"') ELSE 'NULL' END) + ', ' +
					 'perEducationalBackgroundId=' + (CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN ('"' + @educationalBackground + '"') ELSE 'NULL' END) + ', ' +
					 'email=' + (CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0 AND CHARINDEX(@email, @strBlank) = 0) THEN ('"' + LOWER(@email) + '"') ELSE 'NULL' END) + ', ' +
					 'brotherhoodNumber=' + (CASE WHEN (@brotherhoodNumber IS NOT NULL AND LEN(@brotherhoodNumber) > 0 AND CHARINDEX(@brotherhoodNumber, @strBlank) = 0) THEN ('"' + @brotherhoodNumber + '"') ELSE 'NULL' END) + ', ' +
					 'childhoodNumber=' + (CASE WHEN (@childhoodNumber IS NOT NULL AND LEN(@childhoodNumber) > 0 AND CHARINDEX(@childhoodNumber, @strBlank) = 0) THEN ('"' + @childhoodNumber + '"') ELSE 'NULL' END) + ', ' +
					 'studyhoodNumber=' + (CASE WHEN (@studyhoodNumber IS NOT NULL AND LEN(@studyhoodNumber) > 0 AND CHARINDEX(@studyhoodNumber, @strBlank) = 0) THEN ('"' + @studyhoodNumber + '"') ELSE 'NULL' END)
					 
		BEGIN TRY
			BEGIN TRAN
				IF (@action = 'INSERT')
				BEGIN
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
						CASE WHEN (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0) THEN @id ELSE NULL END,
						CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0 AND CHARINDEX(@idCard, @strBlank) = 0) THEN @idCard ELSE NULL END,
						CASE WHEN (@titlePrefix IS NOT NULL AND LEN(@titlePrefix) > 0 AND CHARINDEX(@titlePrefix, @strBlank) = 0) THEN @titlePrefix ELSE NULL END,
						CASE WHEN (@firstName IS NOT NULL AND LEN(@firstName) > 0 AND CHARINDEX(@firstName, @strBlank) = 0) THEN @firstName ELSE NULL END,
						CASE WHEN (@middleName IS NOT NULL AND LEN(@middleName) > 0 AND CHARINDEX(@middleName, @strBlank) = 0) THEN @middleName ELSE NULL END,
						CASE WHEN (@lastName IS NOT NULL AND LEN(@lastName) > 0 AND CHARINDEX(@lastName, @strBlank) = 0) THEN @lastName ELSE NULL END,
						CASE WHEN (@firstNameEN IS NOT NULL AND LEN(@firstNameEN) > 0 AND CHARINDEX(@firstNameEN, @strBlank) = 0) THEN @firstNameEN ELSE NULL END,
						CASE WHEN (@middleNameEN IS NOT NULL AND LEN(@middleNameEN) > 0 AND CHARINDEX(@middleNameEN, @strBlank) = 0) THEN @middleNameEN ELSE NULL END,
						CASE WHEN (@lastNameEN IS NOT NULL AND LEN(@lastNameEN) > 0 AND CHARINDEX(@lastNameEN, @strBlank) = 0) THEN @lastNameEN ELSE NULL END,
						CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN @gender ELSE NULL END,
						CASE WHEN (@alive IS NOT NULL AND LEN(@alive) > 0 AND CHARINDEX(@alive, @strBlank) = 0) THEN @alive ELSE NULL END,						
						CASE WHEN (@birthDate IS NOT NULL AND LEN(@birthDate) > 0 AND CHARINDEX(@birthDate, @strBlank) = 0) THEN CONVERT(DATETIME, @birthdate, 103) ELSE NULL END,
						CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN @country ELSE NULL END,
						CASE WHEN (@nationality IS NOT NULL AND LEN(@nationality) > 0 AND CHARINDEX(@nationality, @strBlank) = 0) THEN @nationality ELSE NULL END,
						CASE WHEN (@origin IS NOT NULL AND LEN(@origin) > 0 AND CHARINDEX(@origin, @strBlank) = 0) THEN @origin ELSE NULL END,
						CASE WHEN (@religion IS NOT NULL AND LEN(@religion) > 0 AND CHARINDEX(@religion, @strBlank) = 0) THEN @religion ELSE NULL END,
						CASE WHEN (@bloodType IS NOT NULL AND LEN(@bloodType) > 0 AND CHARINDEX(@bloodType, @strBlank) = 0) THEN @bloodType ELSE NULL END,
						CASE WHEN (@maritalStatus IS NOT NULL AND LEN(@maritalStatus) > 0 AND CHARINDEX(@maritalStatus, @strBlank) = 0) THEN @maritalStatus ELSE NULL END,
						CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN @educationalBackground ELSE NULL END,
						CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0 AND CHARINDEX(@email, @strBlank) = 0) THEN LOWER(@email) ELSE NULL END,
						CASE WHEN (@brotherhoodNumber IS NOT NULL AND LEN(@brotherhoodNumber) > 0 AND CHARINDEX(@brotherhoodNumber, @strBlank) = 0) THEN @brotherhoodNumber ELSE NULL END,
						CASE WHEN (@childhoodNumber IS NOT NULL AND LEN(@childhoodNumber) > 0 AND CHARINDEX(@childhoodNumber, @strBlank) = 0) THEN @childhoodNumber ELSE NULL END,
						CASE WHEN (@studyhoodNumber IS NOT NULL AND LEN(@studyhoodNumber) > 0 AND CHARINDEX(@studyhoodNumber, @strBlank) = 0) THEN @studyhoodNumber ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END,
						NULL,
						NULL,
						NULL
					)		
					
					SET @rowCount = @rowCount + 1
				END
				
				IF (@action = 'UPDATE' OR @action = 'DELETE')					
				BEGIN
					IF (@id IS NOT NULL AND LEN(@id) > 0 AND CHARINDEX(@id, @strBlank) = 0)
					BEGIN
						SET @rowCountUpdate = (SELECT COUNT(id) FROM perPerson WHERE id = @id)
						
						IF (@rowCountUpdate > 0)
						BEGIN
							IF (@action = 'UPDATE')
							BEGIN
								UPDATE perPerson SET
									idCard						= CASE WHEN (@idCard IS NOT NULL AND LEN(@idCard) > 0 AND CHARINDEX(@idCard, @strBlank) = 0) THEN @idCard ELSE (CASE WHEN (@idCard IS NOT NULL AND (LEN(@idCard) = 0 OR CHARINDEX(@idCard, @strBlank) > 0)) THEN NULL ELSE idCard END) END,
									perTitlePrefixId			= CASE WHEN (@titlePrefix IS NOT NULL AND LEN(@titlePrefix) > 0 AND CHARINDEX(@titlePrefix, @strBlank) = 0) THEN @titlePrefix ELSE (CASE WHEN (@titlePrefix IS NOT NULL AND (LEN(@titlePrefix) = 0 OR CHARINDEX(@titlePrefix, @strBlank) > 0)) THEN NULL ELSE perTitlePrefixId END) END,
									firstName					= CASE WHEN (@firstName IS NOT NULL AND LEN(@firstName) > 0 AND CHARINDEX(@firstName, @strBlank) = 0) THEN @firstName ELSE (CASE WHEN (@firstName IS NOT NULL AND (LEN(@firstName) = 0 OR CHARINDEX(@firstName, @strBlank) > 0)) THEN NULL ELSE firstName END) END,
									middleName					= CASE WHEN (@middleName IS NOT NULL AND LEN(@middleName) > 0 AND CHARINDEX(@middleName, @strBlank) = 0) THEN @middleName ELSE (CASE WHEN (@middleName IS NOT NULL AND (LEN(@middleName) = 0 OR CHARINDEX(@middleName, @strBlank) > 0)) THEN NULL ELSE middleName END) END,
									lastName					= CASE WHEN (@lastName IS NOT NULL AND LEN(@lastName) > 0 AND CHARINDEX(@lastName, @strBlank) = 0) THEN @lastName ELSE (CASE WHEN (@lastName IS NOT NULL AND (LEN(@lastName) = 0 OR CHARINDEX(@lastName, @strBlank) > 0)) THEN NULL ELSE lastName END) END,
									enFirstName					= CASE WHEN (@firstNameEN IS NOT NULL AND LEN(@firstNameEN) > 0 AND CHARINDEX(@firstNameEN, @strBlank) = 0) THEN @firstNameEN ELSE (CASE WHEN (@firstNameEN IS NOT NULL AND (LEN(@firstNameEN) = 0 OR CHARINDEX(@firstNameEN, @strBlank) > 0)) THEN NULL ELSE enFirstName END) END,
									enMiddleName				= CASE WHEN (@middleNameEN IS NOT NULL AND LEN(@middleNameEN) > 0 AND CHARINDEX(@middleNameEN, @strBlank) = 0) THEN @middleNameEN ELSE (CASE WHEN (@middleNameEN IS NOT NULL AND (LEN(@middleNameEN) = 0 OR CHARINDEX(@middleNameEN, @strBlank) > 0)) THEN NULL ELSE enMiddleName END) END,
									enLastName					= CASE WHEN (@lastNameEN IS NOT NULL AND LEN(@lastNameEN) > 0 AND CHARINDEX(@lastNameEN, @strBlank) = 0) THEN @lastNameEN ELSE (CASE WHEN (@lastNameEN IS NOT NULL AND (LEN(@lastNameEN) = 0 OR CHARINDEX(@lastNameEN, @strBlank) > 0)) THEN NULL ELSE enLastName END) END,
									perGenderId					= CASE WHEN (@gender IS NOT NULL AND LEN(@gender) > 0 AND CHARINDEX(@gender, @strBlank) = 0) THEN @gender ELSE (CASE WHEN (@gender IS NOT NULL AND (LEN(@gender) = 0 OR CHARINDEX(@gender, @strBlank) > 0)) THEN NULL ELSE perGenderId END) END,
									alive						= CASE WHEN (@alive IS NOT NULL AND LEN(@alive) > 0 AND CHARINDEX(@alive, @strBlank) = 0) THEN @alive ELSE (CASE WHEN (@alive IS NOT NULL AND (LEN(@alive) = 0 OR CHARINDEX(@alive, @strBlank) > 0)) THEN NULL ELSE alive END) END,									
									birthDate					= CASE WHEN (@birthDate IS NOT NULL AND LEN(@birthDate) > 0 AND CHARINDEX(@birthDate, @strBlank) = 0) THEN CONVERT(DATETIME, @birthdate, 103) ELSE (CASE WHEN (@birthDate IS NOT NULL AND (LEN(@birthDate) = 0 OR CHARINDEX(@birthDate, @strBlank) > 0)) THEN NULL ELSE birthDate END) END,
									plcCountryId				= CASE WHEN (@country IS NOT NULL AND LEN(@country) > 0 AND CHARINDEX(@country, @strBlank) = 0) THEN @country ELSE (CASE WHEN (@country IS NOT NULL AND (LEN(@country) = 0 OR CHARINDEX(@country, @strBlank) > 0)) THEN NULL ELSE plcCountryId END) END,
									perNationalityId			= CASE WHEN (@nationality IS NOT NULL AND LEN(@nationality) > 0 AND CHARINDEX(@nationality, @strBlank) = 0) THEN @nationality ELSE (CASE WHEN (@nationality IS NOT NULL AND (LEN(@nationality) = 0 OR CHARINDEX(@nationality, @strBlank) > 0)) THEN NULL ELSE perNationalityId END) END,
									perOriginId					= CASE WHEN (@origin IS NOT NULL AND LEN(@origin) > 0 AND CHARINDEX(@origin, @strBlank) = 0) THEN @origin ELSE (CASE WHEN (@origin IS NOT NULL AND (LEN(@origin) = 0 OR CHARINDEX(@origin, @strBlank) > 0)) THEN NULL ELSE perOriginId END) END,
									perReligionId				= CASE WHEN (@religion IS NOT NULL AND LEN(@religion) > 0 AND CHARINDEX(@religion, @strBlank) = 0) THEN @religion ELSE (CASE WHEN (@religion IS NOT NULL AND (LEN(@religion) = 0 OR CHARINDEX(@religion, @strBlank) > 0)) THEN NULL ELSE perReligionId END) END,
									perBloodTypeId				= CASE WHEN (@bloodType IS NOT NULL AND LEN(@bloodType) > 0 AND CHARINDEX(@bloodType, @strBlank) = 0) THEN @bloodType ELSE (CASE WHEN (@bloodType IS NOT NULL AND (LEN(@bloodType) = 0 OR CHARINDEX(@bloodType, @strBlank) > 0)) THEN NULL ELSE perBloodTypeId END) END,
									perMaritalStatusId			= CASE WHEN (@maritalStatus IS NOT NULL AND LEN(@maritalStatus) > 0 AND CHARINDEX(@maritalStatus, @strBlank) = 0) THEN @maritalStatus ELSE (CASE WHEN (@maritalStatus IS NOT NULL AND (LEN(@maritalStatus) = 0 OR CHARINDEX(@maritalStatus, @strBlank) > 0)) THEN NULL ELSE perMaritalStatusId END) END,
									perEducationalBackgroundId	= CASE WHEN (@educationalBackground IS NOT NULL AND LEN(@educationalBackground) > 0 AND CHARINDEX(@educationalBackground, @strBlank) = 0) THEN @educationalBackground ELSE (CASE WHEN (@educationalBackground IS NOT NULL AND (LEN(@educationalBackground) = 0 OR CHARINDEX(@educationalBackground, @strBlank) > 0)) THEN NULL ELSE perEducationalBackgroundId END) END,
									email						= CASE WHEN (@email IS NOT NULL AND LEN(@email) > 0 AND CHARINDEX(@email, @strBlank) = 0) THEN LOWER(@email) ELSE (CASE WHEN (@email IS NOT NULL AND (LEN(@email) = 0 OR CHARINDEX(@email, @strBlank) > 0)) THEN NULL ELSE email END) END,
									brotherhoodNumber			= CASE WHEN (@brotherhoodNumber IS NOT NULL AND LEN(@brotherhoodNumber) > 0 AND CHARINDEX(@brotherhoodNumber, @strBlank) = 0) THEN @brotherhoodNumber ELSE (CASE WHEN (@brotherhoodNumber IS NOT NULL AND (LEN(@brotherhoodNumber) = 0 OR CHARINDEX(@brotherhoodNumber, @strBlank) > 0)) THEN NULL ELSE brotherhoodNumber END) END,
									childhoodNumber				= CASE WHEN (@childhoodNumber IS NOT NULL AND LEN(@childhoodNumber) > 0 AND CHARINDEX(@childhoodNumber, @strBlank) = 0) THEN @childhoodNumber ELSE (CASE WHEN (@childhoodNumber IS NOT NULL AND (LEN(@childhoodNumber) = 0 OR CHARINDEX(@childhoodNumber, @strBlank) > 0)) THEN NULL ELSE childhoodNumber END) END,
									studyhoodNumber				= CASE WHEN (@studyhoodNumber IS NOT NULL AND LEN(@studyhoodNumber) > 0 AND CHARINDEX(@studyhoodNumber, @strBlank) = 0) THEN @studyhoodNumber ELSE (CASE WHEN (@studyhoodNumber IS NOT NULL AND (LEN(@studyhoodNumber) = 0 OR CHARINDEX(@studyhoodNumber, @strBlank) > 0)) THEN NULL ELSE studyhoodNumber END) END,
									modifyDate					= GETDATE(),
									modifyBy					= CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE (CASE WHEN (@by IS NOT NULL AND (LEN(@by) = 0 OR CHARINDEX(@by, @strBlank) > 0)) THEN NULL ELSE modifyBy END) END,
									modifyIp					= CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE (CASE WHEN (@ip IS NOT NULL AND (LEN(@ip) = 0 OR CHARINDEX(@ip, @strBlank) > 0)) THEN NULL ELSE modifyIp END) END
								WHERE id = @id
							END								
							
							IF (@action = 'DELETE')
							BEGIN
								DELETE FROM perPerson WHERE id = @id
							END
							
							SET @rowCount = @rowCount + 1							
						END							
					END				
				END								
			COMMIT TRAN									
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
				CASE WHEN (@ip IS NOT NULL AND LEN(@ip) > 0 AND CHARINDEX(@ip, @strBlank) = 0) THEN @ip ELSE NULL END
			)			
		END CATCH
	END
	
	SELECT @rowCount, @id
	
	EXEC sp_stdTransferStudentRecordsToMUStudent
		@personId = @id		
END
