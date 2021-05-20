USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perPerson]    Script Date: 07/06/2015 08:41:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๐๖/๐๗/๒๕๕๘>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง udsUploadLog หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
CREATE TRIGGER [dbo].[tg_udsUploadLog] 
   ON [dbo].[udsUploadLog]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'udsUploadLog'
    DECLARE @action VARCHAR(10) = NULL
    
	IF EXISTS (SELECT * FROM inserted)
	BEGIN					 
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..udsUploadLog
		(
			perPersonId,
			profilepictureFileName,
			profilepictureSave,
			profilepictureSaveDate,
			profilepictureSubmit,
			profilepictureSubmitDate,
			profilepictureApprove,
			profilepictureApproveDate,
			profilepictureApproveBy,
			profilepictureApproveIP,
			profilepictureMessage,
			identitycardFileName,
			identitycardSave,
			identitycardSaveDate,
			identitycardSubmit,
			identitycardSubmitDate,
			identitycardApprove,
			identitycardApproveDate,
			identitycardApproveBy,
			identitycardApproveIP,
			identitycardMessage,
			transcriptfrontsideFileName,
			transcriptfrontsideSave,
			transcriptfrontsideSaveDate,
			transcriptfrontsideSubmit,
			transcriptfrontsideSubmitDate,
			transcriptfrontsideApprove,
			transcriptfrontsideApproveDate,
			transcriptfrontsideApproveBy,
			transcriptfrontsideApproveIP,
			transcriptfrontsideMessage,
			transcriptbacksideFileName,
			transcriptbacksideSave,
			transcriptbacksideSaveDate,
			transcriptbacksideSubmit,
			transcriptbacksideSubmitDate,
			transcriptbacksideApprove,
			transcriptbacksideApproveDate,
			transcriptbacksideApproveBy,
			transcriptbacksideApproveIP,
			transcriptbacksideMessage,
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
			
			INSERT INTO InfinityLog..udsUploadLog
			(
				perPersonId,
				profilepictureFileName,
				profilepictureSave,
				profilepictureSaveDate,
				profilepictureSubmit,
				profilepictureSubmitDate,
				profilepictureApprove,
				profilepictureApproveDate,
				profilepictureApproveBy,
				profilepictureApproveIP,
				profilepictureMessage,
				identitycardFileName,
				identitycardSave,
				identitycardSaveDate,
				identitycardSubmit,
				identitycardSubmitDate,
				identitycardApprove,
				identitycardApproveDate,
				identitycardApproveBy,
				identitycardApproveIP,
				identitycardMessage,
				transcriptfrontsideFileName,
				transcriptfrontsideSave,
				transcriptfrontsideSaveDate,
				transcriptfrontsideSubmit,
				transcriptfrontsideSubmitDate,
				transcriptfrontsideApprove,
				transcriptfrontsideApproveDate,
				transcriptfrontsideApproveBy,
				transcriptfrontsideApproveIP,
				transcriptfrontsideMessage,
				transcriptbacksideFileName,
				transcriptbacksideSave,
				transcriptbacksideSaveDate,
				transcriptbacksideSubmit,
				transcriptbacksideSubmitDate,
				transcriptbacksideApprove,
				transcriptbacksideApproveDate,
				transcriptbacksideApproveBy,
				transcriptbacksideApproveIP,
				transcriptbacksideMessage,
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


