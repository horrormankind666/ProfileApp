USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_ecpProgramScholarships]    Script Date: 18/1/2559 13:10:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูล Transaction ของตาราง ecpProgramScholarships หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_ecpProgramScholarships]
   ON [dbo].[ecpProgramScholarships]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE @table VARCHAR(50) = 'ecpProgramScholarships'
    DECLARE @action VARCHAR(10) = NULL
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..ecpProgramScholarshipsLog
		(
			ecpProgramContractId,
			amountScholarship,
			cancelledStatus,
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

			INSERT INTO InfinityLog..ecpProgramScholarshipsLog
			(
				ecpProgramContractId,
				amountScholarship,
				cancelledStatus,
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
