USE [MUStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_perSetListNationality]    Script Date: 03/27/2014 11:50:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๐/๑๑/๒๕๕๖>
-- Description	: <สำหรับบันทึกข้อมูลตาราง perNationality ครั้งละหลายเรคคอร์ด>
--  1. order				เป็น VARCHAR	รับค่าลำดับของเรคคอร์ด
--  2. id					เป็น VARCHAR	รับค่ารหัสสัญชาติหรือเชื้อชาติ
--  3. thNationalityName	เป็น NVARCHAR	รับค่าชื่อสัญชาติหรือเชื้อชาติภาษาไทย
--  4. enNationalityName	เป็น NVARCHAR	รับค่าชื่อสัญชาติหรือเชื้อชาติภาษาอังกฤษ
--  5. by					เป็น NVARCHAR	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER PROCEDURE [dbo].[sp_perSetListNationality]
(
	@order VARCHAR(MAX) = NULL,
	@id VARCHAR(MAX) = NULL,
	@thNationalityName NVARCHAR(MAX) = NULL,
	@enNationalityName NVARCHAR(MAX) = NULL,
	@by NVARCHAR(255) = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @order = LTRIM(RTRIM(@order))
	SET @id = LTRIM(RTRIM(@id))
	SET @thNationalityName = LTRIM(RTRIM(@thNationalityName))
	SET @enNationalityName = LTRIM(RTRIM(@enNationalityName))
	SET @by = LTRIM(RTRIM(@by))
	
	DECLARE @action VARCHAR(10) = 'INSERT'
	DECLARE @table VARCHAR(50) = 'perNationality'
	DECLARE @i INT = 1
	DECLARE @delimiter CHAR(1) = ';'
	DECLARE @orderSlice VARCHAR(MAX) = NULL
	DECLARE @idSlice VARCHAR(MAX) = NULL
	DECLARE @thNationalityNameSlice NVARCHAR(MAX) = NULL
	DECLARE @enNationalityNameSlice NVARCHAR(MAX) = NULL
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
		
		SET @thNationalityNameSlice = (SELECT stringSlice FROM fnc_perParseString(@thNationalityName, @delimiter))
		SET @thNationalityName = (SELECT string FROM fnc_perParseString(@thNationalityName, @delimiter))
						
		SET @enNationalityNameSlice = (SELECT stringSlice FROM fnc_perParseString(@enNationalityName, @delimiter))
		SET @enNationalityName = (SELECT string FROM fnc_perParseString(@enNationalityName, @delimiter))

		IF (LEN(@orderSlice) > 0)
		BEGIN			
			SET @value = 'id=' + (CASE WHEN (@idSlice IS NOT NULL AND LEN(@idSlice) > 0 AND CHARINDEX(@idSlice, @strBlank) = 0) THEN ('"' + @idSlice + '"') ELSE 'NULL' END) + ', ' +
						 'thNationalityName=' + (CASE WHEN (@thNationalityNameSlice IS NOT NULL AND LEN(@thNationalityNameSlice) > 0 AND CHARINDEX(@thNationalityNameSlice, @strBlank) = 0) THEN ('"' + @thNationalityNameSlice + '"') ELSE 'NULL' END) + ', ' +
						 'enNationalityName=' + (CASE WHEN (@enNationalityNameSlice IS NOT NULL AND LEN(@enNationalityNameSlice) > 0 AND CHARINDEX(@enNationalityNameSlice, @strBlank) = 0) THEN ('"' + @enNationalityNameSlice + '"') ELSE 'NULL' END)
						 						 
			BEGIN TRY
				BEGIN TRAN	
					INSERT INTO perNationality
					(
						id,
						thNationalityName,
						enNationalityName,
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
						CASE WHEN (@thNationalityNameSlice IS NOT NULL AND LEN(@thNationalityNameSlice) > 0 AND CHARINDEX(@thNationalityNameSlice, @strBlank) = 0) THEN @thNationalityNameSlice ELSE NULL END,
						CASE WHEN (@enNationalityNameSlice IS NOT NULL AND LEN(@enNationalityNameSlice) > 0 AND CHARINDEX(@enNationalityNameSlice, @strBlank) = 0) THEN @enNationalityNameSlice ELSE NULL END,
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
