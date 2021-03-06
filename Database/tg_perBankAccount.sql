USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perBankAccount]    Script Date: 12/23/2014 09:20:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๓/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perBankAccount หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perBankAccount]
   ON [dbo].[perBankAccount]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perBankAccount'
    DECLARE @action VARCHAR(10) = NULL
    DECLARE @value NVARCHAR(MAX) = NULL
    DECLARE @actionDate DATETIME = NULL
    DECLARE @actionBy NVARCHAR(255) = NULL

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		SET @value = 'perPersonId=' + (SELECT (CASE WHEN (perPersonId IS NOT NULL AND LEN(perPersonId) > 0) THEN ('"' + perPersonId + '"') ELSE 'NULL' END) FROM inserted) + ', '

		IF EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @action = 'UPDATE'
			SET @value += 'bankCode=' + (SELECT (CASE WHEN (bankCode IS NOT NULL AND LEN(bankCode) > 0) THEN ('"' + bankCode + '"') ELSE 'NULL' END) FROM deleted) + ', ' +
						  'bankCodeNew=' + (SELECT (CASE WHEN (bankCode IS NOT NULL AND LEN(bankCode) > 0) THEN ('"' + bankCode + '"') ELSE 'NULL' END) FROM inserted) + ', '
			SET @actionDate = (SELECT (CASE WHEN (modifyDate IS NOT NULL AND LEN(modifyDate) > 0) THEN modifyDate ELSE NULL END) FROM inserted)
			SET @actionBy = (SELECT (CASE WHEN (modifyBy IS NOT NULL AND LEN(modifyBy) > 0) THEN modifyBy ELSE NULL END) FROM inserted)
		END
		ELSE
			BEGIN
				SET @action = 'INSERT'
				SET @value += 'bankCode=' + (SELECT (CASE WHEN (bankCode IS NOT NULL AND LEN(bankCode) > 0) THEN ('"' + bankCode + '"') ELSE 'NULL' END) FROM inserted) + ', '
				SET @actionDate = (SELECT (CASE WHEN (createDate IS NOT NULL AND LEN(createDate) > 0) THEN createDate ELSE NULL END) FROM inserted)
				SET @actionBy = (SELECT (CASE WHEN (createBy IS NOT NULL AND LEN(createBy) > 0) THEN createBy ELSE NULL END) FROM inserted)
			END
			
		SET @value += 'accNo=' + (SELECT (CASE WHEN (accNo IS NOT NULL AND LEN(accNo) > 0) THEN ('"' + accNo + '"') ELSE 'NULL' END) FROM inserted) + ', ' +
					  'cancel=' + (SELECT (CASE WHEN (cancel IS NOT NULL AND LEN(cancel) > 0) THEN ('"' + cancel + '"') ELSE 'NULL' END) FROM inserted)
	END
	ELSE
		BEGIN
			SET @action = 'DELETE'
			SET @value = 'perPersonId=' + (SELECT (CASE WHEN (perPersonId IS NOT NULL AND LEN(perPersonId) > 0) THEN ('"' + perPersonId + '"') ELSE 'NULL' END) FROM deleted) + ', ' +
						 'bankCode=' + (SELECT (CASE WHEN (bankCode IS NOT NULL AND LEN(bankCode) > 0) THEN ('"' + bankCode + '"') ELSE 'NULL' END) FROM deleted)
		END

	INSERT INTO perTransactionLog
	(
		logDatabase,
		logTable,
		logAction,
		logValue,
		logActionDate,
		logActionBy,
		logCreateDate,
		logCreateBy,
		logIp
	)
	VALUES
	(		
		DB_NAME(),
		@table,
		@action,
		@value,
		@actionDate,
		@actionBy,
		GETDATE(),
		SYSTEM_USER,
		dbo.fnc_perGetIP()
	)							
END
