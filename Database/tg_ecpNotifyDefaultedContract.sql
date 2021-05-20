SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูล Transaction ของตาราง ecpNotifyDefaultedContract หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
CREATE TRIGGER [dbo].[tg_ecpNotifyDefaultedContract]
   ON [dbo].[ecpNotifyDefaultedContract]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE @table VARCHAR(50) = 'ecpNotifyDefaultedContract'
    DECLARE @action VARCHAR(10) = NULL
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..ecpNotifyDefaultedContractLog
		(
			ecpNotifyDefaultedContractId,
			stdStudentCode,
			perTitlePrefixId,
			perTitlePrefixFullNameTH,
			perTitlePrefixInitialsTH,
			perTitlePrefixFullNameEN,
			perTitlePrefixInitialsEN,
			firstNameEN,
			middleNameEN,
			lastNameEN,
			firstName,
			middleName,
			lastName,
			acaFacultyId,
			acaFacultyCode,
			acaFacultyNameTH,
			acaProgramId,
			acaProgramCode,
			acaProgramNameTH,
			acaProgramMajorCode,
			acaProgramGroupNum,
			acaProgramDLevel,
			yearAttended,
			pursuantBook,
			pursuant,
			pursuantBookDate,
			location,
			inputDate,
			stateLocation,
			stateLocationDate,
			contractDate,
			contractDateAgreement,
			guarantor,
			scholarshipStatus,
			scholarshipAmount,
			scholarshipYear,
			scholarshipMonth,
			graduateStatus,
			educationDate,
			graduateDate,
			publicServantStatus,
			contractEffectiveStartDate,
			contractEffectiveEndDate,			
			ecpConditionFormulaCalculationId,
			periodWork,
			amountCash,
			notifiedStatus,
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

			INSERT INTO InfinityLog..ecpNotifyDefaultedContractLog
			(
				ecpNotifyDefaultedContractId,
				stdStudentCode,
				perTitlePrefixId,
				perTitlePrefixFullNameTH,
				perTitlePrefixInitialsTH,
				perTitlePrefixFullNameEN,
				perTitlePrefixInitialsEN,
				firstNameEN,
				middleNameEN,
				lastNameEN,
				firstName,
				middleName,
				lastName,
				acaFacultyId,
				acaFacultyCode,
				acaFacultyNameTH,
				acaProgramId,
				acaProgramCode,
				acaProgramNameTH,
				acaProgramMajorCode,
				acaProgramGroupNum,
				acaProgramDLevel,
				yearAttended,
				pursuantBook,
				pursuant,
				pursuantBookDate,
				location,
				inputDate,
				stateLocation,
				stateLocationDate,
				contractDate,
				contractDateAgreement,
				guarantor,
				scholarshipStatus,
				scholarshipAmount,
				scholarshipYear,
				scholarshipMonth,
				graduateStatus,
				educationDate,
				graduateDate,
				publicServantStatus,
				contractEffectiveStartDate,
				contractEffectiveEndDate,				
				ecpConditionFormulaCalculationId,
				periodWork,
				amountCash,
				notifiedStatus,
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
