USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perActivity]    Script Date: 05/22/2015 11:35:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๗/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perActivity หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perActivity]
   ON [dbo].[perActivity]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perActivity'
    DECLARE @action VARCHAR(10) = NULL

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..perActivityLog
		(
			perPersonId,
			sportsman,
			sportsmanDetail,
			specialist,
			specialistSport,
			specialistSportDetail,
			specialistArt,
			specialistArtDetail,
			specialistTechnical,
			specialistTechnicalDetail,
			specialistOther,
			specialistOtherDetail,
			activity,
			activityDetail,
			reward,
			rewardDetail,
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
			
			INSERT INTO InfinityLog..perActivityLog
			(
				perPersonId,
				sportsman,
				sportsmanDetail,
				specialist,
				specialistSport,
				specialistSportDetail,
				specialistArt,
				specialistArtDetail,
				specialistTechnical,
				specialistTechnicalDetail,
				specialistOther,
				specialistOtherDetail,
				activity,
				activityDetail,
				reward,
				rewardDetail,
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
