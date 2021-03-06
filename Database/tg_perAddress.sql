USE [Infinity]
GO
/****** Object:  Trigger [dbo].[tg_perAddress]    Script Date: 05/22/2015 11:09:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ยุทธภูมิ ตวันนา>
-- Create date: <๒๙/๑๑/๒๕๕๖>
-- Description:	<สำหรับบันทึกข้อมูล Transaction ของตาราง perAddress หลังจากที่มีการ INSERT, DELETE, UPDATE>
-- =============================================
ALTER TRIGGER [dbo].[tg_perAddress]
   ON [dbo].[perAddress]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE @table VARCHAR(50) = 'perAddress'
    DECLARE @action VARCHAR(10) = NULL
        
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
			SET @action = 'UPDATE'
		ELSE
			SET @action = 'INSERT'
			
		INSERT INTO InfinityLog..perAddressLog
		(
			perPersonId,
			plcCountryIdPermanent,
			villagePermanent,
			noPermanent,
			mooPermanent,
			soiPermanent,
			roadPermanent,
			plcSubdistrictIdPermanent,
			plcDistrictIdPermanent,
			plcProvinceIdPermanent,
			zipCodePermanent,
			phoneNumberPermanent,
			mobileNumberPermanent,
			faxNumberPermanent,
			plcCountryIdCurrent,
			villageCurrent,
			noCurrent,
			mooCurrent,
			soiCurrent,
			roadCurrent,
			plcSubdistrictIdCurrent,
			plcDistrictIdCurrent,
			plcProvinceIdCurrent,
			zipCodeCurrent,
			phoneNumberCurrent,
			mobileNumberCurrent,
			faxNumberCurrent,
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
			
			INSERT INTO InfinityLog..perAddressLog
			(
				perPersonId,
				plcCountryIdPermanent,
				villagePermanent,
				noPermanent,
				mooPermanent,
				soiPermanent,
				roadPermanent,
				plcSubdistrictIdPermanent,
				plcDistrictIdPermanent,
				plcProvinceIdPermanent,
				zipCodePermanent,
				phoneNumberPermanent,
				mobileNumberPermanent,
				faxNumberPermanent,
				plcCountryIdCurrent,
				villageCurrent,
				noCurrent,
				mooCurrent,
				soiCurrent,
				roadCurrent,
				plcSubdistrictIdCurrent,
				plcDistrictIdCurrent,
				plcProvinceIdCurrent,
				zipCodeCurrent,
				phoneNumberCurrent,
				mobileNumberCurrent,
				faxNumberCurrent,
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
