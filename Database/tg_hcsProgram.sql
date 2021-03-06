USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_hcsProgram]    Script Date: 12/02/2015 12:33:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๒/๑๒/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง hcsProgram หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_hcsProgram]
   ON [dbo].[hcsProgram1]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'hcsProgram'
    DECLARE @action VARCHAR(10) = NULL
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..hcsProgramLog
		(
			acaProgramId,
			hcsHospitalId,
			hcsRegistrationFormId,
			showRARegisForm,
			showSIRegisForm,
			showRAPatientRegisForm,
			showSIPatientRegisForm,
			showTMPatientRegisForm,
			showGJPatientRegisForm,
			showKN001Form,
			showKN002Form,
			showKN003Form,
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
			
			INSERT INTO InfinityLog..hcsProgramLog
			(
				acaProgramId,
				hcsHospitalId,
				hcsRegistrationFormId,
				showRARegisForm,
				showSIRegisForm,
				showRAPatientRegisForm,
				showSIPatientRegisForm,
				showTMPatientRegisForm,
				showGJPatientRegisForm,
				showKN001Form,
				showKN002Form,
				showKN003Form,
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
