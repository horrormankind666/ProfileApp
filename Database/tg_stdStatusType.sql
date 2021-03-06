USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_stdStatusType]    Script Date: 12/25/2015 11:30:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๒/๐๕/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง stdStatusType หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_stdStatusType]
   ON [dbo].[stdStatusType]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'stdStatusType'
    DECLARE @action VARCHAR(10) = NULL

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..stdStatusTypeLog
		(
			stdStatusTypeId,
			nameTh,
			nameEn,
			[group],
			remark,
			cancelStatus,
			cancelDate,
			createdDate,
			createdBy,
			oldId,
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
			
			INSERT INTO InfinityLog..stdStatusTypeLog
			(
				stdStatusTypeId,
				nameTh,
				nameEn,
				[group],
				remark,
				cancelStatus,
				cancelDate,
				createdDate,
				createdBy,
				oldId,
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