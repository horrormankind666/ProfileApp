USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perParent]    Script Date: 05/22/2015 12:08:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๖/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perParent หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perParent]
   ON [dbo].[perParent]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perParent'
    DECLARE @action VARCHAR(10) = NULL
    
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..perParentLog
		(
			perPersonId,
			perPersonIdFather,
			perPersonIdMother,
			perPersonIdParent,
			perRelationshipId,
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
			
			INSERT INTO InfinityLog..perParentLog
			(
				perPersonId,
				perPersonIdFather,
				perPersonIdMother,
				perPersonIdParent,
				perRelationshipId,
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
