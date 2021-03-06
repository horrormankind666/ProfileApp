USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_ecpIndemnityAgreement]    Script Date: 18/1/2559 12:59:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๑/๒๕๕๙>
-- Description	: <สำหรับบันทึกข้อมูล Transaction ของตาราง ecpIndemnityAgreement หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_ecpIndemnityAgreement]
   ON [dbo].[ecpIndemnityAgreement]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE @table VARCHAR(50) = 'ecpIndemnityAgreement'
    DECLARE @action VARCHAR(10) = NULL
	
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'

		INSERT INTO InfinityLog..ecpIndemnityAgreementLog
		(
			ecpProgramContractId,
			caseGraduation,
			amountCash,
			periodWorkAfterGraduation,
			ecpConditionFormulaCalculationId,
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

			INSERT INTO InfinityLog..ecpIndemnityAgreementLog
			(
				ecpProgramContractId,
				caseGraduation,
				amountCash,
				periodWorkAfterGraduation,
				ecpConditionFormulaCalculationId,
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
