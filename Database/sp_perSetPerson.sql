USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetPerson]    Script Date: 14/9/2564 20:21:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perPerson ครั้งละ ๑ เรคคอร์ด>
-- Parameter
--  1. action					เป็น varchar	รับค่าการกระทำกับฐานข้อมูล
--  2. id 						เป็น varchar	รับค่ารหัสบุคคล
--  3. idCard					เป็น varchar	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  4. idCardIssueDate			เป็น varchar	รับค่าวันออกบัตรประจำตัวประชาชนหรือหนังสือเดินทาง
--  5. idCardExpiryDate			เป็น varchar	รับค่าวันหมดอายุบัตรประจำตัวประชาชนหรือหนังสือเดินทาง
--  6. titlePrefix				เป็น varchar	รับค่ารหัสคำนำหน้าชื่อ
--  7. firstName				เป็น varchar	รับค่าชื่อ
--  8. middleName				เป็น varchar	รับค่าชื่อกลาง
--  9. lastName					เป็น varchar	รับค่านามสกุล
-- 10. firstNameEN				เป็น varchar	รับค่าชื่อภาษาอังกฤษ
-- 11. middleNameEN				เป็น varchar	รับค่าชื่อกลางภาษาอังกฤษ
-- 12. lastNameEN				เป็น varchar	รับค่านามสกุลภาษาอังกฤษ
-- 13. gender					เป็น varchar	รับค่ารหัสเพศ
-- 14. alive					เป็น varchar	รับค่าสถานะการมีชีวิต
-- 15. birthDate				เป็น varchar	รับค่าวันเกิด (example data: 01/01/2000)
-- 16. country 					เป็น varchar	รับค่ารหัสประเทศบ้านเกิด
-- 17. nationality 				เป็น varchar	รับค่ารหัสสัญชาติ
-- 18. origin 					เป็น varchar	รับค่ารหัสเชื้อชาติ
-- 19. religion 				เป็น varchar	รับค่ารหัสศาสนา
-- 20. bloodType				เป็น varchar	รับค่ารหัสหมู่เลือด
-- 21. maritalStatus			เป็น varchar	รับค่ารหัสสถานะภาพการสมรส
-- 22. educationalBackground	เป็น varchar	รับค่ารหัสวุฒิการศึกษา
-- 23. email					เป็น varchar	รับค่าอีเมล์
-- 24. brotherhoodNumber		เป็น varchar	รับค่าจำนวนพี่น้อง
-- 25. childhoodNumber			เป็น varchar	รับค่านักศึกษาเป็นบุตรคนที่
-- 26. studyhoodNumber			เป็น varchar	รับค่าจำนวนพี่น้องที่กำลังศึกษาอยู่
-- 27. by						เป็น varchar	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 28. ip						เป็น varchar	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER procedure [dbo].[sp_perSetPerson]
(
	@action varchar(10) = null,
	@id varchar(10) = null,
	@idCard varchar(20) = null,	
	@idCardIssueDate varchar(20) = null,
	@idCardExpiryDate varchar(20) = null,
	@titlePrefix varchar(3) = null,
	@firstName varchar(100) = null,
	@middleName varchar(100) = null,
	@lastName varchar(100) = null,
	@firstNameEN varchar(100) = null,
	@middleNameEN varchar(100) = null,
	@lastNameEN varchar(100) = null,
	@gender varchar(2) = null,
	@alive varchar(1) = null,	
	@birthDate varchar(20) = null,
	@country varchar(3) = null,
	@nationality varchar(3) = null,
	@origin varchar(3) = null,
	@religion varchar(2) = null,
	@bloodType varchar(2) = null,
	@maritalStatus varchar(2) = null,
	@educationalBackground varchar(2) = null,
	@email varchar(255) = null,		
	@brotherhoodNumber varchar(10) = null,
	@childhoodNumber varchar(10) = null,
	@studyhoodNumber varchar(10) = null,
	@by varchar(255) = null,
	@ip varchar(255) = null
)
as
begin
	set concat_null_yields_null off
	
	set @action = ltrim(rtrim(@action))
	set @id = ltrim(rtrim(@id))
	set @idCard = ltrim(rtrim(@idCard))
	set @idCardIssueDate = ltrim(rtrim(@idCardIssueDate))
	set @idCardExpiryDate = ltrim(rtrim(@idCardExpiryDate))
	set @titlePrefix = ltrim(rtrim(@titlePrefix))
	set @firstName = ltrim(rtrim(@firstName))
	set @middleName = ltrim(rtrim(@middleName))
	set @lastName = ltrim(rtrim(@lastName))
	set @firstNameEN = ltrim(rtrim(@firstNameEN))
	set @middleNameEN = ltrim(rtrim(@middleNameEN))
	set @lastNameEN = ltrim(rtrim(@lastNameEN))
	set @gender = ltrim(rtrim(@gender))
	set @alive = ltrim(rtrim(@alive))	
	set @birthDate = ltrim(rtrim(@birthDate))
	set @country = ltrim(rtrim(@country))
	set @nationality = ltrim(rtrim(@nationality))
	set @origin = ltrim(rtrim(@origin))
	set @religion = ltrim(rtrim(@religion))
	set @bloodType = ltrim(rtrim(@bloodType))
	set @maritalStatus = ltrim(rtrim(@maritalStatus))
	set @educationalBackground = ltrim(rtrim(@educationalBackground))
	set @email = ltrim(rtrim(@email))
	set @brotherhoodNumber = ltrim(rtrim(@brotherhoodNumber))
	set @childhoodNumber = ltrim(rtrim(@childhoodNumber))
	set @studyhoodNumber = ltrim(rtrim(@studyhoodNumber))
	set @by = ltrim(rtrim(@by))
	set @ip = ltrim(rtrim(@ip))
		
	declare @table varchar(50) = 'perPerson'
	declare @rowCount int = 0
	declare @rowCountUpdate int = 0
	declare @value varchar(3000) = null
	declare @personId varchar(10) = null
	
	set @action = upper(@action)
	
	if (@action in ('INSERT', 'UPDATE', 'DELETE'))
	begin
		if (@action = 'INSERT')
		begin
			exec sp_perGeneratePersonId
					@personId = @personId output
					
			set @id = @personId
		end

		set @value = 'id='							+ dbo.fnc_utilStringCompare(isnull(@id, ''), '', ('"' + @id + '"'), 'NULL') + ', ' +
					 'idCard='						+ dbo.fnc_utilStringCompare(isnull(@idCard, ''), '', ('"' + @idCard + '"'), 'NULL') + ', ' +
					 'idCardIssueDate='				+ dbo.fnc_utilStringCompare(isnull(@idCardIssueDate, ''), '', ('"' + @idCardIssueDate + '"'), 'NULL') + ', ' +
					 'idCardExpiryDate='			+ dbo.fnc_utilStringCompare(isnull(@idCardExpiryDate, ''), '', ('"' + @idCardExpiryDate + '"'), 'NULL') + ', ' +
					 'perTitlePrefixId='			+ dbo.fnc_utilStringCompare(isnull(@titlePrefix, ''), '', ('"' + @titlePrefix + '"'), 'NULL') + ', ' +
					 'firstName='					+ dbo.fnc_utilStringCompare(isnull(@firstName, ''), '', ('"' + @firstName + '"'), 'NULL') + ', ' +
					 'middleName='					+ dbo.fnc_utilStringCompare(isnull(@middleName, ''), '', ('"' + @middleName + '"'), 'NULL') + ', ' +
					 'lastName='					+ dbo.fnc_utilStringCompare(isnull(@lastName, ''), '', ('"' + @lastName + '"'), 'NULL') + ', ' +
					 'enFirstName='					+ dbo.fnc_utilStringCompare(isnull(@firstNameEN, ''), '', ('"' + @firstNameEN + '"'), 'NULL') + ', ' +
					 'enMiddleName='				+ dbo.fnc_utilStringCompare(isnull(@middleNameEN, ''), '', ('"' + @middleNameEN + '"'), 'NULL') + ', ' +
					 'enLastName='					+ dbo.fnc_utilStringCompare(isnull(@lastNameEN, ''), '', ('"' + @lastNameEN + '"'), 'NULL') + ', ' +
					 'perGenderId='					+ dbo.fnc_utilStringCompare(isnull(@gender, ''), '', ('"' + @gender + '"'), 'NULL') + ', ' +
					 'alive='						+ dbo.fnc_utilStringCompare(isnull(@alive, ''), '', ('"' + @alive + '"'), 'NULL') + ', ' +
					 'birthDate='					+ dbo.fnc_utilStringCompare(isnull(@birthDate, ''), '', ('"' + @birthDate + '"'), 'NULL') + ', ' +
					 'plcCountryId='				+ dbo.fnc_utilStringCompare(isnull(@country, ''), '', ('"' + @country + '"'), 'NULL') + ', ' +
					 'perNationalityId='			+ dbo.fnc_utilStringCompare(isnull(@nationality, ''), '', ('"' + @nationality + '"'), 'NULL') + ', ' +
					 'perOriginId='					+ dbo.fnc_utilStringCompare(isnull(@origin, ''), '', ('"' + @origin + '"'), 'NULL') + ', ' +
					 'perReligionId='				+ dbo.fnc_utilStringCompare(isnull(@religion, ''), '', ('"' + @religion + '"'), 'NULL') + ', ' +
					 'perBloodTypeId='				+ dbo.fnc_utilStringCompare(isnull(@bloodType, ''), '', ('"' + @bloodType + '"'), 'NULL') + ', ' +
					 'perMaritalStatusId='			+ dbo.fnc_utilStringCompare(isnull(@maritalStatus, ''), '', ('"' + @maritalStatus + '"'), 'NULL') + ', ' +
					 'perEducationalBackgroundId='	+ dbo.fnc_utilStringCompare(isnull(@educationalBackground, ''), '', ('"' + @educationalBackground + '"'), 'NULL') + ', ' +
					 'email='						+ dbo.fnc_utilStringCompare(isnull(@email, ''), '', ('"' + lower(@email) + '"'), 'NULL') + ', ' +
					 'brotherhoodNumber='			+ dbo.fnc_utilStringCompare(isnull(@brotherhoodNumber, ''), '', ('"' + @brotherhoodNumber + '"'), 'NULL') + ', ' +
					 'childhoodNumber='				+ dbo.fnc_utilStringCompare(isnull(@childhoodNumber, ''), '', ('"' + @childhoodNumber + '"'), 'NULL') + ', ' +
					 'studyhoodNumber='				+ dbo.fnc_utilStringCompare(isnull(@studyhoodNumber, ''), '', ('"' + @studyhoodNumber + '"'), 'NULL')
					 
		begin try
			begin tran
				set @rowCountUpdate = (select count(id) from perPerson with (nolock) where id = @id)

				if (@action = 'INSERT' and @rowCountUpdate = 0)
				begin
 					insert into perPerson
 					(
						id,
						idCard,
						idCardIssueDate,
						idCardExpiryDate,
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
					values
					(
						dbo.fnc_utilStringCompare(isnull(@id, ''), '', @id, null),
						dbo.fnc_utilStringCompare(isnull(@idCard, ''), '', @idCard, null),
						dbo.fnc_utilStringCompare(isnull(@idCardIssueDate, ''), '', convert(datetime, @idCardIssueDate, 103), null),
						dbo.fnc_utilStringCompare(isnull(@idCardExpiryDate, ''), '', convert(datetime, @idCardExpiryDate, 103), null),
						dbo.fnc_utilStringCompare(isnull(@titlePrefix, ''), '', @titlePrefix, null),
						dbo.fnc_utilStringCompare(isnull(@firstName, ''), '', @firstName, null),
						dbo.fnc_utilStringCompare(isnull(@middleName, ''), '', @middleName, null),
						dbo.fnc_utilStringCompare(isnull(@lastName, ''), '', @lastName, null),
						dbo.fnc_utilStringCompare(isnull(@firstNameEN, ''), '', @firstNameEN, null),
						dbo.fnc_utilStringCompare(isnull(@middleNameEN, ''), '', @middleNameEN, null),
						dbo.fnc_utilStringCompare(isnull(@lastNameEN, ''), '', @lastNameEN, null),
						dbo.fnc_utilStringCompare(isnull(@gender, ''), '', @gender, null),
						dbo.fnc_utilStringCompare(isnull(@alive, ''), '', @alive, null),
						dbo.fnc_utilStringCompare(isnull(@birthDate, ''), '', convert(datetime, @birthdate, 103), null),
						dbo.fnc_utilStringCompare(isnull(@country, ''), '', @country, null),
						dbo.fnc_utilStringCompare(isnull(@nationality, ''), '', @nationality, null),
						dbo.fnc_utilStringCompare(isnull(@origin, ''), '', @origin, null),
						dbo.fnc_utilStringCompare(isnull(@religion, ''), '', @religion, null),
						dbo.fnc_utilStringCompare(isnull(@bloodType, ''), '', @bloodType, null),
						dbo.fnc_utilStringCompare(isnull(@maritalStatus, ''), '', @maritalStatus, null),
						dbo.fnc_utilStringCompare(isnull(@educationalBackground, ''), '', @educationalBackground, null),
						dbo.fnc_utilStringCompare(isnull(@email, ''), '', lower(@email), null),
						dbo.fnc_utilStringCompare(isnull(@brotherhoodNumber, ''), '', @brotherhoodNumber, null),
						dbo.fnc_utilStringCompare(isnull(@childhoodNumber, ''), '', @childhoodNumber, null),
						dbo.fnc_utilStringCompare(isnull(@studyhoodNumber, ''), '', @studyhoodNumber, null),						
						getdate(),
						dbo.fnc_utilStringCompare(isnull(@by, ''), '', @by, null),
						dbo.fnc_utilStringCompare(isnull(@ip, ''), '', @ip, null),
						null,
						null,
						null
					)		
					
					set @rowCount = @rowCount + 1
				end
				
				if (@action in ('UPDATE', 'DELETE') and @rowCountUpdate > 0)
				begin
					if (@action = 'UPDATE')
					begin
						update perPerson set
							idCard						= dbo.fnc_utilStringCompare(isnull(@idCard, idCard), isnull(idCard, ''), @idCard, idCard),
							idCardIssueDate				= dbo.fnc_utilStringCompare(isnull(@idCardIssueDate, idCardIssueDate), isnull(idCardIssueDate, ''), convert(datetime, @idCardIssueDate, 103), idCardIssueDate),
							idCardExpiryDate			= dbo.fnc_utilStringCompare(isnull(@idCardExpiryDate, idCardExpiryDate), isnull(idCardExpiryDate, ''), convert(datetime, @idCardExpiryDate, 103), idCardExpiryDate),
							perTitlePrefixId			= dbo.fnc_utilStringCompare(isnull(@titlePrefix, perTitlePrefixId), isnull(perTitlePrefixId, ''), @titlePrefix, perTitlePrefixId),
							firstName					= dbo.fnc_utilStringCompare(isnull(@firstName, firstName), isnull(firstName, ''), @firstName, firstName),
							middleName					= dbo.fnc_utilStringCompare(isnull(@middleName, middleName), isnull(middleName, ''), @middleName, middleName),
							lastName					= dbo.fnc_utilStringCompare(isnull(@lastName, lastName), isnull(lastName, ''), @lastName, lastName),
							enFirstName					= dbo.fnc_utilStringCompare(isnull(@firstNameEN, enFirstName), isnull(enFirstName, ''), @firstNameEN, enFirstName),
							enMiddleName				= dbo.fnc_utilStringCompare(isnull(@middleNameEN, enMiddleName), isnull(enMiddleName, ''), @middleNameEN, enMiddleName),
							enLastName					= dbo.fnc_utilStringCompare(isnull(@lastNameEN, enLastName), isnull(enLastName, ''), @lastNameEN, enLastName),
							perGenderId					= dbo.fnc_utilStringCompare(isnull(@gender, perGenderId), isnull(perGenderId, ''), @gender, perGenderId),
							alive						= dbo.fnc_utilStringCompare(isnull(@alive, alive), isnull(alive, ''), @alive, alive),
							birthDate					= dbo.fnc_utilStringCompare(isnull(@birthDate, birthDate), isnull(birthDate, ''), convert(datetime, @birthdate, 103), birthDate),
							plcCountryId				= dbo.fnc_utilStringCompare(isnull(@country, plcCountryId), isnull(plcCountryId, ''), @country, plcCountryId),
							perNationalityId			= dbo.fnc_utilStringCompare(isnull(@nationality, perNationalityId), isnull(perNationalityId, ''), @nationality, perNationalityId),
							perOriginId					= dbo.fnc_utilStringCompare(isnull(@origin, perOriginId), isnull(perOriginId, ''), @origin, perOriginId),
							perReligionId				= dbo.fnc_utilStringCompare(isnull(@religion, perReligionId), isnull(perReligionId, ''), @religion, perReligionId),
							perBloodTypeId				= dbo.fnc_utilStringCompare(isnull(@bloodType, perBloodTypeId), isnull(perBloodTypeId, ''), @bloodType, perBloodTypeId),
							perMaritalStatusId			= dbo.fnc_utilStringCompare(isnull(@maritalStatus, perMaritalStatusId), isnull(perMaritalStatusId, ''), @maritalStatus, perMaritalStatusId),
							perEducationalBackgroundId	= dbo.fnc_utilStringCompare(isnull(@educationalBackground, perEducationalBackgroundId), isnull(perEducationalBackgroundId, ''), @educationalBackground, perEducationalBackgroundId),
							email						= dbo.fnc_utilStringCompare(isnull(@email, email), isnull(email, ''), lower(@email), email),
							brotherhoodNumber			= dbo.fnc_utilStringCompare(isnull(@brotherhoodNumber, brotherhoodNumber), isnull(brotherhoodNumber, ''), @brotherhoodNumber, brotherhoodNumber),
							childhoodNumber				= dbo.fnc_utilStringCompare(isnull(@childhoodNumber, childhoodNumber), isnull(childhoodNumber, ''), @childhoodNumber, childhoodNumber),
							studyhoodNumber				= dbo.fnc_utilStringCompare(isnull(@studyhoodNumber, studyhoodNumber), isnull(studyhoodNumber, ''), @studyhoodNumber, studyhoodNumber),
							modifyDate					= getdate(),
							modifyBy					= dbo.fnc_utilStringCompare(isnull(@by, modifyBy), isnull(modifyBy, ''), @by, modifyBy),
							modifyIp					= dbo.fnc_utilStringCompare(isnull(@ip, modifyIp), isnull(modifyIp, ''), @ip, modifyIp)
						where (id = @id)
					end								
							
					if (@action = 'DELETE')
					begin
						delete from perPerson where id = @id
					end
							
					set @rowCount = @rowCount + 1							
				end
			commit tran
		end try
		begin catch
			rollback tran
			insert into InfinityLog..sysError
			(
				systemName,
				errorNumber,
				errorMessage,
				hint,
				url,
				logDate
			)
			values
			(			
				@table,
				error_number(),
				error_message(),
				(error_procedure() + ' --> ' + @value),
				null,
				getdate()
			)			
		end catch
	end
	
	select @rowCount, @id
	
	exec sp_stdTransferStudentRecordsToMUStudent
			@personId = @id		
end
