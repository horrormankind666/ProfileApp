USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_plcSetListCountry]    Script Date: 03/28/2014 09:30:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง plcCountry ครั้งละหลายเรคคอร์ด>
--  1. order					เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id						เป็น VARCHAR	รับค่ารหัสประเทศ
--  3. thCountryName			เป็น NVARCHAR	รับค่าชื่อประเทศภาษาไทย
--  4. enCountryName			เป็น NVARCHAR	รับค่าชื่อประเทศภาษาอังกฤษ
--  5. isoCountryCodes2Letter	เป็น VARCHAR	รับค่าชื่อย่อประเทศ 2 ตัว
--  6. isoCountryCodes3Letter	เป็น VARCHAR	รับค่าชื่อย่อประเทศ 3 ตัว
--	7. by						เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_plcSetListCountry]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thCountryName NVARCHAR(MAX) = NULL,
	@enCountryName NVARCHAR(MAX) = NULL,
	@isoCountryCodes2Letter VARCHAR(MAX) = NULL,
	@isoCountryCodes3Letter VARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thCountryName = LTRIM(RTRIM(@thCountryName))
	SET @enCountryName = LTRIM(RTRIM(@enCountryName))
	SET @isoCountryCodes2Letter = LTRIM(RTRIM(@isoCountryCodes2Letter))
	SET @isoCountryCodes3Letter = LTRIM(RTRIM(@isoCountryCodes3Letter))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'plcCountry'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thCountryNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enCountryNameSlice NVARCHAR(MAX) = NULL
	DECLARE @isoCountryCodes2LetterSlice VARCHAR(MAX) = NULL
	DECLARE @isoCountryCodes3LetterSlice VARCHAR(MAX) = NULL
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
		
		SET @thCountryNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thCountryName, @delimiter))
		SET @thCountryName = (SELECT string FROM fnc_perParseString(@thCountryName, @delimiter))
						
		SET @enCountryNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enCountryName, @delimiter))
		SET @enCountryName = (SELECT string FROM fnc_perParseString(@enCountryName, @delimiter))
		
		SET @isoCountryCodes2LetterSlice = (SELECT stringSlice FROM fnc_perParseString(@isoCountryCodes2Letter, @delimiter))
		SET @isoCountryCodes2Letter = (SELECT string FROM fnc_perParseString(@isoCountryCodes2Letter, @delimiter))

		SET @isoCountryCodes3LetterSlice = (SELECT stringSlice FROM fnc_perParseString(@isoCountryCodes3Letter, @delimiter))
		SET @isoCountryCodes3Letter = (SELECT string FROM fnc_perParseString(@isoCountryCodes3Letter, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thCountryName=' + (CASE WHEN (@thCountryNameSlice IS NOT NULL AND LEN(@thCountryNameSlice) > 0 AND CHARINDEX(@thCountryNameSlice, @strBlank) = 0) THEN ('"' + @thCountryNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enCountryName=' + (CASE WHEN (@enCountryNameSlice IS NOT NULL AND LEN(@enCountryNameSlice) > 0 AND CHARINDEX(@enCountryNameSlice, @strBlank) = 0) THEN ('"' + @enCountryNameSlice + '"') ELSE 'NULL' END) + ', ' +
 						 'isoCountryCodes2Letter=' + (CASE WHEN (@isoCountryCodes2LetterSlice IS NOT NULL AND LEN(@isoCountryCodes2LetterSlice) > 0 AND CHARINDEX(@isoCountryCodes2LetterSlice, @strBlank) = 0) THEN ('"' + @isoCountryCodes2LetterSlice + '"') ELSE 'NULL' END) + ', ' +
 						 'isoCountryCodes3Letter=' + (CASE WHEN (@isoCountryCodes3LetterSlice IS NOT NULL AND LEN(@isoCountryCodes3LetterSlice) > 0 AND CHARINDEX(@isoCountryCodes3LetterSlice, @strBlank) = 0) THEN ('"' + @isoCountryCodes3LetterSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO plcCountry
					(
						id,
						thCountryName,
						enCountryName,
						isoCountryCodes2Letter,
						isoCountryCodes3Letter,
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
						CASE WHEN (@thCountryNameSlice IS NOT NULL AND LEN(@thCountryNameSlice) > 0 AND CHARINDEX(@thCountryNameSlice, @strBlank) = 0) THEN @thCountryNameSlice ELSE NULL END,
						CASE WHEN (@enCountryNameSlice IS NOT NULL AND LEN(@enCountryNameSlice) > 0 AND CHARINDEX(@enCountryNameSlice, @strBlank) = 0) THEN @enCountryNameSlice ELSE NULL END,
						CASE WHEN (@isoCountryCodes2LetterSlice IS NOT NULL AND LEN(@isoCountryCodes2LetterSlice) > 0 AND CHARINDEX(@isoCountryCodes2LetterSlice, @strBlank) = 0) THEN @isoCountryCodes2LetterSlice ELSE NULL END,
						CASE WHEN (@isoCountryCodes3LetterSlice IS NOT NULL AND LEN(@isoCountryCodes3LetterSlice) > 0 AND CHARINDEX(@isoCountryCodes3LetterSlice, @strBlank) = 0) THEN @isoCountryCodes3LetterSlice ELSE NULL END,
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
