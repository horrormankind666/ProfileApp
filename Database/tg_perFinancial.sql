USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perFinancial]    Script Date: 05/22/2015 11:59:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๑๘/๑๒/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perFinancial หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perFinancial]
   ON [dbo].[perFinancial]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perFinancial'
    DECLARE @action VARCHAR(10) = NULL

	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..perFinancialLog
		(
			perPersonId,
			scholarshipFirstBachelor,
			scholarshipFirstBachelorFrom,
			scholarshipFirstBachelorName,
			scholarshipFirstBachelorMoney,
			scholarshipBachelor,
			scholarshipBachelorFrom,
			scholarshipBachelorName,
			scholarshipBachelorMoney,
			worked,
			salary,
			workplace,
			gotMoneyFrom,
			gotMoneyFromOther,
			gotMoneyPerMonth,
			costPerMonth,
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
			
			INSERT INTO InfinityLog..perFinancialLog
			(
				perPersonId,
				scholarshipFirstBachelor,
				scholarshipFirstBachelorFrom,
				scholarshipFirstBachelorName,
				scholarshipFirstBachelorMoney,
				scholarshipBachelor,
				scholarshipBachelorFrom,
				scholarshipBachelorName,
				scholarshipBachelorMoney,
				worked,
				salary,
				workplace,
				gotMoneyFrom,
				gotMoneyFromOther,
				gotMoneyPerMonth,
				costPerMonth,
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
