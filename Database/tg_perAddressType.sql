USE [MUStudent]
GO
/****** Object:  Trigger [dbo].[tg_perAddressType]    Script Date: 11/27/2013 13:24:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๓/๑๑/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perAddressType หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perAddressType]
   ON [dbo].[perAddressType]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perAddressType'
    DECLARE @action VARCHAR(10) = NULL
    DECLARE @value NVARCHAR(MAX) = NULL
    DECLARE @actionDate DATETIME = NULL
    DECLARE @actionBy NVARCHAR(255) = NULL

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		SET @value = 'id=' + (SELECT (CASE WHEN (id IS NOT NULL AND LEN(id) > 0) THEN ('"' + id + '"') ELSE 'NULL' END) FROM inserted) + ', ' +
					 'thAddressTypeName=' + (SELECT (CASE WHEN (thAddressTypeName IS NOT NULL AND LEN(thAddressTypeName) > 0) THEN ('"' + thAddressTypeName + '"') ELSE 'NULL' END) FROM inserted) + ', ' +
					 'enAddressTypeName=' + (SELECT (CASE WHEN (enAddressTypeName IS NOT NULL AND LEN(enAddressTypeName) > 0) THEN ('"' + enAddressTypeName + '"') ELSE 'NULL' END) FROM inserted)

		IF EXISTS (SELECT * FROM deleted)
		BEGIN
			SET @action = 'UPDATE'
			SET @actionDate = (SELECT (CASE WHEN (modifyDate IS NOT NULL AND LEN(modifyDate) > 0) THEN modifyDate ELSE NULL END) FROM inserted)
			SET @actionBy = (SELECT (CASE WHEN (modifyBy IS NOT NULL AND LEN(modifyBy) > 0) THEN modifyBy ELSE NULL END) FROM inserted)
		END
		ELSE
			BEGIN
				SET @action = 'INSERT'
				SET @actionDate = (SELECT (CASE WHEN (createDate IS NOT NULL AND LEN(createDate) > 0) THEN createDate ELSE NULL END) FROM inserted)
				SET @actionBy = (SELECT (CASE WHEN (createBy IS NOT NULL AND LEN(createBy) > 0) THEN createBy ELSE NULL END) FROM inserted)
			END
	END
	ELSE
		BEGIN
			SET @action = 'DELETE'
			SET @value = 'id=' + (SELECT (CASE WHEN (id IS NOT NULL AND LEN(id) > 0) THEN ('"' + id + '"') ELSE 'NULL' END) FROM deleted)
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
