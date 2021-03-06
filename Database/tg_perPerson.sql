USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perPerson]    Script Date: 05/22/2015 10:55:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๖/๑๑/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perPerson หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perPerson] 
   ON [dbo].[perPerson]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perPerson'
    DECLARE @action VARCHAR(10) = NULL
    
	IF EXISTS (SELECT * FROM inserted)
	BEGIN					 
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..perPersonLog
		(
			perPersonId,
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
			modifyIp,
			logDatabase,
			logTable,
			logAction,
			logActionDate,
			logActionBy,
			logIp
		)
		SELECT	*,
				DB_NAME(),
				@table,
				@action,
				GETDATE(),
				SYSTEM_USER,
				dbo.fnc_perGetIP()
		FROM	inserted		
	END
	ELSE
		BEGIN
			SET @action = 'DELETE'
			
			INSERT INTO InfinityLog..perPersonLog
			(
				perPersonId,
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
				modifyIp,
				logDatabase,
				logTable,
				logAction,
				logActionDate,
				logActionBy,
				logIp
			)
			SELECT	*,
					DB_NAME(),
					@table,
					@action,
					GETDATE(),
					SYSTEM_USER,
					dbo.fnc_perGetIP()
			FROM	deleted			
		END
END


