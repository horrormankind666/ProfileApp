USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetListProvince]    Script Date: 03/28/2014 09:31:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcProvince ครั้งละหลายเรคคอร์ด>
--  1. order		เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id 			เป็น VARCHAR	รับค่ารหัสสถานที่หรือจังหวัด
--  3. plcCountryId	เป็น VARCHAR	รับค่ารหัสประเทศ
--  4. thPlaceName	เป็น NVARCHAR	รับค่าชื่อสถานที่หรือจังหวัดภาษาไทย
--  5. enPlaceName	เป็น NVARCHAR	รับค่าชื่อสถานที่หรือจังหวัดภาษาอังกฤษ
--  6. by			เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcSetListProvince] 
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@plcCountryId VARCHAR(MAX) = NULL,
	@thPlaceName NVARCHAR(MAX) = NULL,
	@enPlaceName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @plcCountryId = LTRIM(RTRIM(@plcCountryId))
	SET @thPlaceName = LTRIM(RTRIM(@thPlaceName))
	SET @enPlaceName = LTRIM(RTRIM(@enPlaceName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'plcProvince'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @plcCountryIdSlice VARCHAR(MAX) = NULL
	DECLARE @thPlaceNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enPlaceNameSlice NVARCHAR(MAX) = NULL
	DECLARE @rowCount INT = 0
	DECLARE @value NVARCHAR(MAX) = NULL	
	DECLARE	@strBlank VARCHAR(50) = '----------**********.........0.0000000000000000000'
	DECLARE @ip VARCHAR(255) = dbo.fnc_perGetIP()
	
	WHILE (LEN(@order) > 0)
	BEGIN
		SET @orderSlice = (SELECT stringSlice FROM fnc_perParseString(@order, @delimiter))
		SET @order = (SELECT string FROM fnc_perParseString(@order, @delimiter))

		SET @idSlice = (SELECT stringSlice FROM fnc_perParseString(@id, @delimiter))
		SET @id = (SELECT string FROM fnc_perParseString(@id, @delimiter))
		
		SET @plcCountryIdSlice = (SELECT stringSlice FROM fnc_perParseString(@plcCountryId, @delimiter))
		SET @plcCountryId = (SELECT string FROM fnc_perParseString(@plcCountryId, @delimiter))

		SET @thPlaceNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thPlaceName, @delimiter))
		SET @thPlaceName = (SELECT string FROM fnc_perParseString(@thPlaceName, @delimiter))
						
		SET @enPlaceNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enPlaceName, @delimiter))
		SET @enPlaceName = (SELECT string FROM fnc_perParseString(@enPlaceName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'plcCountryId=' + (CASE WHEN (@plcCountryIdSlice IS NOT NULL AND LEN(@plcCountryIdSlice) > 0 AND CHARINDEX(@plcCountryIdSlice, @strBlank) = 0) THEN ('"' + @plcCountryIdSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thPlaceName=' + (CASE WHEN (@thPlaceNameSlice IS NOT NULL AND LEN(@thPlaceNameSlice) > 0 AND CHARINDEX(@thPlaceNameSlice, @strBlank) = 0) THEN ('"' + @thPlaceNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enPlaceName=' + (CASE WHEN (@enPlaceNameSlice IS NOT NULL AND LEN(@enPlaceNameSlice) > 0 AND CHARINDEX(@enPlaceNameSlice, @strBlank) = 0) THEN ('"' + @enPlaceNameSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO plcProvince
					(
						id,
						plcCountryId,
						thPlaceName,
						enPlaceName,
						createDate,
						createBy,
						createIp,
						modifyDate,
						modifyBy,
						modifyIp					
					)
					VALUES
					(
						CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN @idSlice ELSE NULL END,
						CASE WHEN (@plcCountryIdSlice IS NOT NULL AND LEN(@plcCountryIdSlice) > 0 AND CHARINDEX(@plcCountryIdSlice, @strBlank) = 0) THEN @plcCountryIdSlice ELSE NULL END,
						CASE WHEN (@thPlaceNameSlice IS NOT NULL AND LEN(@thPlaceNameSlice) > 0 AND CHARINDEX(@thPlaceNameSlice, @strBlank) = 0) THEN @thPlaceNameSlice ELSE NULL END,
						CASE WHEN (@enPlaceNameSlice IS NOT NULL AND LEN(@enPlaceNameSlice) > 0 AND CHARINDEX(@enPlaceNameSlice, @strBlank) = 0) THEN @enPlaceNameSlice ELSE NULL END,
						GETDATE(),
						CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
						@ip,
						NULL,
						NULL,
						NULL
					)
				COMMIT TRAN
				SET @rowCount = @rowCount + 1
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				INSERT INTO perErrorLog
				(
					errorDatabase,
					errorTable,
					errorAction,
					errorValue,
					errorMessage,
					errorNumber,
					errorSeverity,
					errorState,
					errorLine,
					errorProcedure,
					errorActionDate,
					errorActionBy,
					errorIp
				)
				VALUES
				(
					DB_NAME(),
					@table,
					@action,
					@value,
					ERROR_MESSAGE(),
					ERROR_NUMBER(),
					ERROR_SEVERITY(),
					ERROR_STATE(),
					ERROR_LINE(),
					ERROR_PROCEDURE(),
					GETDATE(),
					CASE WHEN (@by IS NOT NULL AND LEN(@by) > 0 AND CHARINDEX(@by, @strBlank) = 0) THEN @by ELSE NULL END,
					@ip
				)				
			END CATCH							 
		END		
	END

	SELECT @rowCount			
END
