USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_hcsAgency]    Script Date: 4/4/2559 8:43:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๒/๑๒/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง hcsAgency หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_hcsAgency]
   ON [dbo].[hcsAgency]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE @table VARCHAR(50) = 'hcsAgency'
    DECLARE @action VARCHAR(10) = NULL
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..hcsAgencyLog
		(
			yearEntry,
			acaProgramId,
			hcsHospitalId,
			hcsRegistrationFormId,
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
			
			INSERT INTO InfinityLog..hcsAgencyLog
			(
				yearEntry,
				acaProgramId,
				hcsHospitalId,
				hcsRegistrationFormId,
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
