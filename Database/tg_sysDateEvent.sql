USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_sysDateEvent]    Script Date: 06/15/2015 08:43:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๕/๐๖/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง sysDateEvent หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_sysDateEvent]
   ON [dbo].[sysDateEvent]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'sysDateEvent'
    DECLARE @action VARCHAR(10) = NULL
    
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..sysDateEventLog
		(
			sysDateEventId,
			sysName,
			sysEvent,
			startDate,
			endDate,
			yearEntry,
			entranceType,
			facultyprogram,
			semester,
			fileName,
			cancelStatus,
			createdBy,
			createdDate,
			remark,
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
END